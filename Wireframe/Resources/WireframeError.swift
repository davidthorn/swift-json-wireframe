//
//  WireframeError.swift
//  Wireframe
//
//  Created by Thorn, David on 01.05.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

public enum WireframeError: Error {
    case navigationButtonTargetNotExists(RouteName)
    case navigationDecoding(Navigation.CodingKeys)
    case tabItemNotExist(Route, RouteName)
    case navigationControllerBeingPushed(RouteName)
    case rootViewControllerNil
    case subroutesRedundant(RouteName)
    case tabItemsKeyNotPresent(RouteName)
    case invalidRouteType(String)
    case subrouteContainsOwnRoute(RouteName, Route)
    case duplicateSubroute(RouteName, Route)
    case routeNameAlreadyExist(RouteName)
    case subrouteNotExist(RouteName, Route)
    case unexpectedError

    case buttonNotExist(Int)

    case resourceImageDoesNotExist(String)

    case navigationTargetNotExist(String)
    case rootRouteNotExists(RouteName)

    case navigationPluginNotExists
    case navigationDoesNotExist(String)

    case wireframeDataDecoding(WireframeData.CodingKeys)
    case routeDecoding

    public var title: String {
        switch self {
        case .navigationButtonTargetNotExists:
            return "Navigaton Button Error"
        case .navigationDecoding:
            return "Navigation Decoding Error"
        case .tabItemNotExist:
            return "Tab Bar Item Error"
        case .navigationControllerBeingPushed:
            return "Presentation Type Error"
        case .rootViewControllerNil:
            return "Fatal Wireframe Data Error"
        case .subroutesRedundant:
            return "TabView Route Decoding Error"
        case .tabItemsKeyNotPresent:
            return "TabView Route Decoding Error"
        case .routeDecoding:
            return "Route Decoding Error"
        case .invalidRouteType:
            return WireframeError.routeDecoding.title
        case .subrouteContainsOwnRoute:
            return "Subroute Error"
        case .duplicateSubroute:
            return "Duplicate Subroute"
        case .routeNameAlreadyExist:
            return "Duplicate Route Name"
        case .subrouteNotExist:
            return "Sub Route Error"
        case .unexpectedError:
            return "Unexpected Error"
        case .buttonNotExist:
            return WireframeError.unexpectedError.title
        case.resourceImageDoesNotExist:
            return "Resource Image Error"
        case .navigationTargetNotExist:
            return "Navigation Button Target Error"
        case .rootRouteNotExists:
            return "Route Error"
        case .navigationDoesNotExist:
            return "Navigation Error"
        case .navigationPluginNotExists:
            return "Navigation Plugin Error"
        case .wireframeDataDecoding:
            return "Wireframe data Decoding Error"
        }
    }

    public var localizedDescription: String {
        switch self {
        case .navigationButtonTargetNotExists(let target):
            return "The navigation button target: \(target) does not match a registerd route."
        case .navigationDecoding(let key):
            return "The Navigation requires for the key: `\(key.rawValue)` to be provided."
        case .tabItemNotExist(let route, let tabItemName):
            return "The tabBarItem `\(tabItemName)` does not exist as a route for `\(route.name)`'s tabbar."
        case .navigationControllerBeingPushed(let route):
            return "Route name: \(route) is of type `navigation` and has presentation type `navigation`, should be `present`!"
        case .rootViewControllerNil:
            return "The root view controller has not been set within the constructor or in the app delegate."
        case .subroutesRedundant(let route):
            return "Route: \(route)'s view type is tabbar, the subroutes property will never be used."
        case .tabItemsKeyNotPresent(let routeName):
            return "The route `\(routeName)` must supply an array of `NavigationButton`'s when `type` is `tabbar`"
        case .routeDecoding:
            return "An error occurred during the decoding of the route"
        case .invalidRouteType(let type):
            return "Invalid route type: \(type) valid types are : \(RouteType.allCases.map{ $0.rawValue })"
        case .subrouteContainsOwnRoute(let routeName, let route):
            assert(routeName == route.name, "This route: \(routeName) is a valid subroute")
            return "Route \(route.name) is atempting to add itself as a subroute"
        case .duplicateSubroute(let routeName, let route):
            return "The subroute with name: `\(routeName)` is already registered with route `\(route.name)`"
        case .routeNameAlreadyExist(let routeName):
            return "The route with `\(routeName)` already exists"
        case .subrouteNotExist(let routeName, let route):
            return "A subroute `\(routeName)` does not exist for Route: `\(route.name)`"
        case .unexpectedError:
            return "An unexpected error has occurred, please look in the debug log."
        case .buttonNotExist:
            return WireframeError.unexpectedError.localizedDescription
        case.resourceImageDoesNotExist(let imageName):
            return "the resource image `\(imageName)` does not exist"
        case .navigationTargetNotExist(let target):
            return "The navigation button target `\(target)` does not exist"
        case .rootRouteNotExists(let routeName):
            return "The root `\(routeName)` route does not exist"
        case .navigationDoesNotExist(let name):
            return "The navigation `\(name)` does not exist"
        case .navigationPluginNotExists:
            return "An navigation plugin does not exist"
        case .wireframeDataDecoding(let key):
            return "WireframeData key: `\(key.rawValue)` missing as a top level key/value pair."
        }
    }

}
