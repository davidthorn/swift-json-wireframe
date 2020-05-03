//
//  ListItemPluginTests.swift
//  ListViewTests
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import XCTest
import Wireframe

public let listPlugins: [ListItemPlugin.Type] = [
    LabelListItemPluginImpl.self
]

class ListItemPluginTests: XCTestCase {

    func test_one() {

        Wireframe.listItemPlugins.append(LabelListItemPluginImpl.self)
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
}

extension ListItemPluginTests {

    func load(_ resource: String) -> Data {
        let url = Bundle(for: ListItemPluginTests.self).url(forResource: resource, withExtension: "json")!
        return try! Data(contentsOf: url)
    }


}
