//
//  Plugin.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Protocol -

public protocol Plugin: AnyObject {

    /// If the plugin should be saved within the plugin manager to be used again.
    var isTransient: Bool { get }

    /// The name that should match the route name in which this plugin will take control over.
    var name: String { get }

    /// A strong reference to the controller that has been used already. This can be returned upon the plugin being called again.
    var stackedController: UIViewController? { get }

    /// This method should be called to load the view controller for this route.
    /// - Parameter route: The route that is linked to this plugin, Route and plugins name property match.
    func controller(route: Route) -> UIViewController

    /// Default constructor
    /// - Parameter wireframe: The main wireframe data of the application
    init(wireframe: WireframeData)

}

// MARK: - Extension - Plugin -

public extension Plugin {

    /// All plugins should not be saved as standard.
    var isTransient: Bool { false } 

}
