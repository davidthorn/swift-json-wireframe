//
//  Wireframe.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit
import ListItemPlugin

public typealias RouteName = String

// MARK: - Implementation -

public final class Wireframe {

     // MARK: - Public Properties -

    public static var plugins = [Plugin.Type]()
    public static var navigationPlugins = [NavigationPlugin.Type]()
    public var rootViewController: UIViewController?

    // MARK: - Private Properties -

    private(set) var wireframeData: WireframeData?
    private(set) var wireframe: WireframeData {
        get {
            if let data = wireframeData {
                return data
            }

            fatalError("Accessing the wireframe data prior to it being loaded is not permitted")

        }
        set {
            wireframeData = newValue
        }
    }

    public func getWireframe() throws -> WireframeData {
        if wireframeData.isNil {
            throw WireframeError.wireframeDataNil
        }

        return wireframe
    }

    private(set) var datasourceHandler: (WireframeData) -> WireframeDatasource
    internal var datasource: WireframeDatasource {
        if wireframeData.isNil {
            assertionFailure("The wireframe data has not bee set, meaning that the load method has not been called")
        }

        return datasourceHandler(wireframe)
    }

    private(set) var navigation: UINavigationController
    private(set) var resourceUrl: URL

    // MARK: - Constructors -

    public init(navigation: UINavigationController, resourceUrl: URL, datasourceHandler: @escaping (WireframeData) -> WireframeDatasource, autoload: Bool = true) {
        self.navigation = navigation
        self.resourceUrl = resourceUrl
        self.datasourceHandler = datasourceHandler

        guard autoload else { return }
        
        do {
            try configure()
        } catch let error {
            if let debugError = error as? WireframeError {
                rootViewController = ErrorViewController(error: debugError)
            } else {
                rootViewController = ErrorViewController(error: .unknownError(error))
            }

        }
    }

    func configure() throws {
        wireframe = try load()
        wireframe.setDefaultRoutes()
        try setup()
    }

     // MARK: - Public Methods -
    func load() throws -> WireframeData {
        let data = try Data.init(contentsOf: resourceUrl)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedwireframeData = try decoder.decode(WireframeData.self, from: data)
        decodedwireframeData.datasource = datasourceHandler(decodedwireframeData)
        return decodedwireframeData
    }

    func setup() throws {
        try wireframe.setRoutes()
        guard let root = wireframe.route(for: wireframe.root) else {
            throw WireframeError.rootRouteNotExists(wireframe.root)
        }

        switch root.type {
        case .tabbar:
            rootViewController = TabBarView(route: root)
        case .view:
            rootViewController = View(route: root)
        case .navigation, .list:
            let view = root.type == .list ?  ListViewController(route: root) : View(route: root)
            navigation.setViewControllers([view], animated: true)
            view.didMove(toParent: navigation)
            rootViewController = navigation
        case .tableview:
            rootViewController = ListViewController(route: root)
        }
    }

}

// MARK: - Extension - Wireframe -

extension Wireframe {

    func set(wireframe: WireframeData) {
        wireframeData = wireframe
    }

}
