//
//  RoutableView.swift
//  JSONWireframe
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

// MARK: - Protocol -

public protocol RoutableView: AnyObject {

    /// The route of the view.
    var route: Route { get }

}
