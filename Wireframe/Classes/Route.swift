//
//  Route.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

public enum RouteType: String, Codable, Hashable {
    case view
    case tabbar
    case navigation
}

// MARK: - Implementation -

public class Route: Codable {

     // MARK: - Public Properties -
    public var type: RouteType = .view
    public var tabItems: [String]?
    public let name: String
    public let title: String
    public var navigation: Navigation?
    public var navigaionName: String?

    enum CodingKeys: CodingKey, CaseIterable {
        case type
        case tabItems
        case name
        case title
        case navigation
        case subroutes
    }

    // MARK: - Private Properties -

    private(set) var subroutes: [RouteName]?
    private(set) var routes: [Route]?

    // MARK: - Private Resources -

    weak var parent: Route?
    weak var wireframe: WireframeData? {
        didSet {
            setNavigation()
            setSubRoutes()
        }
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.debugDecodeIfPresent(RouteType.self, forKey: .type, parent: Self.self) ?? .view
        tabItems = try container.debugDecodeIfPresent([RouteName].self, forKey: .tabItems, parent: Self.self)
        name = try container.debugDecode(String.self, forKey: .name, parent: Self.self)
        title = try container.debugDecode(String.self, forKey: .title, parent: Self.self)
        subroutes = try container.debugDecodeIfPresent([RouteName].self, forKey: .subroutes, parent: Self.self)
        do {
            navigation = try container.debugDecode(Navigation.self, forKey: .navigation, parent: Self.self)
        } catch {
            navigaionName = try container.debugDecodeIfPresent(String.self, forKey: .navigation, parent: Self.self)
        }


    }

    // MARK: - Deinitialisation -

    deinit {
        debugPrint("\(String(describing: Self.self)) deinit: \(String(describing: wireframe))")
    }
}

// MARK: - Extension - KeyedDecodingContainer -

extension KeyedDecodingContainer where K == Route.CodingKeys {

    func debugDecode<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parent: Decodable.Type) throws -> T {
        do {
            return try decode(T.self, forKey: key)
        } catch let error {
            debugPrint("Decoding Error: \(String(describing: parent.self)) \(key.stringValue): could not be decoded")
            debugPrint(K.allCases)
            throw error
        }

    }

    func debugDecodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parent: Decodable.Type) throws -> T? {
        do {
            return try decodeIfPresent(T.self, forKey: key)
        } catch let error {
            debugPrint("Decoding Error: \(String(describing: parent.self)) \(key.stringValue): could not be decoded")
            debugPrint(K.allCases)
            throw error
        }

    }

}

// MARK: - Extension - Route -

public extension Route {

    var navigationBar: Navigation {
        return navigation ?? Navigation(name: name)
    }

    private func setNavigation() {
        guard navigation.isNil, let navName = navigaionName else { return }

        navigation = wireframe?.navigation(for: navName)
        
    }

    private func setSubRoutes() {
        routes = routes ?? []
        subroutes?.forEach { subrouteName in
            if let subRoute = wireframe?.route(for: subrouteName) {
                subRoute.parent = self
                routes?.append(subRoute)
            }
        }
    }

}

// MARK: - Extension - RouteButtons -

public extension Route {

    var childRoutes: [Route] {
        guard let setRoutes = routes else {
            assertionFailure("Why are the routes not been set to a default value?")
            return []
        }

        return setRoutes
    }

    var buttons: [RouteButton] {
        childRoutes.map { subroute in
            let button = RouteButton()
            button.title = subroute.title
            return button
        }
    }

}

extension Route: Hashable {

    public static func == (lhs: Route, rhs: Route) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(title)
        hasher.combine(navigation)
        hasher.combine(subroutes)
    }



}
