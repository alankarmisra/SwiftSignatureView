//
//  SwiftSignatureView.swift
//  SwiftSignatureView
//
//  Created by Alankar Misra on 6/23/15.
//
//  SwiftSignatureView is available under the MIT license. See the LICENSE file for more info.

import UIKit

public protocol SwiftSignatureViewDelegate: class {

    func swiftSignatureViewDidTapInside(_ view: SwiftSignatureView)

    func swiftSignatureViewDidPanInside(_ view: SwiftSignatureView)

}

/// A lightweight, fast and customizable option for capturing fluid, variable-stroke-width signatures within your app.
open class SwiftSignatureView: UIView {
    // MARK: Public Properties

    open weak var delegate: SwiftSignatureViewDelegate?
    
    /**
    The maximum stroke width.
    */
    @IBInspectable open var maximumStrokeWidth:CGFloat = 4 {
        didSet {
            if(maximumStrokeWidth < minimumStrokeWidth || maximumStrokeWidth <= 0) {
                maximumStrokeWidth = oldValue
            }
        }
    }
    
    /**
    The minimum stroke width.
    */
    @IBInspectable open var minimumStrokeWidth:CGFloat = 1 {
        didSet {
            if(minimumStrokeWidth > maximumStrokeWidth || minimumStrokeWidth <= 0) {
                minimumStrokeWidth = oldValue
            }
        }
    }
    
    /**
    The stroke color.
    */
    @IBInspectable open var strokeColor:UIColor = UIColor.black
    
    /**
    The stroke alpha. Prefer higher values to prevent stroke segments from showing through.
    */
    @IBInspectable open var strokeAlpha:CGFloat = 1.0 {
        didSet {
            if(strokeAlpha <= 0.0 || strokeAlpha > 1.0) {
                strokeAlpha = oldValue
            }
        }
    }

    /**
    The true backing variable used with core graphics. Private.
    */
    fileprivate var _signature:UIImage?
    /**
    The UIImage representation of the signature. Read/write.
    */
    open var signature:UIImage? {
        get {
            return _signature
        }
        set {
            _signature = newValue
            self.setNeedsDisplay()
        }
    }
    
    // MARK: Public Methods
    open func clear() {
        signature = nil
    }
    
    // MARK: Private Methods
    fileprivate var previousPoint = CGPoint.zero
    fileprivate var previousEndPoint = CGPoint.zero
    fileprivate var previousWidth:CGFloat = 0.0
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)        
        initialize()
    }

    fileprivate func initialize() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SwiftSignatureView.tap(_:)))
        self.addGestureRecognizer(tap)
        
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwiftSignatureView.pan(_:)))
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        self.addGestureRecognizer(pan)
    }
    
    @objc func tap(_ tap:UITapGestureRecognizer) {
        let rect = self.bounds
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        if(_signature == nil) {
            _signature = UIGraphicsGetImageFromCurrentImageContext()
        }
        _signature?.draw(in: rect)
        let currentPoint = tap.location(in: self)
        drawPointAt(currentPoint, pointSize: 5.0)
        _signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setNeedsDisplay()

        self.delegate?.swiftSignatureViewDidTapInside(self)
    }
    
    @objc func pan(_ pan:UIPanGestureRecognizer) {
        switch(pan.state) {
        case .began:
            previousPoint = pan.location(in: self)
            previousEndPoint = previousPoint
        case .changed:
            let currentPoint = pan.location(in: self)
            let strokeLength = distance(previousPoint, pt2: currentPoint)
            if(strokeLength >= 1.0) {
                let rect = self.bounds
                UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
                if(_signature == nil) {
                    _signature = UIGraphicsGetImageFromCurrentImageContext()
                }
                // Draw the prior signature
                _signature?.draw(in: rect)
                
                let delta:CGFloat = 0.5
                let strokeScale:CGFloat = 50 // fudge factor based on empirical tests
                let currentWidth = max(minimumStrokeWidth,min(maximumStrokeWidth, 1/strokeLength*strokeScale*delta + previousWidth*(1-delta)))
                let midPoint = CGPointMid(p0:currentPoint, p1:previousPoint)
                
                drawQuadCurve(previousEndPoint, control: previousPoint, end: midPoint, startWidth:previousWidth, endWidth: currentWidth)
                
                _signature = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                previousPoint = currentPoint
                previousEndPoint = midPoint
                previousWidth = currentWidth
                self.setNeedsDisplay()
            }
            
        default:
            break
        }
        self.delegate?.swiftSignatureViewDidPanInside(self)
    }
    
    fileprivate func distance(_ pt1:CGPoint, pt2:CGPoint) -> CGFloat {
        return sqrt((pt1.x - pt2.x)*(pt1.x - pt2.x) + (pt1.y - pt2.y)*(pt1.y - pt2.y))
    }
    
    fileprivate func CGPointMid(p0:CGPoint, p1:CGPoint)->CGPoint {
        return CGPoint(x: (p0.x+p1.x)/2.0, y: (p0.y+p1.y)/2.0)
    }
    
    override open func draw(_ rect: CGRect) {
        _signature?.draw(in: rect)
    }
    
    fileprivate func getOffsetPoints(p0:CGPoint, p1:CGPoint, width:CGFloat) -> (p0:CGPoint, p1:CGPoint) {
        let pi_by_2:CGFloat = 3.14/2
        let delta = width/2.0
        let v0 = p1.x - p0.x
        let v1 = p1.y - p0.y
        let divisor = sqrt(v0*v0 + v1*v1)
        let u0 = v0/divisor
        let u1 = v1/divisor
        
        // rotate vector
        let ru0 = cos(pi_by_2)*u0 - sin(pi_by_2)*u1
        let ru1 = sin(pi_by_2)*u0 + cos(pi_by_2)*u1
        
        // scale the vector
        let du0 = delta * ru0
        let du1 = delta * ru1
        
        return (CGPoint(x: p0.x+du0, y: p0.y+du1),CGPoint(x: p0.x-du0, y: p0.y-du1))
    }
    
    fileprivate func drawQuadCurve(_ start:CGPoint, control:CGPoint, end:CGPoint, startWidth:CGFloat, endWidth:CGFloat) {
        if(start != control) {
            let path = UIBezierPath()
            let controlWidth = (startWidth+endWidth)/2.0
            
            let startOffsets = getOffsetPoints(p0: start, p1: control, width: startWidth)
            let controlOffsets = getOffsetPoints(p0: control, p1: start, width: controlWidth)
            let endOffsets = getOffsetPoints(p0: end, p1: control, width: endWidth)
            
            path.move(to: startOffsets.p0)
            path.addQuadCurve(to: endOffsets.p1, controlPoint: controlOffsets.p1)
            path.addLine(to: endOffsets.p0)
            path.addQuadCurve(to: startOffsets.p1, controlPoint: controlOffsets.p0)
            path.addLine(to: startOffsets.p1)
            
            let signatureColor = strokeColor.withAlphaComponent(strokeAlpha)
            signatureColor.setFill()
            signatureColor.setStroke()
            
            path.lineWidth = 1
            path.lineJoinStyle = CGLineJoin.round
            path.lineCapStyle = CGLineCap.round
            path.stroke()
            path.fill()
        }
    }
    
    fileprivate func drawPointAt(_ point:CGPoint, pointSize:CGFloat = 1.0) {
        let path = UIBezierPath()
        let signatureColor = strokeColor.withAlphaComponent(strokeAlpha)
        signatureColor.setStroke()
        
        path.lineWidth = pointSize
        path.lineCapStyle = CGLineCap.round
        path.move(to: point)
        path.addLine(to: point)
        path.stroke()
    }
}
