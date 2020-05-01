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
