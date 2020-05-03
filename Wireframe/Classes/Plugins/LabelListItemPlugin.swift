//
//  LabelListItemPlugin.swift
//  Wireframe
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Implementation -

public final class LabelListItemPluginImpl: ListItemPlugin {

    private(set) var item: ListItem?

    public var name: String = "label"

    public struct ListItem: Codable {

        public let text: String

        public enum CodingKeys: String, CodingKey, CaseIterable {
            case text
        }
    }

    public func decode(with decoder: Decoder) throws {
        item = try ListItem(from: decoder)
    }

    public func getView() throws -> UIView {
        guard let item = item else {
            throw WireframeError.unexpectedError
        }
        let label = UILabel()
        label.text = item.text
        return label
    }

    public init() { }

}
