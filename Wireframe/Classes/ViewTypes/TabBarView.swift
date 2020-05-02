//
//  TabBarView.swift
//  Wireframe
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Implementation -

public final class TabBarView: UITabBarController, NavigationManager {

    // MARK: - Public Properties -

    public let route: Route!

    // MARK: - Private UI Properties -

    // MARK: - Constructors -

    public init(route: Route) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController Lifecycle -

    public override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        title = route.title
        view.backgroundColor = .white
        do {
            try configureNavigationBarItem(selector: #selector(barButtonTapped))
        } catch let error {
            let debugError = error as! WireframeError
            debugPrint(debugError.localizedDescription)
            debugPrint("Error in file: \(#file) Line: \(#line)")
            ErrorView.message(controller: self, error: debugError).show()
        }

        viewControllers = tabBarControllers()

    }

    // MARK: - Selectors -

    @objc func barButtonTapped(button: UIBarButtonItem) {

        if route.navigation?.buttons?[button.tag] == nil {
            assertionFailure("The button does not exist")
        }

        if let name = route.navigation?.buttons?[button.tag].target, let targetRoute = route.wireframe?.route(for: name) {
            let view = View(route: targetRoute)
            show(controller: view, route: targetRoute)
        }
    }

    // MARK: - Deinitialisation -

    deinit {
        debugPrint("\(String(describing: Self.self)) \(route.title) deinit")
    }
}

// MARK: - Extension - RouteButtonDelegate -

extension TabBarView: RouteButtonDelegate {

    public func handleError(error: WireframeError) {
        debugPrint("\(error.title)")
        debugPrint("Error: \(error.localizedDescription)")
        debugPrint("FIle: \(#file) Line: \(#line)")
        ErrorView.message(controller: self, error: error).show()
    }

    public func buttonTapped(tag: Int) throws {
        guard let route = route.routes?[tag] else {
            throw WireframeError.buttonNotExist(tag)
        }
        let commonView: UIViewController
        switch route.type {
        case .view:
            commonView = route.datasource.controller(with: route.name) ?? View(route: route)
        case .tabbar:
            commonView = route.datasource.controller(with: route.name) ?? TabBarView(route: route)
        case .navigation:
            commonView = navigationController(containing: route)
        }

        show(controller: route.datasource.controller(with: route.name) ?? commonView, route: route)

    }

    func tabBarControllers() -> [UIViewController] {
        let subItems = route.tabItems?
            .compactMap({ route.wireframe?.route(for: $0) })

        var tabController = [UIViewController]()

        subItems?.enumerated().forEach { item in
            let subItemRoute = item.element
            let commonView: UIViewController
            switch subItemRoute.type {
            case .navigation:
                commonView = navigationController(containing: subItemRoute)
            case .view:
                commonView = route.datasource.controller(with: subItemRoute.name) ?? View(route: subItemRoute)
            case .tabbar:
                fatalError("A tab bar cannot sit within a tab bar!")
            }

            commonView.tabBarItem = .init(title: subItemRoute.name, image: nil, tag: item.offset)
            tabController.append(commonView)
        }

        return tabController
    }

    func navigationController(containing subItemRoute: Route) -> UIViewController {
        let navigation = UINavigationController()
        let view = route.datasource.controller(with: subItemRoute.name) ?? View(route: subItemRoute)
        navigation.setViewControllers([view], animated: true)
        view.didMove(toParent: navigation)
        return navigation
    }

    func show(controller: UIViewController, route: Route) {
        navigationController?.pushViewController(
            controller,
            animated: true
        )
    }

}
