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

    var wireframe: Wireframe!
    var testSubject: WireframeData!
    var navigationController: MockNavigation!

    override func setUp() {

        navigationController = MockNavigation()
        PluginManager.purge()
    }

    override func tearDown() {
        wireframe = nil
        testSubject = nil
        navigationController = nil
    }

    func test__control_navigationPlugin() {
        wireframe = resource(name: "navigation-plugin", navigationController: navigationController)
        testSubject = wireframe.wireframe
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

    func test_transient_navigation_plugin() {
        Wireframe.navigationPlugins.append(MockNavigationPlugin.self)
        wireframe = resource("navigation-plugin")
        testSubject = wireframe.wireframe
        let route = testSubject.route(for: "home")
        XCTAssertNotNil(route)
        XCTAssertEqual(route?.type, .navigation)
        let datasource = testSubject.route(for: "home")?.datasource
        let controller = datasource?.controller(with: "home")
        XCTAssertTrue(controller is MockNavigation)
        XCTAssertNotNil(controller)

        let plugin = PluginManager.navigationPlugins["account"]
        XCTAssertNotNil(plugin)
        XCTAssertTrue(plugin!.isTransient)

        XCTAssertEqual(PluginManager.navigationPlugins.keys.count, 1)
    }

    func test_intransient_navigation_plugin() {
        let nav = MockNavigationIntransient()
        Wireframe.navigationPlugins.append(MockNavigationIntransientPlugin.self)
        wireframe = resource(name: "navigation-plugin", navigationController: nav)
        testSubject = wireframe.wireframe
        let route = testSubject.route(for: "home")
        XCTAssertNotNil(route)
        XCTAssertEqual(route?.type, .navigation)
        let datasource = testSubject.route(for: "home")?.datasource
        let controller = datasource?.controller(with: "home")
        XCTAssertTrue(controller is MockNavigationIntransient)
        XCTAssertNotNil(controller)

        let plugin = PluginManager.navigationPlugins["account"]
        XCTAssertNil(plugin)
        XCTAssertEqual(PluginManager.navigationPlugins.keys.count, 0)
    }

    func test_intransient_navigation_plugin_invalid() {
        let nav = MockNavigationIntransient()
        Wireframe.navigationPlugins.append(MockNavigationIntransientPlugin.self)
        wireframe = resource(
            name: "navigation-plugin-invalid",
            navigationController: nav,
            autoload: false
        )

        XCTAssertNoThrow(try wireframe.load())
        testSubject = wireframe.wireframe
        testSubject.setDefaultRoutes()
        XCTAssertThrowsError(try wireframe.setup())

        let route = testSubject.route(for: "home")
        XCTAssertNotNil(route)
        XCTAssertEqual(route?.type, .navigation)
        let datasource = testSubject.route(for: "home")?.datasource
        let controller = datasource?.controller(with: "home")
        let datasourceImpl = datasource as? WireframeDatasourceImpl
        let navigation = route?.navigation
        let navcontroller = datasourceImpl?.navigationController(for: navigation, route: route!)
        XCTAssertFalse(navcontroller is MockNavigationIntransient)
        XCTAssertNil(navigation)
        XCTAssertNotNil(controller)
        let plugin = PluginManager.navigationPlugins["account"]
        XCTAssertNil(plugin)
        XCTAssertEqual(PluginManager.navigationPlugins.keys.count, 0)
    }


}
