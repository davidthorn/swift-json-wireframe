//
//  ListItemPlugin.swift
//  Wireframe
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Protocol -

/// a plugin that creates a list item that can be displayed within a tableview.
public protocol ListItemPlugin {

    /// The delegate that the list item can use to communicate to its parent.
    var delegate: ListItemPluginDelegate? { get set }

    /// The type list item that this plugin is.
    var type: ListItemType { get }

    /// The name for this plugin.
    var name: String { get }

    /// The method used to decode the views model that will be used to display the plugins view.
    /// - Parameter decoder: The decoder
    func decode(with decoder: Decoder) throws

    /// The view that should be dislplayed if the a cell has not been returned already.
    func getView() throws -> UIView

    /// The cell that should be used instead of the defaul cell.
    /// - Parameters:
    ///   - tableview: The tableview in which the list item plugin is being displayed.
    ///   - indexPath: The index path for this list item plugin.
    func cell(using tableview: UITableView, indexPath: IndexPath) -> UITableViewCell?

    /// Method should register a cell if the plugin requires a cell be used.
    /// - Parameter tableview: The tableview that the cell should be registered too.
    func registerCell(tableview: UITableView)

    /// The default init used to create this plugin.
    init()
}

// MARK: - Extension - ListItemPlugin -

public extension ListItemPlugin {

    /// Returns if this plugin matches that of the name and type provided.
    /// - Parameters:
    ///   - name: The name that should match this plugin
    ///   - type: The type that should match this plugin
    /// - Returns: Returns true of both name and type match, else false.
    func isPlugin(name: String, type: ListItemType) -> Bool {
        self.name == name && self.type == type
    }

}

// MARK: - Extension - Default Implementation -

extension ListItemPlugin {

    /// The cell that should be used instead of the defaul cell.
    /// - Parameters:
    ///   - tableview: The tableview in which the list item plugin is being displayed.
    ///   - indexPath: The index path for this list item plugin.
    public func cell(
        using tableview: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell? { return nil }

    /// Method should register a cell if the plugin requires a cell be used.
    /// - Parameter tableview: The tableview that the cell should be registered too.
    public func registerCell(tableview: UITableView) { }

    /// The view that should be dislplayed if the a cell has not been returned already.
    public func getView() -> UIView {
        UIView()
    }

}

// MARK: - Extension - Array -

extension Array where Element == ListItemPlugin.Type {

    public func plugin(with name: String, type: ListItemType) -> ListItemPlugin? {
        let result = first(where: { $0.init().isPlugin(name: name, type: type) })?.init()
        return result
    }


}
