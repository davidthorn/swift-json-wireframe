//
//  ErrorViewController.swift
//  Wireframe
//
//  Created by Thorn, David on 01.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {

    let error: WireframeError

    init(error: WireframeError) {
        self.error = error
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            fatalError()
        }

        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert)
        alert.addAction(okAction)

        present(alert, animated: true)
    }

}
