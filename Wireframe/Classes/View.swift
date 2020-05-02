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

        route.buttons.enumerated().forEach {
            $0.element.delegate = self
            $0.element.tag = $0.offset
            stackView.addArrangedSubview($0.element)
        }

        do {
            try configureNavigationBarItem(selector: #selector(barButtonTapped))
        } catch let error {
            let debugError = error as! WireframeError
            debugPrint(debugError.localizedDescription)
            debugPrint("Error in file: \(#file) Line: \(#line)")
            ErrorView.message(controller: self, error: debugError).show()
        }

        if route.presentationType == .push, route.type == .view, navigationController.isNil {
            route.presentationType = .present
            assert(route.presentationType == .present)
        }

    }

    @objc func barButtonTapped(button: UIBarButtonItem) {

        if route.navigation?.buttons?[button.tag] == nil {
            assertionFailure("The button does not exist")
        }

        if let name = route.navigation?.buttons?[button.tag].target, let targetRoute = route.wireframe?.route(for: name) {

            let view = targetRoute.datasource.controller(for: targetRoute)
            switch targetRoute.presentationType {
            case .push:
                navigationController?.pushViewController(view, animated: true)
            case .present:
                let presentor = navigationController?.topViewController ?? self
                presentor.present(view, animated: true)
            case .pop:
                navigationController?.popViewController(animated: true)
            case .popToRoot:
                navigationController?.popToRootViewController(animated: true)
            case .popToView:
                navigationController?.popToViewController(view, animated: true)
            case .dismiss:
                let presentor = navigationController ?? self
                presentor.dismiss(animated: true)
            }
        }
    }

    deinit {
        debugPrint("\(String(describing: Self.self)) \(route.title) deinit")
    }
}


// MARK: - Extension - RouteButtonDelegate -

extension View: RouteButtonDelegate {

    public func handleError(error: WireframeError) {
        debugPrint("\(error.title)")
        debugPrint("Error: \(error.localizedDescription)")
        debugPrint("FIle: \(#file) Line: \(#line)")
        ErrorView.message(controller: self, error: error).show()
    }

    public func buttonTapped(tag: Int) {
        guard let route = route.routes?[tag] else { return }

        if route.presentationType == .push, navigationController.isNil {
            route.presentationType = .present
            route.type = .navigation
            assert(route.presentationType == .present)
        }

        let view = route.datasource.controller(for: route)
        switch route.presentationType {
        case .push:
            if route.type == .navigation {
                assertionFailure("Its gonna crash here, the presentType requires to be present")
            }
            navigationController?.pushViewController(view, animated: true)
        case .present:
            let presentor = navigationController?.topViewController ?? self
            presentor.present(view, animated: true)
        case .pop:
            navigationController?.popViewController(animated: true)
        case .popToRoot:
            navigationController?.popToRootViewController(animated: true)
        case .popToView:
            navigationController?.popToViewController(view, animated: true)
        case .dismiss:
            let presentor = navigationController ?? self
            presentor.dismiss(animated: true)
        }

    }

}
