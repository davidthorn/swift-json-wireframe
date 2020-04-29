//
//  WireframeData.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

public class WireframeData: Codable {
    let appName: String
    let routes: [Route]
    let root: RouteName
}

extension WireframeData {

    func route(for name: String) -> Route? {
        routes.first { $0.name == name }
    }

}
