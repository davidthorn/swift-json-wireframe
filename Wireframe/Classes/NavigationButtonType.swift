//
//  NavigationButtonType.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

// MARK: - Implementation -

/// Enum to indicatet the side of the navigation bar that the button should be inserted,
public enum NavigationButtonType: String, Codable {

    /// The button should be placed in the navigation items leftBarButtons
    case left

    /// The button should be placed in the navigation items rightBarButtons
    case right

}

extension NavigationButtonType: Hashable {

    

}
