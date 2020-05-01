//
//  Wireframe.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public typealias RouteName = String

// MARK: - Implementation -

public final class Wireframe {

     // MARK: - Public Properties -

    public static var plugins = [Plugin.Type]()
    public var rootViewController: UIViewController?

    // MARK: - Private Properties -

    private(set) var wireframe: WireframeData!
    private(set) var navigation: UINavigationController
    private(set) var resourceUrl: URL

    // MARK: - Constructors -

    public init(navigation: UINavigationController, resourceUrl: URL) {
        self.navigation = navigation
        self.resourceUrl = resourceUrl
        load()
    }

     // MARK: - Public Methods -

    private func load() {

        do {
            let data = try Data.init(contentsOf: resourceUrl)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            wireframe = try decoder.decode(WireframeData.self, from: data)
            wireframe.setRoutes()
            if let root = wireframe.route(for: wireframe.root) {
                switch root.type {
                case .tabbar:
                    rootViewController = TabBarView(route: root)
                case .view:
                    rootViewController =  View(route: root)
                case .navigation:
                    let view =  View(route: root)
                    navigation.setViewControllers([view], animated: true)
                    view.didMove(toParent: navigation)
                    rootViewController = navigation
                }

            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }

}

// MARK: - Extension - Route -

extension Route {

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
