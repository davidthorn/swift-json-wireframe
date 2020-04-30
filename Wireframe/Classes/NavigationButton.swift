//
//  NavigationButton.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

// MARK: - Implementation -

public class NavigationButton: Codable {

    // MARK: - Private Properties -

    private(set) var type: NavigationButtonType?

     // MARK: - Public Properties -

    public let name: String

    public let target: RouteName

}

// MARK: - Extension - NavigationButton -

public extension NavigationButton {

    var buttonType: NavigationButtonType {
        type ?? .right
    }

}

extension NavigationButton: Hashable {

    public static func == (lhs: NavigationButton, rhs: NavigationButton) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(name)
        hasher.combine(target)
    }

}
