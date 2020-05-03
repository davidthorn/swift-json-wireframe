//
//  ListItemPluginTests.swift
//  ListViewTests
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import XCTest
import Wireframe
import ListItemPlugin

public let listPlugins: [ListItemPlugin.Type] = [
    LabelListItemPluginImpl.self
]

class ListItemPluginTests: XCTestCase {

    var wireframe: Wireframe!
    var wireframeData: WireframeData!

    func test_one() {
        ListItemPluginsManager.plugins.append(LabelListItemPluginImpl.self)
        let data = load("label-list-item-plugin")
        let item = try! JSONDecoder().decode(ListItem.self, from: data)
        var label: UILabel?
        let view: () throws -> Void = {
            label = try item.getView() as? UILabel
        }
        XCTAssertNoThrow(try view())
        XCTAssertNotNil(label)
        XCTAssertEqual(label?.text, "Hello")
        PluginManager.purge()
    }

    func test_two() {

        ListItemPluginsManager.plugins.append(LabelListItemPluginImpl.self)
        let data = load("label-list-items-plugin")
        let items = try! JSONDecoder().decode([ListItem].self, from: data)
        var firstLabel: UILabel?
        var secondLabel: UILabel?
        let view: () throws -> Void = {
            firstLabel = try items.first?.getView() as? UILabel
            secondLabel = try items.last?.getView() as? UILabel
        }
        XCTAssertNoThrow(try view())
        XCTAssertNotNil(firstLabel)
        XCTAssertNotNil(secondLabel)
        XCTAssertEqual(firstLabel?.text, "Hello")
        XCTAssertEqual(secondLabel?.text, "Hello There")
        PluginManager.purge()
    }

    func test_wireframe() {
        let nav = UINavigationController()
        ListItemPluginsManager.plugins.append(LabelListItemPluginImpl.self)
        ListItemPluginsManager.plugins.append(DetailedLabelListItemPluginImpl.self)
        ListItemPluginsManager.plugins.append(CustomListItemPluginImpl.self)
        let url = Bundle(for: ListItemPluginTests.self).url(forResource: "list-view", withExtension: "json")!
        wireframe = Wireframe(
            navigation: nav,
            resourceUrl: url,
            datasourceHandler: { WireframeDatasourceImpl(wireframe: $0) }
        )

        do {
            wireframeData = try wireframe.getWireframe()
            let list = wireframeData.route(for: "list")
            XCTAssertNotNil(list)
            XCTAssertNotNil(list?.listItems)
            let listItem = try list?.listItems?.first?.getView() as? UILabel
            let detailtedItem = try list?.listItems?.last?.getView() as? UITableViewCell
            XCTAssertNotNil(listItem)
            XCTAssertNotNil(detailtedItem)
            XCTAssertEqual(listItem?.text, "Hello")
            XCTAssertEqual(detailtedItem?.detailTextLabel?.text, "An important subtitle")
            XCTAssertEqual(detailtedItem?.textLabel?.text, "My Title")
        } catch {
            XCTFail()
        }


    }
}

extension ListItemPluginTests {

    func load(_ resource: String) -> Data {
        let url = Bundle(for: ListItemPluginTests.self).url(forResource: resource, withExtension: "json")!
        return try! Data(contentsOf: url)
    }


}
