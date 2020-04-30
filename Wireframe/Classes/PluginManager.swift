//
//  PluginManager.swift
//  JSONWireframe
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

// MARK: - Implementation -

public class PluginManager {

     // MARK: - Public Properties -

    /// Store all plugins that are transient
    public static var plugins: [String: Plugin] = [:]

}
