//
//  AppDelegate.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit
import Wireframe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var wireframe: Wireframe!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Wireframe.plugins.append(ProfilePlugin.self)

        let nav = UINavigationController()

        guard let url = Bundle.main.url(forResource: "wireframe", withExtension: "json") else{
            assertionFailure("could not load wireframe file")
            return true
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        wireframe = Wireframe(navigation: nav, resourceUrl: url)
        window?.rootViewController = wireframe.rootViewController
        window?.makeKeyAndVisible()
        return true
    }



}

