//
//  Route.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

public class Route: Codable {
    let name: String
    let title: String
    let subroutes: [RouteName]?
    var routes: [Route]?
    let navigation: Navigation?
    weak var parent: Route?
    weak var wireframe: WireframeData? {
        didSet {
            debugPrint("\(String(describing: Self.self)) wireframe: \(name)")
        }
    }
    func setSubRoutes() {
        routes = routes ?? []
        subroutes?.forEach { subrouteName in
            if let subRoute = wireframe?.route(for: subrouteName) {
                subRoute.parent = self
                routes?.append(subRoute)
            }
        }
    }

    deinit {
        debugPrint("\(String(describing: Self.self)) deinit: \(String(describing: wireframe))")
    }
}
