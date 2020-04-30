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

    var navigationController: UINavigationController!
    var testSubject: Wireframe!

    override func setUpWithError() throws {
        navigationController = UINavigationController()

    }

    override func tearDownWithError() throws {
        testSubject = nil
        navigationController = nil
    }

    func test_root() {
        let url = Bundle(for: WireframeTests.self).url(forResource: "root", withExtension: "json")!
        testSubject = Wireframe(navigation: navigationController, resourceUrl: url)
        XCTAssertEqual(testSubject.wireframe.appName, "tester")
        XCTAssertEqual(testSubject.wireframe.root, "home")
        XCTAssertEqual(testSubject.wireframe.routes.count, 1)
        XCTAssertEqual(testSubject.wireframe.routes.first?.name, "home")
        XCTAssertEqual(testSubject.wireframe.routes.first?.title, "Home")
        XCTAssertNil(testSubject.wireframe.routes.first?.subroutes)
        XCTAssertEqual(testSubject.wireframe.routes.first?.childRoutes.count, 0)

        XCTAssertEqual(testSubject.wireframe.route(for: "home")?.title, "Home")
        XCTAssertEqual(testSubject.wireframe.route(for: "home")?.name, "home")
        XCTAssertEqual(testSubject.wireframe.route(for: "home")?.wireframe, testSubject.wireframe)
    }

    func test_subroutes() {
        let url = Bundle(for: WireframeTests.self).url(forResource: "subroutes", withExtension: "json")!
        testSubject = Wireframe(navigation: navigationController, resourceUrl: url)
        XCTAssertEqual(testSubject.wireframe.appName, "tester")
        XCTAssertEqual(testSubject.wireframe.root, "home")
        XCTAssertEqual(testSubject.wireframe.routes.count, 3)
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
        XCTAssertEqual(subroute?.parent, dashboardRoute)
    }

}
