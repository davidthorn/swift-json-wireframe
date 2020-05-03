//
//  ListItemPluginDelegate.swift
//  ListItemPlugin
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

/// A delegate that provides the list item functionality to talk to its parents.
public protocol ListItemPluginDelegate: AnyObject {

    /// The list item cell has been tapped
    /// - Parameter plugin: The plugin that has loaded this list item.
    func itemTapped(_ plugin: ListItemPlugin)


    /// The list item cell has called for this cell to be updated
    /// - Parameter plugin: The plugin that has load this list item.
    func update(_ plugin: ListItemPlugin)

    /// The plugin has requested that an error be shown to the user.
    /// - Parameter error: The error that will be displayed.
    func throwError(error: ListItemPluginError)

}
