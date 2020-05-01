//
//  NavigationPluginTests.swift
//  WireframeTests
//
//  Created by Thorn, David on 01.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import XCTest
@testable import Wireframe

class NavigationPluginTests: WireframeTests {

    var testSubject: WireframeData!
    var navigationController: MockNavigation!
    

    override func setUp() {
        navigationController = MockNavigation()
        PluginManager.purge()
    }

    override func tearDown() {
        navigationController = nil
        Wireframe.navigationPlugins.removeAll()
    }

    func test_navigationPlugin() {

        testSubject = resource(name: "navigation-plugin", navigationController: navigationController).wireframe
        XCTAssertEqual(testSubject.routes.count, routeCount(2))
        XCTAssertNotNil(testSubject.navigations)
        XCTAssertEqual(testSubject.navigations?.count, 1)
        let navigation = testSubject.navigation(for: "account")
        XCTAssertNotNil(navigation)
        XCTAssertEqual(navigation?.buttons?.count, 1)
        let logout = navigation?.button(for: "logout")
        XCTAssertNotNil(logout)
        XCTAssertEqual(logout?.name, "logout")
        XCTAssertEqual(logout?.target, "logout")
        XCTAssertEqual(logout?.type, .left)

        XCTAssertEqual(Wireframe.navigationPlugins.count, 0)
        XCTAssertEqual(Wireframe.plugins.count, 0)
        XCTAssertEqual(PluginManager.navigationPlugins.keys.count, 0)
        XCTAssertEqual(PluginManager.plugins.keys.count, 0)

    }

}
