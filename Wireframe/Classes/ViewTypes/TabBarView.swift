//
//  TabBarView.swift
//  Wireframe
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public final class TabBarView: UITabBarController {

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

    public override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        title = route.title
        view.backgroundColor = .white

        if let navigation = route.navigation {
            var leftButtons = navigationItem.leftBarButtonItems ?? []
            var rightButtons = navigationItem.rightBarButtonItems ?? []

            navigation.buttons?.enumerated().forEach { info in
                let barButton = UIBarButtonItem(title: info.element.name,
                                                style: .plain,
                                                target: self,
                                                action: #selector(barButtonTapped))
                barButton.tag = info.offset
                switch info.element.buttonType {
                case .left:
                    navigationItem.leftItemsSupplementBackButton = true
                    leftButtons.append(barButton)
                case .right:
                    rightButtons.append(barButton)
                }
            }

            navigationItem.setRightBarButtonItems(rightButtons, animated: true)
            navigationItem.setLeftBarButtonItems(leftButtons, animated: true)
        }

        let subItems = route.tabItems?
            .compactMap({ route.wireframe?.route(for: $0) })

        var tabController = [UIViewController]()

        subItems?.enumerated().forEach { item in
            let subItemRoute = item.element
            let commonView: UIViewController
            switch subItemRoute.type {
            case .navigation:
                let navigation = UINavigationController()
                let view = View(route: subItemRoute)
                navigation.setViewControllers([view], animated: true)
                view.didMove(toParent: navigation)
                navigation.tabBarItem = view.tabBarItem
                commonView = navigation
            case .view:
                let view = View(route: subItemRoute)
                commonView = view
            case .tabbar:
                fatalError("A tab bar cannot sit within a tab bar!")
            }

            commonView.tabBarItem = .init(title: subItemRoute.name, image: nil, tag: item.offset)
            tabController.append(commonView)
        }

        viewControllers = tabController

    }

    @objc func barButtonTapped(button: UIBarButtonItem) {

        if route.navigation?.buttons?[button.tag] == nil {
            assertionFailure("The button does not exist")
        }

        if let name = route.navigation?.buttons?[button.tag].target, let targetRoute = route.wireframe?.route(for: name) {
            let view = View(route: targetRoute)
            navigationController?.pushViewController(view, animated: true)
        }
    }

    public func setRightBarButtons() {
        let buttons = route.navigationBar.rightBarButtonItems

        var rightButtons = navigationItem.rightBarButtonItems ?? []

        buttons.enumerated().forEach { info in
            let barButton: UIBarButtonItem
            if let icon = info.element.icon {
                let image = UIImage(named: icon.imageName, in: .main, compatibleWith: nil)
                barButton = .init(image: image, style: .plain, target: self, action: #selector(barButtonTapped))
            } else {
                barButton = UIBarButtonItem(title: info.element.name,
                                            style: .plain,
                                            target: self,
                                            action: #selector(barButtonTapped))
            }
            barButton.tag = info.offset
            rightButtons.append(barButton)
        }

        navigationItem.setRightBarButtonItems(rightButtons, animated: true)
    }

    public func setLeftBarButtons() {
        let buttons = route.navigationBar.leftBarButtonItems

        var leftButtons = navigationItem.leftBarButtonItems ?? []
        navigationItem.leftItemsSupplementBackButton = true

        buttons.enumerated().forEach { info in
            let barButton: UIBarButtonItem
            if let icon = info.element.icon {
                let image = UIImage(named: icon.imageName, in: .main, compatibleWith: nil)
                barButton = .init(image: image, style: .plain, target: self, action: #selector(barButtonTapped))
            } else {
                barButton = UIBarButtonItem(title: info.element.name,
                                            style: .plain,
                                            target: self,
                                            action: #selector(barButtonTapped))
            }

            barButton.tag = info.offset
            leftButtons.append(barButton)
        }

        navigationItem.setLeftBarButtonItems(leftButtons, animated: true)
    }

    deinit {
        debugPrint("\(String(describing: Self.self)) \(route.title) deinit")
    }
}


// MARK: - Extension - RouteButtonDelegate -

extension TabBarView: RouteButtonDelegate {

    public func buttonTapped(tag: Int) {
        guard let route = route.routes?[tag] else { return }
        let commonView: UIViewController
        switch route.type {
        case .view:
            commonView = View(route: route)
        case .tabbar:
            commonView = TabBarView(route: route)
        case .navigation:
            let navigation = UINavigationController()
            let view = View(route: route)
            navigation.setViewControllers([view], animated: true)
            view.didMove(toParent: navigation)
            commonView = navigation
        }

        let view = route.controller(with: route.name) ?? commonView
        navigationController?.pushViewController(view, animated: true)
    }

}
