//
//  SwiftSignatureView.swift
//  SwiftSignatureView
//
//  Created by Alankar Misra on 6/23/15.
//
//  SwiftSignatureView is available under the MIT license. See the LICENSE file for more info.

import UIKit
import PencilKit

public protocol ISignatureView : class {
    var delegate: SwiftSignatureViewDelegate? { get set }
    var maximumStrokeWidth:CGFloat { get set }
    var minimumStrokeWidth:CGFloat { get set }
    var strokeColor:UIColor { get set }
    var strokeAlpha:CGFloat { get set }
    var signature:UIImage? { get set }
    
    func clear()
    func getCroppedSignature() -> UIImage?
}

/// A lightweight, fast and customizable option for capturing fluid, variable-stroke-width signatures within your app.
open class SwiftSignatureView : UIView, ISignatureView {
    public var delegate: SwiftSignatureViewDelegate?
    
    /**
    The minimum stroke width.
     WARNING: This property is ignored in iOS13+.
    */
    @IBInspectable public var minimumStrokeWidth: CGFloat {
        get {
            return instance.minimumStrokeWidth;
        }
        
        set {
            instance.minimumStrokeWidth = newValue;
        }
    }
    
    /**
    The maximum stroke width.
    */
    @IBInspectable public var maximumStrokeWidth: CGFloat {
        get {
            return instance.maximumStrokeWidth;
        }
        
        set {
            instance.maximumStrokeWidth = newValue;
        }
    }
    
    /**
    The stroke color.
    */
    @IBInspectable public var strokeColor: UIColor {
        get {
            return instance.strokeColor;
        }
        
        set {
            instance.strokeColor = newValue;
        }
    }
    
    /**
    The stroke alpha. Prefer higher values to prevent stroke segments from showing through.
    */
    @IBInspectable public var strokeAlpha: CGFloat {
        get {
            return instance.strokeAlpha;
        }
        
        set {
            instance.strokeAlpha = newValue;
        }
    }
    
    /**
    The UIImage representation of the signature. Read/write.
    */
    @IBInspectable public var signature: UIImage? {
        get {
            return instance.signature;
        }
        
        set {
            instance.signature  = newValue;
        }
    }

    /**
    Clear the signature.
    */
    public func clear() {
        instance.clear();
    }
    
    /**
    Get a cropped version of the signature.
     WARNING: This does not work with iOS13+
    */
    public func getCroppedSignature() -> UIImage? {
        return instance.getCroppedSignature();
    }
    
    private var instance:ISignatureView!;
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        createSignatureView();
     }
    
     override public init(frame: CGRect) {
        super.init(frame: frame)
        createSignatureView();
     }
    
    private func createSignatureView() {
        if #available(iOS 13.0, *) {
            instance = PencilKitSignatureView(frame:bounds);
        } else {
            instance = LegacySwiftSignatureView(frame:bounds);
        }
        
        let subview = instance as! UIView;
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight,.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        self.addSubview(subview);
        
        
        
    }
}
