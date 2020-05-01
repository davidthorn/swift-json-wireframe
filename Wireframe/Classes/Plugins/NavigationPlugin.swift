//
//  NavigationPlugin.swift
//  Wireframe
//
//  Created by Thorn, David on 01.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public protocol NavigationPlugin: AnyObject {

    var navigation: Navigation? { get }

    /// If the plugin should be saved within the plugin manager to be used again.
    var isTransient: Bool { get }

    var name: String { get }

    func navigationController(for route: Route) -> UINavigationController

        /// Default constructor
    /// - Parameter wireframe: The main wireframe data of the application
    init(wireframe: WireframeData)

}
