//
//  MockRouteButtonDelegate.swift
//  WireframeTests
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation
import Wireframe

public final class MockRouteButtonDelegate: RouteButtonDelegate {

    public init() {

    }

    var buttonTappedCalled: Int = 0
    var buttonTappedTag: Int?
    public func buttonTapped(tag: Int) throws {
        buttonTappedCalled += 1
        buttonTappedTag = tag

    }

    var handleErrorCalled: Int = 0
    var handleErrorError: WireframeError?
    public func handleError(error: WireframeError) {
        handleErrorError = error
        handleErrorCalled += 1
    }

}
