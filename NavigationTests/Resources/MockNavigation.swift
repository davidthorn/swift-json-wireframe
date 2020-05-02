//
//  MockNavigation.swift
//  NavigationTests
//
//  Created by Thorn, David on 02.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation
import Wireframe

public struct MockIcon: Codable {
    let imageName: String
}

public struct MockNavigations: Codable {
    let navigations: [Navigation]
}

public struct MockNavigationButton: Encodable {
    public var type: NavigationButtonType?
    public let name: String
    public let target: RouteName
    public let icon: MockIcon?
    public static var encoded: Data {
        let data = MockNavigationButton(
            type: .left,
            name: "profile",
            target: "profile",
            icon: MockIcon(imageName: "profile_icon")
        )
        let encoder = JSONEncoder()
        return try! encoder.encode(data)
    }
}

public struct MockNavigation: Encodable {
    let name: String
    let buttons: [MockNavigationButton]

    public static var encoded: Data {
        let data = MockNavigation.init(name: "home", buttons: [
            MockNavigationButton(
                type: .left,
                name: "profile",
                target: "profile",
                icon: MockIcon.init(imageName: "profile_icon")
            )
        ])
        let encoder = JSONEncoder()
        return try! encoder.encode(data)
    }
}
