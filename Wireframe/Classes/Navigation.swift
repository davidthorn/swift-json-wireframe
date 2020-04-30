//
//  Navigation.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

// MARK: - Implementation -

public class Navigation: Codable {

    // MARK: - Private Properties -

    private(set) var buttons: [NavigationButton]?

    // MARK: - Constructors -

    public init() { }

}

// MARK: - Extension - Navigation -

public extension Navigation {

    var barButtonsItems: [NavigationButton] {
        buttons ?? []
    }

    var leftBarButtonItems: [NavigationButton] {
        barButtonsItems.filter { $0.buttonType == .left }
    }

    var rightBarButtonItems: [NavigationButton] {
        barButtonsItems.filter { $0.buttonType == .right }
    }

    func button(for name: String) -> NavigationButton? {
        barButtonsItems.first { $0.name == name }
    }

}

extension Navigation: Hashable {

    public static func == (lhs: Navigation, rhs: Navigation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(buttons)
    }

}

