//
//  Icon.swift
//  Wireframe
//
//  Created by Thorn, David on 30.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Implementation -

public class Icon: Codable {
    let imageName: String
}

// MARK: - Extension - Icon -

public extension Icon {

    var image: UIImage? {
        UIImage(named: imageName,
                in: .main,
                compatibleWith: nil)
    }

    func barButtonItem(selector: Selector, target: Any) -> UIBarButtonItem {
        .init(image: image, style: .plain, target: target, action:selector)
    }

}
