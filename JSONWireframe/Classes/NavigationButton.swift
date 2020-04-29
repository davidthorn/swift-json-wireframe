//
//  NavigationButton.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

public class NavigationButton: Codable {
    let type: NavigationButtonType
    let name: String
    let target: RouteName
}
