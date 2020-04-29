//
//  View.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public class View: UIViewController {

    private let route: Route!

    private let stackView = UIStackView()

    public init(route: Route) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
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

        route.routes?.forEach { subroute in
            let button = RouteButton(route: subroute, controller: self)
            stackView.addArrangedSubview(button)
            button.height(constant: 50)
        }

        if let navigation = route.navigation {
            var leftButtons = navigationItem.leftBarButtonItems ?? []
            var rightButtons = navigationItem.rightBarButtonItems ?? []

            navigation.buttons?.enumerated().forEach { info in
                let barButton = UIBarButtonItem(title: info.element.name,
                                                style: .plain,
                                                target: self,
                                                action: #selector(barButtonTapped))
                barButton.tag = info.offset
                switch info.element.type {
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

