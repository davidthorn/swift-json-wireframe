//
//  ListView.swift
//  Wireframe
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit
import ListItemPlugin

public final class ListView: UIView, ListItemPluginDelegate {

    public weak var presentor: ListViewPresentor?

    private(set) var tableView = UITableView()
    private(set) var route: Route!
    private(set) var items: [ListItem] = [] {
        didSet {
            debugPrint("The items did set")
        }
    }

    init(route: Route) {
        self.route = route
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func commonInit() {
        addSubview(tableView)
        if let plugin = route.plugin as? ListViewPlugin,
            let listItems = plugin.listItems {
            items = listItems
            items.forEach {
                $0.delegate = self
                $0.registerCell(tableview: tableView)
            }
        }

        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)

        tableView.edgesToSuperview()
        tableView.delegate = self
        tableView.dataSource = self
    }

    public func update(items: [ListItem]) {
        self.items = items
        self.tableView.reloadData()
    }

    public func update(_ plugin: ListItemPlugin) {
        guard let index = items.index(of: plugin) else { return }
        
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    public func throwError(error: ListItemPluginError) {
        presentor?.throwError(error: error)
    }

    public func itemTapped(_ plugin: ListItemPlugin) {
        guard let index = items.index(of: plugin) else { return }

        let item = items[index]
        presentor?.itemTapped(item)
    }

}

extension ListView: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]

        if let cell = item.cell(using: tableView, indexPath: indexPath) {
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ListCell.reuseIdentifier,
            for: indexPath
            ) as? ListCell else {
                fatalError()
        }


        do {
            let view = try item.getView()
            cell.contentView.addSubview(view)
            view.edgesToSuperview()
        } catch {
            fatalError()
        }

        return cell
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
