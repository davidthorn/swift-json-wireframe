//
//  MockWireframeDatasource.swift
//  WireframeTests
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit
import Wireframe

public final class MockWireframeDatasource: WireframeDatasource {
    
    public var wireframe: WireframeData?
    
    public init() { }
    
    public func plugin(with name: RouteName) -> Plugin? {
        assertionFailure("Not yet implemented")
        return nil
    }
    
    public func controller(with name: RouteName) -> UIViewController? {
        assertionFailure("Not yet implemented")
        return nil
    }
    
    public func controller(for route: Route) -> UIViewController {
        assertionFailure("Not yet implemented")
        fatalError()
    }
    
    public func plugin(with name: RouteName) -> NavigationPlugin? {
        assertionFailure("Not yet implemented")
        return nil
    }
    
}
