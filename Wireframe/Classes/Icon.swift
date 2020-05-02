//
//  Icon.swift
//  Wireframe
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Implementation -

public class Icon: Codable, Hashable {

     // MARK: - Public Properties -
    
    public let imageName: String

    // MARK: - Hashable -

    public static func == (lhs: Icon, rhs: Icon) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(imageName)
    }
}

// MARK: - Extension - Icon -

public extension Icon {

    func image() throws -> UIImage? {

       let loadedImage = UIImage(named: imageName,
                in: .main,
                compatibleWith: nil)

        if loadedImage.isNil {
            let error = WireframeError.resourceImageDoesNotExist(imageName)
            debugPrint("Resource image \(error.localizedDescription) does not exist")
            debugPrint("Error in file: \(#file) Line: \(#line)")
            throw error
        }

        return loadedImage
    }

    func barButtonItem(selector: Selector, target: Any) throws -> UIBarButtonItem {
        .init(image: try image(), style: .plain, target: target, action:selector)
    }

}
