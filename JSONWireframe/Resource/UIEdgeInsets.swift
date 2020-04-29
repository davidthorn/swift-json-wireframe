//
//  UIEdgeInsets.swift
//  BaseProject
//
//  Created by David Thorn on 12.01.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public extension UIEdgeInsets {

    /// Creates a UIEdgeInsets using the horizontal values as left / right and the vertical for top / bottom,
    /// - Parameters:
    ///   - horizontal: The value used for left and right
    ///   - vertical: The value used for top and bottom
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    /// Returns UIEdgeInsets object witin only the left and right properties set to that of the constant.
    /// - Parameter constant: The constant that is used for the left and right property.
    static func horizontal(constant: CGFloat) -> UIEdgeInsets {
        .init(horizontal: constant, vertical: 0)
    }

    /// Default constructor to set all sides to the same value.
    /// - Parameter value: Value used for all insets
    init(value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }

    /// Creates a UIEdgeInsets
    /// - Parameters:
    ///   - top: The top value used if the vertical parameter is nil
    ///   - bottom: The top value used if the vertical parameter is nil
    ///   - left: The top value used if the horizontal parameter is nil
    ///   - right: The top value used if the horizontal parameter is nil
    ///   - horizontal: The value used for left and right is not nil
    ///   - vertical: The value used for top and bottom is not nil
    init(
        top: CGFloat = 0,
        bottom: CGFloat = 0,
        left: CGFloat = 0,
        right: CGFloat = 0,
        horizontal: CGFloat? = nil,
        vertical: CGFloat? = nil
    ) {

        self.init(
            top: vertical ?? top,
            left: horizontal ?? left,
            bottom: vertical ?? bottom,
            right: horizontal ?? right
        )
    }

}


extension UIEdgeInsets: Hashable {

    static func == (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(top)
        hasher.combine(bottom)
        hasher.combine(left)
        hasher.combine(right)
    }
}
