//
//  SwiftSignatureView.swift
//  SwiftSignatureView
//
//  Created by Alankar Misra on 6/23/15.
//
//  SwiftSignatureView is available under the MIT license. See the LICENSE file for more info.

import UIKit

/// A lightweight, fast and customizable option for capturing fluid, variable-stroke-width signatures within your app.
public class SwiftSignatureView: UIView {
    // MARK: Public Properties
    
    /**
    The maximum stroke width.
    */
    @IBInspectable public var maximumStrokeWidth:CGFloat = 4 {
        didSet {
            if(maximumStrokeWidth < minimumStrokeWidth || maximumStrokeWidth <= 0) {
                maximumStrokeWidth = oldValue
            }
        }
    }

    /**
    The minimum stroke width.
    */
    @IBInspectable public var minimumStrokeWidth:CGFloat = 1 {
        didSet {
            if(minimumStrokeWidth > maximumStrokeWidth || minimumStrokeWidth <= 0) {
                minimumStrokeWidth = oldValue
            }
        }
    }
    
    /**
    The stroke color.
    */
    @IBInspectable public var strokeColor:UIColor = UIColor.blackColor()
    
    /**
    The stroke alpha. Prefer higher values to prevent stroke segments from showing through.
    */
    @IBInspectable public var strokeAlpha:CGFloat = 1.0 {
        didSet {
            if(strokeAlpha <= 0.0 || strokeAlpha > 1.0) {
                strokeAlpha = oldValue
            }
        }
    }
    
    /**
    The UIImage representation of the signature. Read only.
    */
    private(set) public var signature:UIImage?
    
    // MARK: Public Methods
    public func clear() {
        let rect = self.frame
        UIGraphicsBeginImageContext(rect.size)
        signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setNeedsDisplay()
    }    
    
    // MARK: Private Methods
    private var previousPoint = CGPointZero
    private var previousEndPoint = CGPointZero
    private var previousWidth:CGFloat = 0.0
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        self.addGestureRecognizer(tap)
        
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        self.addGestureRecognizer(pan)
    }
    
    func tap(tap:UITapGestureRecognizer) {
        let rect = self.frame
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        if(signature == nil) {
            signature = UIGraphicsGetImageFromCurrentImageContext()
        }
        signature?.drawInRect(rect)
        let currentPoint = tap.locationInView(self)
        drawPointAt(currentPoint, pointSize: 5.0)
        signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setNeedsDisplay()
    }
    
    func pan(pan:UIPanGestureRecognizer) {
        switch(pan.state) {
        case .Began:
            previousPoint = pan.locationInView(self)
            previousEndPoint = previousPoint
        case .Changed:
            var currentPoint = pan.locationInView(self)
            var strokeLength = distance(previousPoint, pt2: currentPoint)
            if(strokeLength >= 1.0) {
                let rect = self.frame
                UIGraphicsBeginImageContext(rect.size)
                let context = UIGraphicsGetCurrentContext()
                if(signature == nil) {
                    signature = UIGraphicsGetImageFromCurrentImageContext()
                }
                // Draw the prior signature
                signature?.drawInRect(rect)
                
                
                let currentVelocity = pan.velocityInView(self)
                let delta:CGFloat = 0.5
                let strokeScale:CGFloat = 50 // fudge factor based on empirical tests
                let currentWidth = max(minimumStrokeWidth,min(maximumStrokeWidth, 1/strokeLength*strokeScale*delta + previousWidth*(1-delta)))
                let midPoint = CGPointMid(p0:currentPoint, p1:previousPoint)
                
                drawQuadCurve(previousEndPoint, control: previousPoint, end: midPoint, startWidth:previousWidth, endWidth: currentWidth)
                
                signature = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                previousPoint = currentPoint
                previousEndPoint = midPoint
                previousWidth = currentWidth
                self.setNeedsDisplay()
            }
            
        default:
            break
        }
    }
    
    private func distance(pt1:CGPoint, pt2:CGPoint) -> CGFloat {
        return sqrt((pt1.x - pt2.x)*(pt1.x - pt2.x) + (pt1.y - pt2.y)*(pt1.y - pt2.y))
    }
    
    private func CGPointMid(#p0:CGPoint, p1:CGPoint)->CGPoint {
        return CGPointMake((p0.x+p1.x)/2.0, (p0.y+p1.y)/2.0)
    }
    
    override public func drawRect(rect: CGRect) {
        signature?.drawInRect(rect)
    }
    
    private func getOffsetPoints(#p0:CGPoint, p1:CGPoint, width:CGFloat) -> (p0:CGPoint, p1:CGPoint) {
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
    
    private func drawQuadCurve(start:CGPoint, control:CGPoint, end:CGPoint, startWidth:CGFloat, endWidth:CGFloat) {
        if(start != control) {
            var path = UIBezierPath()
            let context = UIGraphicsGetCurrentContext()
            let controlWidth = (startWidth+endWidth)/2.0
            
            let startOffsets = getOffsetPoints(p0: start, p1: control, width: startWidth)
            let controlOffsets = getOffsetPoints(p0: control, p1: start, width: controlWidth)
            let endOffsets = getOffsetPoints(p0: end, p1: control, width: endWidth)
            
            path.moveToPoint(startOffsets.p0)
            path.addQuadCurveToPoint(endOffsets.p1, controlPoint: controlOffsets.p1)
            path.addLineToPoint(endOffsets.p0)
            path.addQuadCurveToPoint(startOffsets.p1, controlPoint: controlOffsets.p0)
            path.addLineToPoint(startOffsets.p1)
            
            let signatureColor = strokeColor.colorWithAlphaComponent(strokeAlpha)
            signatureColor.setFill()
            signatureColor.setStroke()
            
            path.lineWidth = 1
            path.lineJoinStyle = kCGLineJoinRound
            path.lineCapStyle = kCGLineCapRound
            path.stroke()
            path.fill()
        }
    }
    
    private func drawPointAt(point:CGPoint, pointSize:CGFloat = 1.0) {
        let path = UIBezierPath()
        let signatureColor = strokeColor.colorWithAlphaComponent(strokeAlpha)
        signatureColor.setStroke()
        
        path.lineWidth = pointSize
        path.lineCapStyle = kCGLineCapRound
        path.moveToPoint(point)
        path.addLineToPoint(point)
        path.stroke()
    }
}
