//
//  NavigationManager.swift
//  Wireframe
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public protocol NavigationManager: AnyObject {

    /// The route that contains the navigation property
    var route: Route! { get }

    /// The navigation item used to add the bar button items
    var navigationItem: UINavigationItem {get  }

    /// The method that should be called within viewDidLoad for the bar buttons items to be added.
    /// - Parameter selector: The selector used for the var button items.
    func configureNavigationBarItem(selector: Selector) throws

}

// MARK: - Extension - NavigationManager -

extension NavigationManager {

    /// The method that should be called within viewDidLoad for the bar buttons items to be added.
    /// - Parameter selector: The selector used for the var button items.
    public func configureNavigationBarItem(selector: Selector) throws {
        guard let navigation = self.route.navigation else { return }

        var leftButtons = navigationItem.leftBarButtonItems ?? []
        var rightButtons = navigationItem.rightBarButtonItems ?? []

        try navigation.barButtonsItems.enumerated().forEach { info in

            if let wireframe = route.wireframe, wireframe.route(for: info.element.target).isNil {
                let debugError = WireframeError.navigationTargetNotExist(info.element.target)
                debugPrint(debugError.localizedDescription)
                debugPrint("Error in file: \(#file) Line: \(#line)")
                throw debugError
            }

            let barButton: UIBarButtonItem
            if let icon = info.element.icon {
                barButton = try icon.barButtonItem(selector: selector, target: self)
            } else {
                barButton = UIBarButtonItem(title: info.element.name,
                                            style: .plain,
                                            target: self,
                                            action: selector)
            }
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
