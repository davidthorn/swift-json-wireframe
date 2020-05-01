//
//  NavigationPluginDatasource.swift
//  Wireframe
//
//  Created by Thorn, David on 01.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

// MARK: - Protocol -

/// A protocol that can be implemented to receive access to the navigaton plugins.
public protocol NavigationPluginDatasource {

    /// Returns a navigaton plugin if one has been registered.
    /// - Parameters:
    ///   - name: The name of the plugin
    ///   - wireframe: The wireframe used to load the plugin with.
    func plugin(with name: RouteName, wireframe: WireframeData?) -> NavigationPlugin?

}

// MARK: - Implementation -

extension NavigationPluginDatasource {

    /// Returns a navigaton plugin if one has been registered.
    /// - Parameters:
    ///   - name: The name of the plugin
    ///   - wireframe: The wireframe used to load the plugin with.
    public func plugin(
        with name: RouteName,
        wireframe: WireframeData?
    ) -> NavigationPlugin? {

        if let cachedPlugin = PluginManager.navigationPlugins[name] {
            return cachedPlugin
        }

        guard let wireframe = wireframe else {
            assertionFailure("The datasources wireframe is nil, why has that happened?")
            return nil
        }

        let plugin =  Wireframe.navigationPlugins
            .first(where: { $0.init(wireframe: wireframe).name == name })?
            .init(wireframe: wireframe)

        if let plugin = plugin, plugin.isTransient {
            PluginManager.navigationPlugins[name] = plugin
        }

        return plugin
    }


}

// MARK: - Extension - WireframeData -

extension WireframeData: NavigationPluginDatasource { }

// MARK: - Extension - WireframeDatasourceImpl -

extension WireframeDatasourceImpl: NavigationPluginDatasource  { }
