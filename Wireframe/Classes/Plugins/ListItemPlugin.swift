//
//  ListItemPlugin.swift
//  Wireframe
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Protocol -

public protocol ListItemPlugin {

    var name: String { get }

    func decode(with decoder: Decoder) throws

    func getView() throws -> UIView

    init()
}

// MARK: - Extension - Array -

extension Array where Element == ListItemPlugin.Type {

    public func plugin(with name: String) -> ListItemPlugin? {

        if let cachedPlugin = PluginManager.listItemPlugins[name] {
            return cachedPlugin
        }

        guard let loadedPlugin = first(where: { $0.init().name == name })?.init() else {
            return nil
        }

        PluginManager.listItemPlugins[name] = loadedPlugin

        return loadedPlugin

    }

}
