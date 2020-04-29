//
//  Plugin.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public protocol Plugin: AnyObject {

    var name: String { get }

    func controller(route: Route) -> UIViewController

    init()
}
