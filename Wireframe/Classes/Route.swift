//
//  Route.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

// MARK: - Implementation -

public class Route: Codable {

     // MARK: - Public Properties -

    public let name: String
    public let title: String
    public let navigation: Navigation?

    enum CodingKeys: CodingKey, CaseIterable {
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
            setSubRoutes()
        }
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.debugDecode(String.self, forKey: .name, parent: Self.self)
        title = try container.debugDecode(String.self, forKey: .title, parent: Self.self)
        navigation = try container.debugDecodeIfPresent(Navigation.self, forKey: .navigation, parent: Self.self)
        subroutes = try container.debugDecodeIfPresent([RouteName].self, forKey: .subroutes, parent: Self.self)
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
        return navigation ?? Navigation()
    }

    private func setSubRoutes() {
        routes = routes ?? []
        subroutes?.forEach { subrouteName in
            if let subRoute = wireframe?.route(for: subrouteName) {
                subRoute.parent = self
                routes?.append(subRoute)
            }
        }
        let mmm = true
    }

}

// MARK: - Extension - RouteButtons -

public extension Route {

    var childRoutes: [Route] {
        routes ?? []
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
