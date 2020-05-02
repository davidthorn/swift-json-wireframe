//
//  DefaultRoute.swift
//  Wireframe
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

struct DefaultRoute: Codable {
    let name: String
    let title: String
    let presentationType: PresentationType

    var route: RouteImpl {
        do {
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()

            let encodedValue = try encoder.encode(self)
            let route = try decoder.decode(RouteImpl.self, from: encodedValue)
            return route
        } catch {
            assertionFailure("encoding of the dismiss button did not work")
            fatalError()
        }
    }
}


public extension RouteImpl {

    static var dismiss: RouteImpl {
        DefaultRoute(name: "dismiss", title: "dismiss", presentationType: .dismiss).route
    }

    static var pop: RouteImpl {
        DefaultRoute(name: "pop", title: "pop", presentationType: .pop).route
    }

    static var popToRoot: RouteImpl {
        DefaultRoute(name: "popToRoot", title: "popToRoot", presentationType: .popToRoot).route
    }

    static var popToView: RouteImpl {
        DefaultRoute(name: "popToView", title: "popToView", presentationType: .popToView).route
    }

    static let defaultRoutes: [RouteImpl] = [
        .dismiss, .pop, .popToRoot, .popToView
    ]

}
