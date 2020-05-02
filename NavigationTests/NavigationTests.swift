//
//  NavigationTests.swift
//  NavigationTests
//
//  Created by Thorn, David on 02.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import XCTest
@testable import Wireframe

class NavigationTests: XCTestCase {

    var wireframe: Wireframe!
    var testSubject: WireframeData!

    override func tearDown() {
        testSubject = nil
        wireframe = nil
    }

    func test_home() {
        wireframe = resource(name: "home", datasourceHandler: {  WireframeDatasourceImpl(wireframe: $0) })
        let controller = wireframe.rootViewController as? ErrorViewController
        XCTAssertNil(controller)

        XCTAssertNoThrow(try {
            self.testSubject = try self.wireframe.getWireframe()
        }())

        XCTAssertNotNil(testSubject)
        let numberOfRoutes = testSubject.routes.count
        XCTAssertEqual(numberOfRoutes, RouteImpl.defaultRoutes.count + 2)

        let homeRoute = testSubject.route(for: "home")
        let infoRoute = testSubject.route(for: "info")

        XCTAssertEqual(homeRoute?.type, .navigation)
        XCTAssertEqual(homeRoute?.presentationType, .present)

        XCTAssertNotNil(homeRoute)
        XCTAssertNotNil(infoRoute)
        let homeNavigation = homeRoute?.navigation
        XCTAssertNotNil(homeNavigation)

        let buttons = homeNavigation?.buttons
        XCTAssertEqual(buttons?.count, 1)
        let infoButton = buttons?.first(where: { $0.name == "info" })
        XCTAssertNotNil(infoButton)
        XCTAssertEqual(infoButton?.target, "info")
    }

    func test_home_unknown_target() {
        wireframe = resource(name: "home-unknown-target", datasourceHandler: {  WireframeDatasourceImpl(wireframe: $0) })
        let controller = wireframe.rootViewController as? ErrorViewController
        XCTAssertNotNil(controller)

        let error = controller!.error

        switch error {
        case .navigationButtonTargetNotExists(let target):
            XCTAssertEqual(target, "info")
        default:
            XCTFail()
        }

    }

    func test_home_navigation() {
        let navigationData = MockNavigation.encoded
        do {
            let navigation = try JSONDecoder().decode(Navigation.self, from: navigationData)
            XCTAssertEqual(navigation.buttons.count, 1)
            XCTAssertEqual(navigation.buttons.first?.target, "profile")
            XCTAssertEqual(navigation.buttons.first?.name, "profile")
            XCTAssertEqual(navigation.buttons.first?.type, .left)
            XCTAssertEqual(navigation.buttons.first?.icon?.imageName, "profile_icon")
        } catch {
            XCTFail()
        }
    }

    func test_home_navigation_load() {

        do {
            let data = load("navigation-home")
            let navigation = try JSONDecoder().decode(Navigation.self, from: data)
            XCTAssertEqual(navigation.buttons.count, 1)
            XCTAssertEqual(navigation.buttons.first?.target, "home")
            XCTAssertEqual(navigation.buttons.first?.name, "home")
            XCTAssertEqual(navigation.buttons.first?.type, .left)
            XCTAssertEqual(navigation.buttons.first?.icon?.imageName, "profile_icon")
        } catch {
            XCTFail()
        }
    }

    func test_home_navigations() {

        do {
            let data = load("navigations")
            let navigation = try JSONDecoder().decode(MockNavigations.self, from: data)
            XCTAssertEqual(navigation.navigations.count, 2)

            let first = navigation.navigations.first?.buttons.first
            let second = navigation.navigations.last?.buttons.first

            XCTAssertEqual(navigation.navigations.first?.name, "home")
            XCTAssertEqual(navigation.navigations.last?.name, "info")
            XCTAssertEqual(first?.target, "home")
            XCTAssertEqual(first?.name, "home")
            XCTAssertEqual(first?.type, .left)

            XCTAssertEqual(second?.target, "info")
            XCTAssertEqual(second?.name, "info")
            XCTAssertEqual(second?.icon?.imageName, "icon_image")
            XCTAssertEqual(second?.type, .right)

            XCTAssertEqual(navigation.navigations.last?.rightBarButtonItems.count, 1)
            XCTAssertEqual(navigation.navigations.last?.leftBarButtonItems.count, 0)
            XCTAssertEqual(navigation.navigations.first?.leftBarButtonItems.count, 1)
            XCTAssertEqual(navigation.navigations.first?.rightBarButtonItems.count, 0)

            XCTAssertNotEqual(navigation.navigations.last, navigation.navigations.first)
        } catch {
            XCTFail()
        }
    }

