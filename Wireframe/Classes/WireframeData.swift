//
//  WireframeData.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

// MARK: - Implementation -

public class WireframeData: Codable {
    var isCalled: Bool = false
    public let appName: String
    public var routes: [RouteImpl]
    public let root: RouteName
    public var navigations: [Navigation]?

    public var datasource: WireframeDatasource?

    enum CodingKeys: CodingKey, CaseIterable {
        case appName
        case routes
        case root
        case navigations
    }

    required public init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
        appName = try container.debugDecode(String.self, forKey: .appName, parent: Self.self)
        routes = try container.debugDecode([RouteImpl].self, forKey: .routes, parent: Self.self)
        root = try container.debugDecode(String.self, forKey: .root, parent: Self.self)
        navigations = try container.debugDecodeIfPresent([Navigation].self, forKey: .navigations, parent: Self.self)
    }

}

// MARK: - Extension - KeyedDecodingContainer -

extension KeyedDecodingContainer where K == WireframeData.CodingKeys {

    func debugDecode<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parent: Decodable.Type) throws -> T {
        do {
            return try decode(T.self, forKey: key)
        } catch let error {
            debugPrint("Decoding Error: \(String(describing: parent.self)) \(key.stringValue): could not be decoded")
            debugPrint("File: \(#file) Line: \(#line)")
            debugPrint(K.allCases)
            throw error
        }

    }

    func debugDecodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parent: Decodable.Type) throws -> T? {
           do {
               return try decodeIfPresent(T.self, forKey: key)
           } catch let error {
               debugPrint("Decoding Error: \(String(describing: parent.self)) \(key.stringValue): could not be decoded")
                debugPrint("File: \(#file) Line: \(#line)")
               debugPrint(K.allCases)
               throw error
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

        routes.forEach { route in
            route.datasource = nil
            route.wireframe = nil
            debugPrint(route.name)
        }

        let wireframe = self
        try routes.forEach { route in
            try route.set(wireframeData: wireframe)
            debugPrint("Route name: \(route.name)")
        }

        try routes.forEach { route in
            try route.setNavigation()
            try route.setSubRoutes()
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
