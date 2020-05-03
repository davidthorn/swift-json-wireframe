//
//  ListItem.swift
//  Wireframe
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Implementation -

public class ListItem: Codable {

     // MARK: - Public Properties -

    public weak var delegate: ListItemPluginDelegate? {
        didSet {
            plugin.delegate = delegate
        }
    }

    public let id: String
    public let type: ListItemType
    public let name: String
    public let target: String?

    // MARK: - Private Properties -

    private(set) var plugin: ListItemPlugin

    // MARK: - Decoding List Item -

    public enum CodingKeys: CodingKey {
        case id
        case type
        case name
        case target
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let itemId = try container.decode(String.self, forKey: .id)
        let pluginName = try container.decode(String.self, forKey: .name)
        let pluginType = try container.decode(ListItemType.self, forKey: .type)
        let pluginTarget = try container.decodeIfPresent(String.self, forKey: .target)

        guard let localPlugin = ListItemPluginsManager.plugins.plugin(with: pluginName, type: pluginType) else {
            throw ListItemPluginError.unexpectedError
        }

        try localPlugin.decode(with: decoder)

        type = pluginType
        name = pluginName
        plugin = localPlugin
        target = pluginTarget
        id = itemId
        plugin.delegate = delegate
    }

}

// MARK: - Extension - Array -

extension Array where Element == ListItem {

    public func plugin(matches plugin: ListItemPlugin) -> ListItem? {
        first(where: { $0.plugin.isPlugin(name: plugin.name, type: plugin.type) })
    }

    public func index(of plugin: ListItemPlugin) -> Int? {
        firstIndex(where: { $0.name == plugin.name && plugin.type == $0.type && plugin.id == $0.id })
    }

}

// MARK: - Extension - List Item Plugin TableView Cell Methods -

extension ListItem {

    public func getView() throws -> UIView {
        try plugin.getView()
    }

    public func cell(using tableview: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        plugin.cell(using: tableview, indexPath: indexPath)
    }

    public func registerCell(tableview: UITableView) {
        plugin.registerCell(tableview: tableview)
    }

}
