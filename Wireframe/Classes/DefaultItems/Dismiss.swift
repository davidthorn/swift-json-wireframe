//
//  Dismiss.swift
//  Wireframe
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

struct Dismiss: Codable {
    let name: String = "dismiss"
    let title: String = "dismiss"
    let presentationType: PresentationType = .dismiss
}

public struct DismissButton: Codable {
    private let type: NavigationButtonType = .left
    private let name: String = "dismiss"
    private let target: RouteName = "dismiss"

    public static var navigationButton: NavigationButton {
        do {
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()

            let button = DismissButton()
            let encodedValue = try encoder.encode(button)
            let route = try decoder.decode(NavigationButton.self, from: encodedValue)
            return route
        } catch {
            assertionFailure("encoding of the dismiss button did not work")
            fatalError()
        }
    }
}

public struct PopButton: Codable {
    private let type: NavigationButtonType = .right
    private let name: String = "pop"
    private let target: RouteName = "pop"

    public static var navigationButton: NavigationButton {
        do {
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()

            let button = PopButton()
            let encodedValue = try encoder.encode(button)
            let route = try decoder.decode(NavigationButton.self, from: encodedValue)
            return route
        } catch {
            assertionFailure("encoding of the dismiss button did not work")
            fatalError()
        }
    }
}
