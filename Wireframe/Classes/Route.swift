//
//  Route.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import Foundation

public enum RouteType: String, Codable, Hashable, CaseIterable {
    case view
    case tabbar
    case navigation
}

public enum PresentationType: String, Codable, Hashable {

    /// view will be pushed using its own navigation controller
    case push

    /// view will be presented using either top view controller of the controller itself.
    case present

    /// will call the navigation controllers popToViewController method.
    case popToView

    /// will call the navigation controllers popToRootViewController method.
    case popToRoot

    /// will call the navigation controllers  popViewController method
    case pop

    /// will call the controllers dismiss method if its navigation controller is nil, else will call the naviigation controllers dismiss method.
    case dismiss

}

public protocol Route: AnyObject, Codable {
    var presentationType: PresentationType { get set }
    var type: RouteType  { get set }
    var tabItems: [String]?  { get }
    var name: String  { get }
    var title: String { get }
    var navigation: Navigation?  { get set }
    var navigationName: String?  { get }
    var wireframe: WireframeData? { get }
    var parent: Route? { get set }
    var routes: [Route]? { get }
    var datasource: WireframeDatasource! { get }
}

// MARK: - Implementation -

public class RouteImpl: Route {

    public var datasource: WireframeDatasource!
     // MARK: - Public Properties -
    public var presentationType: PresentationType = .push
    public var type: RouteType = .view
    public var tabItems: [String]?
    public let name: String
    public let title: String
    public var navigation: Navigation?
    public var navigationName: String?
    public var routes: [Route]?
    public weak var parent: Route?
    public weak var wireframe: WireframeData?

    public func set(wireframeData: WireframeData?) throws {
        assert(wireframe.isNil && datasource.isNil)
        wireframe = wireframeData
        if let wireframe = wireframe {
            datasource = WireframeDatasourceImpl(wireframe: wireframe)
        }
    }

    enum CodingKeys: CodingKey, CaseIterable {
        case type
        case tabItems
        case name
        case title
        case navigation
        case subroutes
        case presentationType
    }

    // MARK: - Private Properties -

    private(set) var subroutes: [RouteName]?
   
    // MARK: - Private Resources -

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        presentationType = try container.debugDecodeIfPresent(PresentationType.self, forKey: .presentationType, parent: Self.self) ?? .push

        name = try container.debugDecode(String.self, forKey: .name, parent: Self.self)
        title = try container.debugDecode(String.self, forKey: .title, parent: Self.self)

        do {
            type = try container.decode(RouteType.self, forKey: .type)
        } catch {
            let decodedString = try container.decodeIfPresent(String.self, forKey: .type)
            if let routeType = decodedString {
                throw WireframeError.invalidRouteType(routeType)
            }

            type = .view

        }

        subroutes = try container.debugDecodeIfPresent([RouteName].self, forKey: .subroutes, parent: Self.self)

        do {
            navigation = try container.debugDecodeIfPresent(Navigation.self, forKey: .navigation, parent: Self.self)
        } catch let error {
            if let wireframeError = error as? WireframeError {
                throw wireframeError
            }

            navigationName = try container.decodeIfPresent(String.self, forKey: .navigation)
        }

        switch type {
        case .tabbar:

            if subroutes.isNotNil {
                throw WireframeError.subroutesRedundant(name)
            }

            do {
                tabItems = try container.debugDecode([RouteName].self, forKey: .tabItems, parent: Self.self)
            } catch {
                throw WireframeError.tabItemsKeyNotPresent(name)
            }
        case .navigation:
            if presentationType == .push {
                throw WireframeError.navigationControllerBeingPushed(name)
            }
        default:
            tabItems = nil
        }

    }

    // MARK: - Deinitialisation -

    deinit {
        debugPrint("\(String(describing: Self.self)) deinit: \(String(describing: wireframe))")
    }
}

// MARK: - Extension - KeyedDecodingContainer -

extension KeyedDecodingContainer where K == RouteImpl.CodingKeys {

    func debugDecode<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parent: Decodable.Type) throws -> T {
        do {
            return try decode(T.self, forKey: key)
        } catch let error {
            debugPrint("Decoding Error: \(String(describing: parent.self)) \(key.stringValue): could not be decoded")
            debugPrint("File: \(#file) Line: \(#line)")
            debugPrint(K.allCases)
            throw error
        }

    }

    func debugDecodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parent: Decodable.Type) throws -> T? {
        try decodeIfPresent(T.self, forKey: key)
    }

}

// MARK: - Extension - Route -

extension RouteImpl {

//    var navigationBar: Navigation {
//        return navigation ?? Navigation(name: name)
//    }

    func setNavigation() throws {
        guard navigation.isNil, let navName = navigationName else { return }

        navigation = try wireframe?.tryNavigation(for: navName)
        
    }

    func setSubRoutes() throws {
        routes = routes ?? []

        var subrouteNames = Set<String>()

        try subroutes?.forEach { subrouteName in

            if subrouteName == name {
                throw WireframeError.subrouteContainsOwnRoute(subrouteName, self)
            }

            if subrouteNames.contains(subrouteName) {
                throw WireframeError.duplicateSubroute(subrouteName, self)
            }

            subrouteNames.insert(subrouteName)

            if let subRoute = wireframe?.route(for: subrouteName) {
                subRoute.parent = self
                routes?.append(subRoute)
            } else {
                let debugError = WireframeError.subrouteNotExist(subrouteName, self)
                debugPrint(debugError.title)
                debugPrint(debugError.localizedDescription)
                debugPrint("File: \(#file) Line: \(#line)")
                throw debugError
            }
        }
    }

}

// MARK: - Extension - RouteButtons -

public extension Route {

    var childRoutes: [Route] {
        guard let setRoutes = routes else {
            assertionFailure("Why are the routes not been set to a default value?")
            return []
        }

        return setRoutes
    }

    var buttons: [RouteButton] {
        childRoutes.map { subroute in
            let button = RouteButton()
            button.title = subroute.title
            return button
        }
    }

}

extension RouteImpl: Hashable {

    public static func == (lhs: RouteImpl, rhs: RouteImpl) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(title)
        hasher.combine(navigation)
        hasher.combine(subroutes)
    }

}
