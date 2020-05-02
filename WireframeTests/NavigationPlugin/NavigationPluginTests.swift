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
        wireframe = resource(name: "navigation-plugin",
                             navigationController: navigationController,
                             datasourceHandler: { WireframeDatasourceImpl(wireframe: $0) })
        XCTAssertFalse(wireframe.rootViewController is ErrorViewController)
        testSubject = wireframe.wireframe
        XCTAssertEqual(testSubject.routes.count, routeCount(3))
        XCTAssertNotNil(testSubject.navigations)
        XCTAssertEqual(testSubject.navigations?.count, 1)
        let navigation = testSubject.navigation(for: "account")
        XCTAssertNotNil(navigation)
        XCTAssertEqual(navigation?.buttons.count, 1)
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
        wireframe = resource("navigation-plugin", datasourceHandler: { WireframeDatasourceImpl(wireframe: $0) })
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
        wireframe = resource(name: "navigation-plugin",
                             navigationController: nav,
                             datasourceHandler: { WireframeDatasourceImpl(wireframe: $0) })
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
            datasourceHandler: { WireframeDatasourceImpl(wireframe: $0) },
            autoload: false
        )

        let loadWireframe: () throws -> Void = {
            do {
                self.wireframe.set(wireframe: try self.wireframe.load())
            } catch {
                throw error
            }
        }

        XCTAssertNoThrow(try loadWireframe())
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

    func test_transient_navigationcontroller() {
        Wireframe.navigationPlugins.append(MockNavigationPlugin.self)
        wireframe = resource("navigation-plugin", datasourceHandler: { WireframeDatasourceImpl(wireframe: $0) })
        testSubject = wireframe.wireframe
        let route = testSubject.route(for: "home")
        XCTAssertNotNil(route)
        XCTAssertEqual(route?.type, .navigation)
        let datasource = testSubject.route(for: "home")?.datasource as? WireframeDatasourceImpl
        let controller = datasource?.controller(with: "home")
        let controller1 = datasource?.controller(with: "home")
        XCTAssertEqual(controller1, controller)
    }

    func test_intransient_navigationcontroller() {
        Wireframe.navigationPlugins.append(MockNavigationIntransientPlugin.self)
        wireframe = resource("navigation-plugin", datasourceHandler: { WireframeDatasourceImpl(wireframe: $0) })
        testSubject = wireframe.wireframe
        let route = testSubject.route(for: "home")
        
        XCTAssertNotNil(route)
        XCTAssertEqual(route?.type, .navigation)
        let datasource = testSubject.route(for: "home")?.datasource as? WireframeDatasourceImpl
        let controller = datasource?.controller(with: "home")
        let controller1 = datasource?.controller(with: "home")
        let ts = controller1 as? MockNavigationIntransient
        _ = ts?.topViewController?.view
        XCTAssertEqual(ts?.topViewController?.navigationItem.leftBarButtonItems?.count, 1)
        XCTAssertNotEqual(controller1, controller)
    }

}
