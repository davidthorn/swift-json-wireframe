//
//  Wireframe.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public typealias RouteName = String

// MARK: - Implementation -

public final class Wireframe {

     // MARK: - Public Properties -

    public static var plugins = [Plugin.Type]()
    public static var navigationPlugins = [NavigationPlugin.Type]()
    public var rootViewController: UIViewController?

    // MARK: - Private Properties -

    private(set) var wireframe: WireframeData!
    private(set) var navigation: UINavigationController
    private(set) var resourceUrl: URL

    // MARK: - Constructors -

    public init(navigation: UINavigationController, resourceUrl: URL, autoload: Bool = true) {
        self.navigation = navigation
        self.resourceUrl = resourceUrl
        if autoload {
            do {
                try load()
                wireframe.setDefaultRoutes()
                try setup()
            } catch let error {
                rootViewController = ErrorViewController(error: error as! WireframeError)
            }

        }
    }

     // MARK: - Public Methods -
    func load() throws {
        do {
            let data = try Data.init(contentsOf: resourceUrl)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            wireframe = try decoder.decode(WireframeData.self, from: data)
        } catch let error {
            debugPrint(error)
            throw WireframeError.wireframeDataDecoding
        }
    }

    func setup() throws {
        try wireframe.setRoutes()
        guard let root = wireframe.route(for: wireframe.root) else { return }
        
        switch root.type {
        case .tabbar:
            rootViewController = TabBarView(route: root)
        case .view:
            rootViewController =  View(route: root)
        case .navigation:
            let view =  View(route: root)
            navigation.setViewControllers([view], animated: true)
            view.didMove(toParent: navigation)
            rootViewController = navigation
        }
    }

}
