//
//  ErrorViewController.swift
//  Wireframe
//
//  Created by Thorn, David on 01.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit
import ListItemPlugin

public final class ErrorViewController: UIViewController {

    let errorTitle: String
    let message: String

    public convenience init(error: WireframeError) {
        self.init(title: error.title, message: error.localizedDescription)
    }

    public init(title: String, message: String) {
        errorTitle = title
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }

    public convenience init(error: ListItemPluginError) {
        self.init(title: "List View Error", message: error.localizedDescription)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
//            fatalError()
        }

        let alert = UIAlertController(
            title: errorTitle,
            message: message,
            preferredStyle: .alert)
        alert.addAction(okAction)

        present(alert, animated: true)
    }

}

public enum ErrorView {
    
    case message(controller: UIViewController, error: WireframeError)
    case listPluginMessage(controller: UIViewController, error: ListItemPluginError)

    func show() {
        switch self {
        case .message(let controller, let error):
            let alertController = ErrorViewController(error: error)
            controller.present(alertController, animated: true)
        case .listPluginMessage(let controller, let error):
            let alertController = ErrorViewController(error: error)
            controller.present(alertController, animated: true)
        }
    }

}
