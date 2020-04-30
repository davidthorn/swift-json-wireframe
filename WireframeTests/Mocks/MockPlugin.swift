//
//  MockPlugin.swift
//  WireframeTests
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit
import Wireframe

// MARK: - Implementation -

public final class MockPlugin: Plugin {

     // MARK: - Public Properties -

    public var name: String = "profile"
    public var stackedController: UIViewController? {
        viewController
    }

    // MARK: - Private Properties -

    private(set) var viewController: UIViewController?
    private(set) weak var wireframe: WireframeData?

    // MARK: - Constructors -

    /// Default Constructor.
    /// - Parameter wireframe: The wireframe data that this route is a route of.
    required public init(wireframe: WireframeData) {
        self.wireframe = wireframe
    }

}

// MARK: - Extension - ProfilePlugin -

extension MockPlugin {

    // MARK: - Public Properties -

    public func controller(route: Route) -> UIViewController {

        if let stacked = stackedController {
            return stacked
        }

        let view = MockViewCntroller(route: route)
        viewController = view
        view.view.backgroundColor = .white
        view.title = "My custom profile"
        return view
    }

    public var isTransient: Bool { true }

}

class MockViewCntroller: View {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = self.route.name
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Mock"
    }

}
