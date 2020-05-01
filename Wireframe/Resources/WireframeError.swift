//
//  WireframeError.swift
//  Wireframe
//
//  Created by Thorn, David on 01.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

public enum WireframeError: Error {

    case navigationPluginNotExists
    case navigationDoesNotExist

    case wireframeDataDecoding

    public var localizedDescription: String {
        switch self {
        case .navigationDoesNotExist:
            return "The navigation does not exist"
        case .navigationPluginNotExists:
            return "An navigation plugin does not exist"
        case .wireframeDataDecoding:
            return "An error occurred during the decoding of the data"
        }
    }

}
