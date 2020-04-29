//
//  Constraint.swift
//  BaseProject
//
//  Created by David Thorn on 12.01.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

public extension UIView {

    @discardableResult
    func constrain() -> Self? {
        guard superview.isNotNil else { return nil }
        
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    /// Pins the horizontal and vertical edges to the views superview.
    /// - Parameter insets: Sets the constant / offset property of the constraint.
    func edgesToSuperview(
        insets: UIEdgeInsets = .zero,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) {
        pinHorizontal(insets: insets, identifier: identifier, priority: priority)
        pinVertical(insets: insets, identifier: identifier, priority: priority)
    }

    /// Constrains the views trailing and leading anchor to that of its parents using the insets as constants.
    /// - Parameter insets:  Left and right property are used as the insets.
    @discardableResult
    func pinHorizontal(
        insets: UIEdgeInsets = .zero,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> (leading: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        (
            leading: pinLeading(
                constant: insets.left,
                identifier: "\(identifier ?? String(describing: self))-leading",
                priority: priority
            ),
            trailing: pinTrailing(
                constant: insets.right,
                identifier: "\(identifier ?? String(describing: self))-trailing",
                priority: priority
            )
        )
    }

    /// Constrains the views top and bottom anchor to that of its parents using the insets as constants.
    /// - Parameter insets: Top and bottom property are used as the insets.
    @discardableResult
    func pinVertical(
        insets: UIEdgeInsets = .zero,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> (top: NSLayoutConstraint, bottom: NSLayoutConstraint) {
        (
            top: pinTop(
                constant: insets.top,
                identifier: "\(identifier ?? String(describing: self))-top",
                priority: priority),
            bottom: pinBottom(
                constant: -abs(insets.bottom),
                identifier: "\(identifier ?? String(describing: self))-bottom",
                priority: priority)
        )
    }

}

// MARK: - Extension - Trailing Anchor -

public extension UIView {

    @discardableResult
    func pinTrailing(
        constant: CGFloat = 0,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
            fatalError("View has not been added to parent")
        }

        let constraint = trailingAnchor.constraint(
            equalTo: parentView.trailingAnchor,
            constant: -abs(constant)
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    @discardableResult
    func pinTrailing(
        greaterThanOrEqualTo constant: CGFloat,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
            fatalError("View has not been added to parent")
        }

        let constraint = trailingAnchor.constraint(
            greaterThanOrEqualTo: parentView.trailingAnchor,
            constant: -abs(constant)
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    @discardableResult
    func pinTrailing(
        lessThanOrEqualTo constant: CGFloat,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
            fatalError("View has not been added to parent")
        }

        let constraint = trailingAnchor.constraint(
            lessThanOrEqualTo: parentView.trailingAnchor,
            constant: -abs(constant)
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    /// Sets the views trailing anchor to that of it views leading or trailing anchor based upon the edge provided.
    /// - Parameters:
    ///   - view: The view that this views anchor will be constraint to.
    ///   - edge: Either left or right will be used to determine that edge of the view that should be used.
    ///   - constant: The constant
    @discardableResult
    func pinTrailing(
        view: UIView,
        edge: UIRectEdge = .left,
        constant: CGFloat = 0,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        constrain()

        var constraint: NSLayoutConstraint

        switch edge {
        case .right:
            constraint = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -abs(constant))
        case .left:
            constraint = trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)
        default:
            fatalError("Illegal use of method")
        }

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )

    }

}


// MARK: - Extension - Leading Anchor -

public extension UIView {

    @discardableResult
    func pinLeading(
        greaterThanOrEqualTo constant: CGFloat,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
            fatalError("View has not been added to parent")
        }

        let constraint = leadingAnchor.constraint(
            greaterThanOrEqualTo: parentView.leadingAnchor,
            constant: -abs(constant)
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    @discardableResult
    func pinLeading(
        lessThanOrEqualTo constant: CGFloat,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
            fatalError("View has not been added to parent")
        }

        let constraint = leadingAnchor.constraint(
            lessThanOrEqualTo: parentView.leadingAnchor,
            constant: -abs(constant)
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    @discardableResult
    func pinLead(
        view: UIView,
        edge: UIRectEdge = .right,
        constant: CGFloat = 0,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        constrain()

        var constraint: NSLayoutConstraint

        switch edge {
        case .right:
            constraint = leftAnchor.constraint(equalTo: view.rightAnchor, constant: constant)
        case .left:
            constraint = leftAnchor.constraint(equalTo: view.leftAnchor, constant: constant)
        default:
            fatalError("Illegal use of pinLead")
        }

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    @discardableResult
    func pinLeading(
        constant: CGFloat = 0,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
            fatalError("View has not been added to parent")
        }

        let constraint = leadingAnchor.constraint(
            equalTo: parentView.leadingAnchor,
            constant: constant
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

}


// MARK: - Extension - Width Anchor -

public extension UIView {

    @discardableResult
    func width(
        constant: CGFloat,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        constrain()

        let constraint = widthAnchor.constraint(equalToConstant: constant)

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    @discardableResult
    func width(
        equalTo dimension: NSLayoutDimension,
        multiplier: CGFloat,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        constrain()

        let constraint = widthAnchor.constraint(
            equalTo: dimension,
            multiplier: multiplier
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    @discardableResult
    func width(
        view: UIView,
        multiplier: CGFloat = 1,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        constrain()

        let constraint = widthAnchor.constraint(
            equalTo: view.widthAnchor,
            multiplier: multiplier
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

}

// MARK: - Extension - Height  Anchor -

public extension UIView {

    @discardableResult
    func height(
        equalTo constant: NSLayoutDimension,
        multiplier: CGFloat,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        constrain()

        let constraint = heightAnchor.constraint(
            equalTo: constant,
            multiplier: multiplier
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    @discardableResult
    func height(
        constant: CGFloat,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        constrain()

        let constraint = heightAnchor.constraint(equalToConstant: constant)

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    @discardableResult
    func height(
        view: UIView,
        multiplier: CGFloat = 1,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        constrain()

        let constraint = heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: multiplier
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

}

// MARK: - Extension - Center X & Y Axis -

public extension UIView {

    @discardableResult
    func center(
        insets: UIEdgeInsets,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> (x: NSLayoutConstraint, y: NSLayoutConstraint) {
        (x:
            centerX(
                insets: insets,
                identifier: "\(identifier ?? String(describing: self))-centerX",
                priority: priority
            ),
         y:
            centerY(
                insets: insets,
                identifier: "\(identifier ?? String(describing: self))-centerY",
                priority: priority
            )
        )

    }

    @discardableResult
    func centerY(
        insets: UIEdgeInsets,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
            fatalError("View has not been added to parent")
        }

        let constraint = centerYAnchor.constraint(
            equalTo: parentView.centerYAnchor,
            constant: insets.top
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )

    }

    @discardableResult
    func centerX(
        insets: UIEdgeInsets,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
            fatalError("View has not been added to parent")
        }

        let constraint = centerXAnchor.constraint(
            equalTo: parentView.centerXAnchor,
            constant: insets.left
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )

    }

}

 // MARK: - Extension - Pin Bottom -

 public extension UIView {

     @discardableResult
     func pinBottom(
         constant: CGFloat = 0,
         identifier: String? = nil,
         priority: UILayoutPriority = .required
     ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
             fatalError("View has not been added to parent")
         }

         let constraint = bottomAnchor.constraint(
             equalTo: parentView.bottomAnchor,
             constant: -abs(constant)
         )

         return constraint.activate(
             identifier: identifier,
             priority: priority
         )
     }

     @discardableResult
     func pinBottom(
         lessThanOrEqualTo constant: CGFloat,
         identifier: String? = nil,
         priority: UILayoutPriority = .required
     ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
             fatalError("View has not been added to parent")
         }

         let constraint = bottomAnchor.constraint(
             lessThanOrEqualTo: parentView.bottomAnchor,
             constant: -abs(constant)
         )

         return constraint.activate(
             identifier: identifier,
             priority: priority
         )
     }

     @discardableResult
     func pinBottom(
         greaterThanOrEqualTo constant: CGFloat,
         identifier: String? = nil,
         priority: UILayoutPriority = .required
     ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
             fatalError("View has not been added to parent")
         }

         let constraint = bottomAnchor.constraint(
             greaterThanOrEqualTo: parentView.bottomAnchor,
             constant: -abs(constant)
         )

         return constraint.activate(
             identifier: identifier,
             priority: priority
         )

     }

 }



// MARK: - Extension - Pin Top  -

public extension UIView {

    /// Pins the views top anchor to its parents topAnchor
    /// - Parameters:
    ///   - constant: The amount of margin used between views
    ///   - identifier: The identifier given to the constraint.
    ///   - priority: The layout priority used for the constraint
    @discardableResult
    func pinTop(
        constant: CGFloat = 0,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
            fatalError("View has not been added to parent")
        }

        let constraint = topAnchor.constraint(equalTo: parentView.topAnchor, constant: constant)

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    /// Pins the views top anchor  lessThanOrEqualTo to its parents topAnchor
    /// - Parameters:
    ///   - constant: The amount of margin used between views
    ///   - identifier: The identifier given to the constraint.
    ///   - priority: The layout priority used for the constraint
    @discardableResult
    func pinTop(
        lessThanOrEqualTo constant: CGFloat,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
            fatalError("View has not been added to parent")
        }

        let constraint = topAnchor.constraint(
            lessThanOrEqualTo: parentView.layoutMarginsGuide.topAnchor,
            constant: constant
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    /// Pins the views top anchor  greaterThanOrEqualTo to its parents topAnchor
    /// - Parameters:
    ///   - constant: The amount of margin used between views
    ///   - identifier: The identifier given to the constraint.
    ///   - priority: The layout priority used for the constraint
    @discardableResult
    func pinTop(
        greaterThanOrEqualTo constant: CGFloat,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        guard let parentView = constrain()?.superview else {
            fatalError("View has not been added to parent")
        }

        let constraint = topAnchor.constraint(
            greaterThanOrEqualTo: parentView.layoutMarginsGuide.topAnchor,
            constant: constant
        )

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

    /// Pins thie views top to that of the view provided
    /// - Parameters:
    ///   - view: The view to pin the top anchor to,
    ///   - edge: Either top or bottom edge will be checked.
    ///   - constant: The amount of margin between the edges.
    ///   - identifier: The identifier used for the constraint
    ///   - priority: The priority used for the constraint.
    @discardableResult
    func pinTop(
        view: UIView,
        edge: UIRectEdge = .bottom,
        constant: CGFloat = 0,
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        constrain()

        var constraint: NSLayoutConstraint

        switch edge {
        case .top:
            constraint = topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: constant)
        case .bottom:
            constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
        default:
            fatalError("Illegal edge provided")
        }

        return constraint.activate(
            identifier: identifier,
            priority: priority
        )
    }

}

// MARK: - Extension - NSLayoutConstraint -

public extension NSLayoutConstraint {

    @discardableResult
    func activate(
        identifier: String? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {

        self.identifier = identifier
        self.priority = priority

        isActive = true
        return self
    }

}
