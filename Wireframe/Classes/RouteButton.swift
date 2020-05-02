//
//  RouteButton.swift
//  JSONWireframe
//
//  Created by Thorn, David on 29.04.20.
//  Copyright © 2020 David Thorn. All rights reserved.
//

import UIKit

// MARK: - Protocol -

/// A delegate that informs callers of the button to be informed when the button was tapped.
public protocol RouteButtonDelegate: AnyObject {


    /// Method called when the onTouchInside selector is called within the button.
    /// - Parameter tag: The tag of the button.
    func buttonTapped(tag: Int) throws

    func handleError(error: WireframeError)

}

// MARK: - Implementation -

/// A route button will be used to indicate to the user that this view can navigation to a subroute.
public final class RouteButton: UIControl {

     // MARK: - Public Properties -

    public var title: String? {
        get { label.text }
        set { label.text = newValue }
    }
    public weak var delegate: RouteButtonDelegate?

    // MARK: - Private UI Properties -

    private(set) var label = UILabel()

    // MARK: - Constructors -

    public init( ) {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Common Init & Setup -

    public func commonInit() {
        addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )

        addSubview(label)
        label.edgesToSuperview()
        label.textAlignment = .center
        label.text = title
        height(constant: 50)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .systemBlue
        label.textColor = .white
        layer.cornerRadius = 20
    }

    // MARK: - OnTouchInside Handler -

    @objc func buttonTapped() {
        do {
            try delegate?.buttonTapped(tag: tag)
        } catch let error {
            if delegate.isNil {
                fatalError("Why is the delegate nil")
            }

            delegate?.handleError(error: error as! WireframeError)
        }

    }

}
