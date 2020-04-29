//
//  ProfilePlugin.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public class ProfilePlugin: Plugin {

    private(set) var viewController: UIViewController?
    public var name: String = "profile"

    public func controller(route: Route) -> UIViewController {
        let view = ProfileViewController(route: route)
        view.view.backgroundColor = .white
        view.title = "My custom profile"
        return view
    }

    required public init() {}

}

class ProfileViewController: View {

    override func viewDidLoad() {

        title = self.route.name
        setRightBarButtons()
    }

}

//Wireframe.plugins.append(ProfilePlugin.init())
