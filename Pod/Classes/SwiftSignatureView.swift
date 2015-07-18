//
//  SwiftSignatureView.swift
//  SwiftSignatureView
//
//  Created by Alankar Misra on 6/23/15.
//  Copyright (c) 2015 Digital Sutras. All rights reserved.
//

import UIKit

public class SwiftSignatureView: UIView {
    
    @IBInspectable public var maximumStrokeWidth:CGFloat = 4 {
        didSet {
            if(maximumStrokeWidth < minimumStrokeWidth || maximumStrokeWidth <= 0) {
                maximumStrokeWidth = oldValue
            }
        }
    }
    
    @IBInspectable public var minimumStrokeWidth:CGFloat = 1 {
        didSet {
            if(minimumStrokeWidth > maximumStrokeWidth || minimumStrokeWidth <= 0) {
                minimumStrokeWidth = oldValue
            }
        }
    }
    
    @IBInspectable public var strokeColor:UIColor = UIColor.blackColor()
    
    @IBInspectable public var strokeAlpha:CGFloat = 1.0 {
        didSet {
            if(strokeAlpha <= 0.0 || strokeAlpha > 1.0) {
                strokeAlpha = oldValue
            }
        }
    }
    
    public var signature:UIImage?
    
    private struct CGPointPair {
        var p0:CGPoint
        var p1:CGPoint
    }
    
    private var previousPoint:CGPoint = CGPointZero
    private var previousEndPoint:CGPoint = CGPointZero
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
    
    public func clear() {
        var rect = self.frame
        UIGraphicsBeginImageContext(rect.size)
        signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setNeedsDisplay()
    }
    
    func tap(tap:UITapGestureRecognizer) {
        var rect = self.frame
        
        UIGraphicsBeginImageContext(rect.size)
        var context = UIGraphicsGetCurrentContext()
        if(signature == nil) {
            signature = UIGraphicsGetImageFromCurrentImageContext()
        }
        signature?.drawInRect(rect)
        var currentPoint = tap.locationInView(self)
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
                var rect = self.frame
                UIGraphicsBeginImageContext(rect.size)
                var context = UIGraphicsGetCurrentContext()
                if(signature == nil) {
                    signature = UIGraphicsGetImageFromCurrentImageContext()
                }
                // Draw the prior signature
                signature?.drawInRect(rect)
                
                
                var currentVelocity = pan.velocityInView(self)
                var delta:CGFloat = 0.5
                let strokeScale:CGFloat = 50
                var currentWidth = max(minimumStrokeWidth,min(maximumStrokeWidth, 1/strokeLength*strokeScale*delta + previousWidth*(1-delta)))
                var midPoint = CGPointMid(p0:currentPoint, p1:previousPoint)
                
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
    
    func distance(pt1:CGPoint, pt2:CGPoint) -> CGFloat {
        return sqrt((pt1.x - pt2.x)*(pt1.x - pt2.x) + (pt1.y - pt2.y)*(pt1.y - pt2.y))
    }
    
    func linearVelocity(velocity:CGPoint)->CGFloat {
        return sqrt(velocity.x * velocity.x + velocity.y * velocity.y)
    }
    
    
    func CGPointMid(#p0:CGPoint, p1:CGPoint)->CGPoint {
        return CGPointMake((p0.x+p1.x)/2.0, (p0.y+p1.y)/2.0)
    }
    
    override public func drawRect(rect: CGRect) {
        signature?.drawInRect(rect)
    }
    
    private func getOffsetPoints(#p0:CGPoint, p1:CGPoint, width:CGFloat) -> CGPointPair {
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
        
        // return the end points of the perpendicular with length delta
        let pair = CGPointPair(
            p0: CGPoint(x: p0.x+du0, y: p0.y+du1),
            p1: CGPoint(x: p0.x-du0, y: p0.y-du1)
        )
        
        return pair
    }
    
    private func drawQuadCurve(start:CGPoint, control:CGPoint, end:CGPoint, startWidth:CGFloat, endWidth:CGFloat) {
        if(start != control) {
            var path = UIBezierPath()
            var context = UIGraphicsGetCurrentContext()
            var controlWidth = (startWidth+endWidth)/2.0
            
            let startOffsets:CGPointPair = getOffsetPoints(p0: start, p1: control, width: startWidth)
            let controlOffsets:CGPointPair = getOffsetPoints(p0: control, p1: start, width: controlWidth)
            let endOffsets:CGPointPair = getOffsetPoints(p0: end, p1: control, width: endWidth)
            
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
        path.lineWidth = pointSize
        path.lineCapStyle = kCGLineCapRound
        path.moveToPoint(point)
        path.addLineToPoint(point)
        path.stroke()
    }
}
