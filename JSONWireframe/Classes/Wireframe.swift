//
//  Wireframe.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public typealias RouteName = String

public final class Wireframe {

    public static var plugins = [Plugin.Type]()
    var wireframe: WireframeData!
    let navigation: UINavigationController

    public init(navigation: UINavigationController) {
        self.navigation = navigation
    }

    public func load() {

        guard let url = Bundle.main.url(forResource: "wireframe", withExtension: "json") else{
            assertionFailure("could not load wireframe file")
            return
        }

        do {
            let data = try Data.init(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            wireframe = try decoder.decode(WireframeData.self, from: data)
            wireframe.setRoutes()
            if let root = wireframe.route(for: wireframe.root) {
                let view = View(route: root)
                navigation.setViewControllers([view], animated: true)
                view.didMove(toParent: navigation)
            }
            
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }

}