    func test_home_navigations_invalid() {

        do {
            let data = load("navigations-invalid")
            _ = try JSONDecoder().decode(MockNavigations.self, from: data)
        } catch let error {

            if let debugError = error as? WireframeError {
                switch debugError {
                case .navigationDecoding(let key):
                    XCTAssertEqual(key, .buttons)
                default:
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        }
    }

    func test_navigation_button_basic() {
        do {
            let dataNormal = load("navigation-button")
            let buttonNormal = try JSONDecoder().decode(NavigationButton.self, from: dataNormal)
            let data = load("navigation-button-basic")
            let button = try JSONDecoder().decode(NavigationButton.self, from: data)
            let button1 = try JSONDecoder().decode(NavigationButton.self, from: data)
            XCTAssertEqual(button.type, .left)
            XCTAssertEqual(button.name, "home")
            XCTAssertEqual(button.target, "home")
            XCTAssertNil(button.icon)
            XCTAssertEqual(button.buttonType, .left)
            XCTAssertEqual(button, button1)
            XCTAssertNotEqual(buttonNormal, button)

        } catch {
            XCTFail()
        }
    }

    func test_navigation_button() {
        do {
            let data = load("navigation-button")
            let button = try JSONDecoder().decode(NavigationButton.self, from: data)
            XCTAssertEqual(button.type, .left)
            XCTAssertEqual(button.name, "home")
            XCTAssertEqual(button.target, "home")
            XCTAssertEqual(button.icon?.imageName, "home_icon")
            
        } catch {
            XCTFail()
        }
    }

    func test_navigation_button_fail() {
        do {
            let data = load("navigation-button-invalid")
            _ = try JSONDecoder().decode(NavigationButton.self, from: data)
        } catch let error {

            if let debugError = error as? WireframeError {
                switch debugError {
                case .navigationButtonDecoding(let key):
                    XCTAssertEqual(key, .name)
                default:
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        }
    }

    func test_navigation_button_fail_target() {
        do {
            let data = load("navigation-button-invalid-target")
            _ = try JSONDecoder().decode(NavigationButton.self, from: data)
        } catch let error {

            if let debugError = error as? WireframeError {
                switch debugError {
                case .navigationButtonDecoding(let key):
                    XCTAssertEqual(key, .target)
                default:
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        }
    }

    func test_navigation_button_fail_type() {
        do {
            let data = load("navigation-button-invalid-type")
            _ = try JSONDecoder().decode(NavigationButton.self, from: data)
        } catch let error {

            if let debugError = error as? WireframeError {
                switch debugError {
                case .navigationButtonDecoding(let key):
                    XCTAssertEqual(key, .type)
                default:
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        }
    }


    func test_navigation_button_fail_icon() {
        do {
            let data = load("navigation-button-icon-invalid")
            _ = try JSONDecoder().decode(NavigationButton.self, from: data)
        } catch let error {

            if let debugError = error as? WireframeError {
                switch debugError {
                case .navigationButtonDecoding(let key):
                    XCTAssertEqual(key, .icon)
                default:
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        }
    }


}

// MARK: - Extension - NavigationTests -

extension NavigationTests {

    func resource(
        name: String,
        navigationController: UINavigationController = UINavigationController(),
        datasourceHandler: @escaping (WireframeData) -> WireframeDatasourceImpl,
        autoload: Bool = true
    ) -> Wireframe {
        let url = Bundle(for: NavigationTestsBundle.self).url(forResource: name, withExtension: "json")!
        return Wireframe(
            navigation: navigationController,
            resourceUrl: url,
            datasourceHandler: datasourceHandler,
            autoload: autoload
        )
    }

    func load(_ resource: String) -> Data {
        let url = Bundle(for: NavigationTestsBundle.self).url(forResource: resource, withExtension: "json")!
        return try! Data(contentsOf: url)
    }


}
