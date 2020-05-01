//
//  MockNavigationPlugin.swift
//  WireframeTests
//
//  Created by Thorn, David on 01.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit
import Wireframe

public class MockBaseNavigation: UINavigationController { }
public final class MockNavigation: UINavigationController { }
public final class MockNavigationIntransient: MockBaseNavigation { }

public final class MockNavigationPlugin: NavigationPlugin {

    public var navigation: Navigation?

    public var isTransient: Bool = true

    public var name: String = "account"

    private(set) var wireframe: WireframeData

    public func navigationController(for route: Route) -> UINavigationController {
        MockNavigation()
    }

    public init(wireframe: WireframeData) {
        self.wireframe = wireframe
    }

}


public final class MockNavigationIntransientPlugin: NavigationPlugin {

    public var navigation: Navigation?

    public var isTransient: Bool = false

    public var name: String = "account"

    private(set) var wireframe: WireframeData

    public func navigationController(for route: Route) -> UINavigationController {
        MockNavigationIntransient()
    }

    public init(wireframe: WireframeData) {
        self.wireframe = wireframe
    }

}
