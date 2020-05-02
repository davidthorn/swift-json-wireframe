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
public protocol WireframeDatasource: AnyObject {

    var wireframe: WireframeData? { get }

    /// Returns a Plugin that matches this name.
    /// - Parameter name: The name of the plugin.
    func plugin(with name: RouteName) -> Plugin?

    /// Returns a Plugin that matches this name.
    /// - Parameter name: The name of the plugin.
    func plugin(with name: RouteName) -> NavigationPlugin?

    /// Returns the view controller from the plugin that has the matching name.
    /// - Parameter name: The name of the route for which this controller should be loaded.
    func controller(with name: RouteName) -> UIViewController?

    func controller(for route: Route) -> UIViewController

}

// MARK: - Implementation -

public final class WireframeDatasourceImpl {

    public weak var wireframe: WireframeData?

    public init(wireframe: WireframeData) {
        self.wireframe = wireframe
    }

}

// MARK: - Extension - Route -

extension WireframeDatasourceImpl: WireframeDatasource {

    /// This method must return a view and is responsible for checking if a plugin controls this route.
    /// - Parameter route: The route used for the view
    public func controller(for route: Route) -> UIViewController {
        return builder(route: route) { $1 }
    }

    public func plugin(with name: RouteName) -> Plugin? {

        if let cachedPlugin = PluginManager.plugins[name] {
            return cachedPlugin
        }

        guard let wireframe = wireframe else {
            assertionFailure("The datasources wireframe is nil, why has that happened?")
            return nil
        }

        let plugin =  Wireframe.plugins
            .first(where: { $0.init(wireframe: wireframe).name == name })?
            .init(wireframe: wireframe)

        if let plugin = plugin, plugin.isTransient {
            PluginManager.plugins[name] = plugin
        }

        return plugin
    }

    public func plugin(with name: RouteName) -> NavigationPlugin? {
        plugin(with: name, wireframe: wireframe)
    }

    public func controller(with name: RouteName) -> UIViewController? {
        if let route = wireframe?.route(for: name) {
            return controller(for: route)
        }

        assertionFailure("All route names should be programmatically set, this should not happen")

        return nil

    }

    private func builder(route: Route, handler: (Route, UIViewController) -> UIViewController) -> UIViewController {
        if let plugin: Plugin = plugin(with: route.name) {
            let  view = plugin.controller(route: route)
            return handler(route, view)
        } else {
            switch route.type {
            case .navigation:
                let view = View(route: route)
                let nav = navigationController(for: route.navigation, route: route)
                nav.setViewControllers([view], animated: true)
                view.didMove(toParent: nav)
                return nav
            case .tabbar:
                return TabBarView(route: route)
            case .view:
                return View(route: route)
            }
        }
    }

    func navigationController(for navigation: Navigation?, route: Route) -> UINavigationController {
        guard let name = navigation?.name else { return UINavigationController() }

        if let cachedPlugin = PluginManager.navigationPlugins[name] {
            if let customNavigation = cachedPlugin.navigation {
                route.navigation = customNavigation
            }
            return cachedPlugin.navigationController(for: route)
        }

        let navigationPlugin: NavigationPlugin? = plugin(with: name)

        if let customNavigation = navigationPlugin?.navigation {
            route.navigation = customNavigation
        }

        if let plugin = navigationPlugin  {
            return plugin.navigationController(for: route)
        }

        return navigationController(for: nil, route: route)
    }

}


