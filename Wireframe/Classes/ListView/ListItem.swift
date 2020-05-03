//
//  ListItem.swift
//  Wireframe
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public class ListItem: Codable {

    public let type: String
    private(set) var plugin: ListItemPlugin

    public enum CodingKeys: CodingKey {
        case type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let pluginType = try container.decode(String.self, forKey: .type)
        guard let localPlugin = Wireframe.listItemPlugins.plugin(with: pluginType) else {
            throw WireframeError.unexpectedError
        }
//        guard let localPlugin = Wireframe.listItemPlugins.first(where: { $0.init().name == pluginType })?.init() else {
//            throw WireframeError.unexpectedError
//        }
        try localPlugin.decode(with: decoder)
        type = pluginType
        plugin = localPlugin
    }

    public func getView() throws -> UIView {
        try plugin.getView()
    }

}
