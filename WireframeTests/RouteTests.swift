//
//  RouteTests.swift
//  WireframeTests
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import XCTest
@testable import Wireframe

class RouteTests: XCTestCase {

    func test_navigation() {
        let url = Bundle(for: WireframeTests.self).url(forResource: "navigation-right-buttons", withExtension: "json")!
        let navigationController = UINavigationController()
        let testSubject = Wireframe(navigation: navigationController, resourceUrl: url)
        XCTAssertEqual(testSubject.wireframe.appName, "tester")
        XCTAssertEqual(testSubject.wireframe.root, "home")

        let home = testSubject.wireframe.route(for: "home")
        let account = testSubject.wireframe.route(for: "account")
        XCTAssertEqual(home?.childRoutes.isEmpty, true)
        XCTAssertNotNil(account)
        XCTAssertNotNil(account?.navigation?.buttons)
        XCTAssertEqual(account?.navigation?.buttons?.count, 2)
        XCTAssertEqual(account?.navigationBar.rightBarButtonItems.count, 2)

        let logoutButton = account?.navigation?.button(for: "logout")
        XCTAssertNotNil(logoutButton)
        XCTAssertEqual(logoutButton?.target, home?.name)
        XCTAssertEqual(logoutButton?.icon?.imageName, "profile_icon")

        let notificationsButton = account?.navigation?.button(for: "notifications")
        XCTAssertNotNil(notificationsButton)
        XCTAssertEqual(notificationsButton?.target, "notifications")
        XCTAssertNil(notificationsButton?.icon)

        let dashboard = testSubject.wireframe.route(for: "dashboard")
        XCTAssertNotNil(dashboard)
        XCTAssertNil(dashboard?.navigation?.buttons)
        XCTAssertEqual(dashboard?.navigationBar.rightBarButtonItems.count, 0)
    }

}
