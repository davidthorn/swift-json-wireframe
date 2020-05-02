//
//  ErrorViewController.swift
//  Wireframe
//
//  Created by Thorn, David on 01.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public final class ErrorViewController: UIViewController {

    let error: WireframeError

    public init(error: WireframeError) {
        self.error = error
        super.init(nibName: nil, bundle: nil)
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
            fatalError()
        }

        let alert = UIAlertController(
            title: error.title,
            message: error.localizedDescription,
            preferredStyle: .alert)
        alert.addAction(okAction)

        present(alert, animated: true)
    }

}

public enum ErrorView {
    
    case message(controller: UIViewController, error: WireframeError)

    func show() {
        switch self {
        case .message(let controller, let error):
            let alertController = ErrorViewController(error: error)
            controller.present(alertController, animated: true)
        }
    }

}
