//
//  View.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Implementation -

open class View: UIViewController {

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

extension View: RouteButtonDelegate {

    public func buttonTapped(tag: Int) {
        guard let route = route.routes?[tag] else { return }

        let commonView = View(route: route)
        let view = route.controller(with: route.name) ?? commonView
        navigationController?.pushViewController(view, animated: true)
    }

}
