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

    var testSubject: Wireframe!

    func test_navigation() {
        let url = Bundle(for: WireframeTests.self).url(forResource: "navigation-right-buttons", withExtension: "json")!
        let navigationController = UINavigationController()
        testSubject = Wireframe(navigation: navigationController, resourceUrl: url) {
            WireframeDatasourceImpl(wireframe: $0)
        }
        XCTAssertFalse(testSubject.rootViewController is ErrorViewController)
        XCTAssertEqual(testSubject.wireframe.appName, "tester")
        XCTAssertEqual(testSubject.wireframe.root, "home")

        let home = testSubject.wireframe.route(for: "home")
        let account = testSubject.wireframe.route(for: "account")
        XCTAssertEqual(home?.childRoutes.isEmpty, true)
        XCTAssertNotNil(account)
        XCTAssertNotNil(account?.navigation?.buttons)
        XCTAssertEqual(account?.navigation?.buttons.count, 2)
        XCTAssertEqual(account?.navigation?.buttons.map { $0.type }, [.left, .left])
        XCTAssertEqual(account?.navigation?.leftBarButtonItems.count, 2)

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
        XCTAssertNil(dashboard?.navigation)
        XCTAssertNil(dashboard?.navigation?.buttons)
        XCTAssertEqual(dashboard?.navigation?.rightBarButtonItems.count, nil)
    }

    func test_navigation_fails() {
        let url = Bundle(for: WireframeTests.self).url(forResource: "navigation-button-unknown-target", withExtension: "json")!
        let navigationController = UINavigationController()
        testSubject = Wireframe(navigation: navigationController, resourceUrl: url) {
            WireframeDatasourceImpl(wireframe: $0)
        }
        let controller = testSubject.rootViewController as? ErrorViewController
        XCTAssertNotNil(controller)
        switch controller!.error {
        case .navigationButtonTargetNotExists(let route):
            XCTAssertEqual(route, "notifications")
        default:
            XCTFail()
        }
    }

}
