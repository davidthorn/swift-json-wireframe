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

//            let llll = wireframe
//
//            wireframe.routes.forEach { route in
//                route.wireframe = wireframe
//
//                let subviewRoutes = route.subroutes
//                route.routes = subviewRoutes?.compactMap {
//                    let childRoute = wireframe.route(for: $0)
//                    childRoute?.parent = route
//                    return childRoute
//                }
//                if let subviews = route.routes {
//                    subviews.forEach { subroute in
//                        debugPrint(subroute.name)
//                    }
//                }
//
//            }

            if let root = wireframe.route(for: wireframe.root) {
                let view = View(route: root)
                navigation.setViewControllers([view], animated: true)
                view.didMove(toParent: navigation)
            }


            debugPrint(wireframe)
            
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }

}

