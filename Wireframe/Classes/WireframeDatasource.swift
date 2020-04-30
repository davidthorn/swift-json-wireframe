//
//  WireframeDatasource.swift
//  JSONWireframe
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Protocol -

/// A datasource that allows routes to communicate directly with the PluginManager.
public protocol WireframeDatasource: AnyObject, Codable {

    /// Returns a Plugin that matches this name.
    /// - Parameter name: The name of the plugin.
    func plugin(with name: RouteName) -> Plugin?

    /// Returns the view controller from the plugin that has the matching name.
    /// - Parameter name: The name of the route for which this controller should be loaded.
    func controller(with name: RouteName) -> UIViewController?
}
