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

    /// Returns the view controller from the plugin that has the matching name.
    /// - Parameter name: The name of the route for which this controller should be loaded.
    func controller(with name: RouteName) -> UIViewController?

    func controller(for route: Route) -> UIViewController?

    var navigationController: UINavigationController? { get }
}

// MARK: - Implementation -

public final class WireframeDatasourceImpl {

    public weak var wireframe: WireframeData?
    public var navigationController: UINavigationController?

    public init(wireframe: WireframeData) {
        self.wireframe = wireframe
    }

}


// MARK: - Extension - Route -

extension WireframeDatasourceImpl: WireframeDatasource {

    public func controller(for route: Route) -> UIViewController? {
        if route.presentationType == .push, navigationController.isNil {
            route.presentationType = .present
            route.type = .navigation
            assert(route.presentationType == .present)
        }

        let commonView: UIViewController
        switch route.type {
        case .view:
            commonView = controller(with: route.name) ?? View(route: route)
        case .tabbar:
            commonView = TabBarView(route: route)
        case .navigation:
            let navigation = UINavigationController()
            let view = controller(with: route.name) ??  View(route: route)
            navigation.setViewControllers([view], animated: true)
            view.didMove(toParent: navigation)
            commonView = navigation
        }

        return commonView
    }

    public func plugin(with name: RouteName) -> Plugin? {

        if let cachedPlugin = PluginManager.plugins[name] {
            return cachedPlugin
        }

        guard let wireframe = wireframe else { return nil }
        let plugin =  Wireframe.plugins
            .first(where: { $0.init(wireframe: wireframe).name == name })?
            .init(wireframe: wireframe)

        if let plugin = plugin, plugin.isTransient {
            PluginManager.plugins[name] = plugin
        }

        return plugin
    }


    public func controller(with name: RouteName) -> UIViewController? {

        guard let route = wireframe?.route(for: name) else {
            assertionFailure("Why is a route name being used here that does not exist?")
            return nil
        }

        if let plugin = plugin(with: name){
            return plugin.controller(route: route)
        }

        switch route.type {
        case .navigation:
            let nav = UINavigationController()
            let view = View(route: route)
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


