//
//  ListViewController.swift
//  Wireframe
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit
import ListItemPlugin

// MARK: - Implementation -

public final class ListViewController: UIViewController {

    // MARK: - Private Properties -

    private(set) weak var route: Route!

    // MARK: - Constructors -

    public init(route: Route) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController Lifecycle -

    public override func loadView() {
        let listView = ListView(route: route)
        listView.presentor = self
        view = listView
        title = route.title
    }

}

// MARK: - Extension - ListViewPresentor -

extension ListViewController: ListViewPresentor {

    public func throwError(error: ListItemPluginError) {
        DispatchQueue.main.async {
            ErrorView.listPluginMessage(controller: self, error: error).show()
        }
    }

    public func itemTapped(_ item: ListItem) {
        guard let target = item.target,
            let targetRoute = route.wireframe?.route(for: target) else { return }

        do {
            try show(route: targetRoute)
        } catch {
            debugPrint("Error happened")
        }

    }

}
