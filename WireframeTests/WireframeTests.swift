//
//  WireframeTests.swift
//  WireframeTests
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import XCTest
@testable import Wireframe

class WireframeTests: XCTestCase {

    let defaultRoutesCount = RouteImpl.defaultRoutes.count
    private var testSubject: Wireframe!

    func routeCount(_ count: Int) -> Int {
        count + defaultRoutesCount
    }

    static func resource(name: String, navigationController: MockNavigation = MockNavigation()) -> Wireframe {
        let url = Bundle(for: WireframeTests.self).url(forResource: name, withExtension: "json")!
        return Wireframe(navigation: navigationController, resourceUrl: url)
    }

    func resource(name: String, navigationController: MockNavigation = MockNavigation()) -> Wireframe {
        WireframeTests.resource(name: name, navigationController: navigationController)
    }

    override func setUp() {
    }

    override func tearDown() {
        testSubject = nil
    }

    func test_root() {
        testSubject = resource(name: "root")
        XCTAssertEqual(testSubject.wireframe.appName, "tester")
        XCTAssertEqual(testSubject.wireframe.root, "home")


        XCTAssertEqual(testSubject.wireframe.routes.count, 1 + defaultRoutesCount)
        XCTAssertEqual(testSubject.wireframe.routes.first?.name, "home")
        XCTAssertEqual(testSubject.wireframe.routes.first?.title, "Home")
        XCTAssertNil(testSubject.wireframe.routes.first?.subroutes)
        XCTAssertEqual(testSubject.wireframe.routes.first?.childRoutes.count, 0)

        XCTAssertEqual(testSubject.wireframe.route(for: "home")?.title, "Home")
        XCTAssertEqual(testSubject.wireframe.route(for: "home")?.name, "home")
        XCTAssertEqual(testSubject.wireframe.route(for: "home")?.wireframe, testSubject.wireframe)
    }

    func test_subroutes() {
        testSubject = resource(name: "subroutes")
        XCTAssertEqual(testSubject.wireframe.appName, "tester")
        XCTAssertEqual(testSubject.wireframe.root, "home")
        XCTAssertEqual(testSubject.wireframe.routes.count, 3 + defaultRoutesCount)
        XCTAssertEqual(testSubject.wireframe.routes.first?.name, "home")
        XCTAssertEqual(testSubject.wireframe.routes.first?.title, "Home")
        XCTAssertNil(testSubject.wireframe.routes.first?.subroutes)
        XCTAssertEqual(testSubject.wireframe.routes.first?.childRoutes.count, 0)

        XCTAssertEqual(testSubject.wireframe.route(for: "dashboard")?.title, "Dashboard")
        XCTAssertEqual(testSubject.wireframe.route(for: "dashboard")?.name, "dashboard")
        XCTAssertEqual(testSubject.wireframe.route(for: "dashboard")?.wireframe, testSubject.wireframe)
        let dashboardRoute = testSubject.wireframe.route(for: "dashboard")
        let subroute = testSubject.wireframe.route(for: "dashboard")?.routes?.first
        XCTAssertEqual(subroute?.title, "Account")
        XCTAssertEqual(subroute?.name, "account")
        XCTAssertEqual(subroute?.wireframe, testSubject.wireframe)
        XCTAssertEqual(subroute?.parent as? RouteImpl, dashboardRoute as? RouteImpl)
    }

}
