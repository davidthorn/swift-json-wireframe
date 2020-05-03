//
//  ListViewPresentor.swift
//  Wireframe
//
//  Created by Thorn, David on 03.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation
import ListItemPlugin

public protocol ListViewPresentor: AnyObject {

    func throwError(error: ListItemPluginError)
    func itemTapped(_ item: ListItem)

}
