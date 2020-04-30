//
//  ProfilePlugin.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit
import Wireframe

// MARK: - Implementation -

public class ProfilePlugin: Plugin {

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

extension ProfilePlugin {

    // MARK: - Public Properties -

    public func controller(route: Route) -> UIViewController {

        route.type = .navigation
        route.presentationType = .present

        route.navigation = Navigation(name: "profile")
        route.navigation?.add(button: DismissButton.navigationButton)

        if route.name != name {
            assertionFailure("Why is this being called with another route")
        }

        if let stacked = stackedController {
            return stacked
        }

        let view = ProfileViewController(route: route)
        viewController = view
        view.view.backgroundColor = .white
        view.title = "My custom profile"
        return view
    }

    public var isTransient: Bool { true }

}

class ProfileViewController: View {

    var counter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = self.route.name
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        counter += 1
        title = "Profile - \(counter)"
    }

}

//Wireframe.plugins.append(ProfilePlugin.init())
