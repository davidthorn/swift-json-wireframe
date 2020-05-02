//
//  NavigationButton.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit


// MARK: - Implementation -

public class NavigationButton: Codable {

    // MARK: - Private Properties -

    private(set) var type: NavigationButtonType

     // MARK: - Public Properties -

    public let name: String

    public let target: RouteName

    public let icon: Icon?

    public enum CodingKeys: String, CodingKey, CaseIterable {

        // MARK: - Required -
        
        case name
        case target

        // MARK: - Optonal -

        case type
        case icon
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.debugDecode(String.self, forKey: .name, parent: Self.self)
        type = try container.debugDecodeIfPresent(NavigationButtonType.self, forKey: .type, parent: Self.self) ?? .left
        icon = try container.debugDecodeIfPresent(Icon.self, forKey: .icon, parent: Self.self)
        target = try container.debugDecode(RouteName.self, forKey: .target, parent: Self.self)
    }
    
}

// MARK: - Extension - KeyedDecodingContainer -

extension KeyedDecodingContainer where K == NavigationButton.CodingKeys {

    func debugDecode<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parent: Decodable.Type) throws -> T {
        do {
            return try decode(T.self, forKey: key)
        } catch {
            throw WireframeError.navigationButtonDecoding(key)
        }
    }

    func debugDecodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parent: Decodable.Type) throws -> T? {
        do {
            return try decodeIfPresent(T.self, forKey: key)
        } catch {
            throw WireframeError.navigationButtonDecoding(key)
        }
    }

}

// MARK: - Extension - NavigationButton -

public extension NavigationButton {

    var buttonType: NavigationButtonType { type }

}

extension NavigationButton: Hashable {

    public static func == (lhs: NavigationButton, rhs: NavigationButton) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(name)
        hasher.combine(target)
        hasher.combine(icon)
    }

}
