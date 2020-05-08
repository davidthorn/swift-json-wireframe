//
//  WireframeData.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

/// Things to fix.

/// The routes are not being handled
/// tabItems warning of zero tabItems
/// tabItems cannot contain their own name
/// navigation buttons is not displaying errors
/// presentationStyle present in a navigation / subroute is not presenting

import Foundation

// MARK: - Implementation -

public class WireframeData: Codable {
    var isCalled: Bool = false
    public let appName: String
    public var routes: [RouteImpl]
    public let root: RouteName
    public var navigations: [Navigation]?

    public var datasource: WireframeDatasource?

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case appName
        case routes
        case root
        case navigations
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        appName = try container.debugDecode(String.self, forKey: .appName, parent: Self.self)
        root = try container.debugDecode(String.self, forKey: .root, parent: Self.self)
        do {
            routes = try container.decode([RouteImpl].self, forKey: .routes)
        } catch let error {
            throw error
        }

        do {
            navigations = try container.decodeIfPresent([Navigation].self, forKey: .navigations)
        } catch let error {
            throw error
        }

    }

}

// MARK: - Extension - KeyedDecodingContainer -

extension KeyedDecodingContainer where K == WireframeData.CodingKeys {

    func debugDecode<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parent: Decodable.Type) throws -> T {
        do {
            return try decode(T.self, forKey: key)
        } catch {
            debugPrint("Decoding Error: \(String(describing: parent.self)) \(key.stringValue): could not be decoded")
            debugPrint("File: \(#file) Line: \(#line)")
            debugPrint(K.allCases)
            throw WireframeError.wireframeDataDecoding(key)
        }

    }

    func debugDecodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parent: Decodable.Type) throws -> T? {
           do {
               return try decodeIfPresent(T.self, forKey: key)
           } catch {
               debugPrint("Decoding Error: \(String(describing: parent.self)) \(key.stringValue): could not be decoded")
                debugPrint("File: \(#file) Line: \(#line)")
               debugPrint(K.allCases)
               throw WireframeError.wireframeDataDecoding(key)
           }

       }

}

// MARK: - Extension - WireframeData -

public extension WireframeData {

    /// Returns a route if the wireframe contains one with this name.
    /// - Parameter name: The name of the route that should be returned.
    /// - Returns: The route that has this name.
    func route(for name: String) -> Route? {
        routes.first { $0.name == name }
    }


    func setDefaultRoutes() {
        RouteImpl.defaultRoutes.forEach { defaultRoute in

            if !routes.contains(where: { $0.name == defaultRoute.name }) {
                debugPrint("Auto Registering route: \(defaultRoute.name)")
                routes.append(defaultRoute)
            }
        }
    }


    /// Sets all routes wireframe property to that of this wireframe data.
    func setRoutes() throws {
        assert(isCalled == false)
        isCalled = true

        var routeNames = Set<String>()
        try routes.forEach { route in
            if routeNames.contains(route.name) {
                throw WireframeError.routeNameAlreadyExist(route.name)
            }
            routeNames.insert(route.name)
        }

        try validateRoutesTabBarItems()

        routes.forEach { route in
            route.datasource = nil
            route.wireframe = nil
        }

        let wireframe = self
        try routes.forEach { route in
            try route.set(wireframeData: wireframe)
            if !RouteImpl.defaultRoutes.contains(where: { $0.name == route.name }) {
                debugPrint("Registerd Route name: \(route.name)")
            }
        }

        try routes.forEach { route in
            try route.setNavigation()
            try route.setSubRoutes()
        }

        try validateNavigationButtonTargets()
    }

}

extension WireframeData {

    func validateRoutesTabBarItems() throws {
        try routes
            .filter { $0.type == .tabbar && $0.tabItems.isNotNil }
            .map { (route: $0, tabItems: $0.tabItems ?? []) }
            .forEach(validateTabBarItems)
    }

    func validateTabBarItems(info: (route: Route, tabItems: [RouteName])) throws {
        try info.tabItems.forEach { tabItem in
            try self.validateTabItemExists(name: tabItem, route: info.route)
        }
    }

    func validateTabItemExists(name: RouteName , route: Route) throws {
        if !routes.contains(where: { $0.name == name }) {
            throw WireframeError.tabItemNotExist(route, name)
        }
    }

}

extension WireframeData {

    func validateNavigationButtonTargets() throws {
        let targets = routes
            .compactMap({ $0.navigation })
            .flatMap { $0.buttons }
            .map { $0.target }

        var navigationTartgets = navigations?
            .compactMap { $0 }
            .flatMap {
                $0.buttons.map { $0.target }

            } ?? []

        navigationTartgets.append(contentsOf: targets)

        try navigationTartgets
            .forEach { target in
            if !routes.contains(where: { $0.name == target }) {
                throw WireframeError.navigationButtonTargetNotExists(target)
            }
        }
    }

}

// MARK: - Extension - Hashable -

extension WireframeData: Hashable {

    public static func == (lhs: WireframeData, rhs: WireframeData) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(appName)
        hasher.combine(routes)
        hasher.combine(root)
    }

}

// MARK: - Extension - Navigation -

extension WireframeData {

    public func navigation(for name: String) -> Navigation? {
        
        do {
            return try tryNavigation(for: name)
        } catch {
            assertionFailure("The navigation should not throw an error")
            return nil
        }

    }

    func tryNavigation(for name: String) throws -> Navigation {

        if let navigation = navigations?.first(where: { $0.name == name }) {
            return navigation
        }

        if let plugin = plugin(with: name, wireframe: self),
            let navigation = plugin.navigation {
            return navigation
        }

        throw WireframeError.navigationDoesNotExist(name)
    }

}
