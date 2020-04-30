//
//  View.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Implementation -

open class View: UIViewController, NavigationManager {

     // MARK: - Public Properties -

    public let route: Route!

    // MARK: - Private UI Properties -

    private let stackView = UIStackView()

    // MARK: - Constructors -

    public init(route: Route) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController Lifecycle -

    open override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        title = route.title
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.distribution = .equalSpacing

        stackView.pinTop(constant: 20)
        stackView.pinHorizontal(insets: .init(value: 20))
        stackView.pinBottom(lessThanOrEqualTo: 10)

        route.buttons.forEach {
            $0.delegate = self
            stackView.addArrangedSubview($0)
        }

        configureNavigationBarItem(selector: #selector(barButtonTapped))

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

    deinit {
        debugPrint("\(String(describing: Self.self)) \(route.title) deinit")
    }
}


// MARK: - Extension - RouteButtonDelegate -

extension View: RouteButtonDelegate {

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
