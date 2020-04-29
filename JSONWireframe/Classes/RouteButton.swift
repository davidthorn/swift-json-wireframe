//
//  RouteButton.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

class RouteButton: UIControl {

    let label = UILabel()

    let route: Route!
    weak var controller: UIViewController!

    public init(route: Route, controller: UIViewController) {
        self.route = route
        self.controller = controller
        super.init(frame: .zero)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(label)
        label.edgesToSuperview()
        label.textAlignment = .center
        label.text = route.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonTapped() {
        let view = Wireframe.plugins.first { $0.init().name == route.name }?.init().controller(route: route) ?? View(route: route)
        controller.navigationController?.pushViewController(view, animated: true)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .systemBlue
        label.textColor = .white
        layer.cornerRadius = 20
    }


}
