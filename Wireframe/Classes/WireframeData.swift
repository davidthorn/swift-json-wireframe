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
    public let appName: String
    public var routes: [Route]
    public let root: RouteName

    enum CodingKeys: CodingKey, CaseIterable {
        case appName
        case routes
        case root
    }

    required public init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
        appName = try container.debugDecode(String.self, forKey: .appName, parent: Self.self)
        routes = try container.debugDecode([Route].self, forKey: .routes, parent: Self.self)
        root = try container.debugDecode(String.self, forKey: .root, parent: Self.self)
    }

}

// MARK: - Extension - KeyedDecodingContainer -

extension KeyedDecodingContainer where K == WireframeData.CodingKeys {

    func debugDecode<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parent: Decodable.Type) throws -> T {
        do {
            return try decode(T.self, forKey: key)
        } catch let error {
            debugPrint("Decoding Error: \(String(describing: parent.self)) \(key.stringValue): could not be decoded")
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

    /// Sets all routes wireframe property to that of this wireframe data.
    func setRoutes() {

        routes.forEach { route in
            route.wireframe = self
        }

    }

}

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
