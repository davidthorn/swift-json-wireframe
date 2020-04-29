//
//  Optional.swift
//  DTKit
//
//  Created by Thorn, David on 10.04.20.
//

import Foundation

public extension Optional where Wrapped: AnyObject {

    var isNil: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }

    var isNotNil: Bool {
        return !isNil
    }

}

public extension Optional where Wrapped: Any {

    var isNil: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }

    var isNotNil: Bool {
        return !isNil
    }

}
