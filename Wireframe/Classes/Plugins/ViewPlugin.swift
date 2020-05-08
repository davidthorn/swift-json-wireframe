//
//  ViewPlugin.swift
//  Wireframe
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit
import ListItemPlugin

public protocol ViewPlugin: AnyObject {

    var id: String { get }

    var name: String { get }

    var type: RouteType { get }

    func decode(with decoder: Decoder) throws

    func getController(route: Route) throws -> UIViewController

}

public final class ListViewPlugin: ViewPlugin {

    public var id: String = UUID().uuidString

    public var name: String = "list"

    public var type: RouteType = .custom

    private(set) var resourceURL: URL?
    private(set) var resourceItem: ListItem?
    private(set) var listItems: [ListItem]?

    public func getController(route: Route) throws -> UIViewController {
        guard route.plugin is ListViewPlugin else {
            throw ListItemPluginError.unexpectedError
        }
        let navigation = UINavigationController()
        let view = ListViewController(route: route)
        navigation.setViewControllers([view], animated: true)
        view.didMove(toParent: navigation)

        guard resourceURL.isNotNil else {
            return navigation
        }

        return navigation
    }
}

// MARK: - Extension - Model -

extension ListViewPlugin {

    struct ListView: Codable {
        let resource: URL?
        let listItems: [ListItem]?
        let resourceItem: ListItem
    }

    enum CodingKeys: CodingKey {
        case resourceURL
        case resourceItem
        case listItems
    }

    public func decode(with decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        resourceItem = try container.decodeIfPresent(ListItem.self, forKey: .resourceItem)
        resourceURL = try container.decodeIfPresent(URL.self, forKey: .resourceURL)
        listItems = try container.decodeIfPresent([ListItem].self, forKey: .listItems)
    }

}
