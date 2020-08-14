//
//  SwiftSignatureView.swift
//  SwiftSignatureView
//
//  Created by Alankar Misra on 6/23/15.
//
//  SwiftSignatureView is available under the MIT license. See the LICENSE file for more info.

import UIKit
import PencilKit

public protocol ISignatureView: class {
    var delegate: SwiftSignatureViewDelegate? { get set }
    var maximumStrokeWidth: CGFloat { get set }
    var minimumStrokeWidth: CGFloat { get set }
    var strokeColor: UIColor { get set }
    var strokeAlpha: CGFloat { get set }
    var signature: UIImage? { get set }
    var isEmpty: Bool { get }

    func clear(cache: Bool)
    func undo()
    func redo()
    func getCroppedSignature() -> UIImage?
}

extension ISignatureView {
  func clear(cache: Bool = false) {
    self.clear(cache: cache)
  }
}

/// A lightweight, fast and customizable option for capturing fluid, variable-stroke-width signatures within your app.
open class SwiftSignatureView: UIView, ISignatureView {

    public weak var delegate: SwiftSignatureViewDelegate?

    /**
    The minimum stroke width.
     WARNING: This property is ignored in iOS13+.
    */
    @IBInspectable public var minimumStrokeWidth: CGFloat {
        get {
            instance.minimumStrokeWidth
        }

        set {
            instance.minimumStrokeWidth = newValue
        }
    }

    /**
    The maximum stroke width.
    */
    @IBInspectable public var maximumStrokeWidth: CGFloat {
        get {
            instance.maximumStrokeWidth
        }

        set {
            instance.maximumStrokeWidth = newValue
        }
    }

    /**
    The stroke color.
    */
    @IBInspectable public var strokeColor: UIColor {
        get {
            instance.strokeColor
        }

        set {
            instance.strokeColor = newValue
        }
    }

    /**
    The stroke alpha. Prefer higher values to prevent stroke segments from showing through.
    */
    @IBInspectable public var strokeAlpha: CGFloat {
        get {
            instance.strokeAlpha
        }

        set {
            instance.strokeAlpha = newValue
        }
    }

    /**
    The UIImage representation of the signature. Read/write.
    */
    @IBInspectable public var signature: UIImage? {
        get {
            instance.signature
        }

        set {
            instance.signature  = newValue
        }
    }

    open var isEmpty: Bool {
        get {
            instance.isEmpty
        }
    }

    /**
    Clear the signature.
    */
    public func clear(cache: Bool = false) {
        instance.clear(cache: cache)
    }

    public func undo() {
        instance.undo()
    }

    public func redo() {
        instance.redo()
    }

    /**
    Get a cropped version of the signature.
     WARNING: This does not work with iOS13+
    */
    public func getCroppedSignature() -> UIImage? {
        instance.getCroppedSignature()
    }

    private lazy var instance: ISignatureView = {
        if #available(iOS 13.0, *) {
            return PencilKitSignatureView(frame: bounds)
        }
        return LegacySwiftSignatureView(frame: bounds)
    }()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSignatureView()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        createSignatureView()
    }

    override open func layoutIfNeeded() {
        super.layoutIfNeeded()
        resizeSubview()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        resizeSubview()
    }

    private func createSignatureView() {
        guard let subview: UIView = instance as? UIView else {
            return
        }
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        self.addSubview(subview)
    }

    private func resizeSubview() {
        (instance as? UIView)?.frame = self.frame
    }

  

}
