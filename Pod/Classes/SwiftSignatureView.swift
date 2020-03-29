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
    func swiftSignatureViewDidPanInside(_ view: SwiftSignatureView, _ pan:UIPanGestureRecognizer)
}

/// A lightweight, fast and customizable option for capturing fluid, variable-stroke-width signatures within your app.
open class SwiftSignatureView: UIView {
    // MARK: Public Properties

    open var delegate: SwiftSignatureViewDelegate?
    
    /**
    The maximum stroke width.
    */
    @IBInspectable open var maximumStrokeWidth: CGFloat = 4 {
        didSet {
            if maximumStrokeWidth < minimumStrokeWidth || maximumStrokeWidth <= 0 {
                maximumStrokeWidth = oldValue
            }
        }
    }
    
    /**
    The minimum stroke width.
    */
    @IBInspectable open var minimumStrokeWidth: CGFloat = 1 {
        didSet {
            if minimumStrokeWidth > maximumStrokeWidth || minimumStrokeWidth <= 0 {
                minimumStrokeWidth = oldValue
            }
        }
    }
    
    /**
    The stroke color.
    */
    @IBInspectable open var strokeColor: UIColor = UIColor.black
    
    /**
    The stroke alpha. Prefer higher values to prevent stroke segments from showing through.
    */
    @IBInspectable open var strokeAlpha: CGFloat = 1.0 {
        didSet {
            if strokeAlpha <= 0.0 || strokeAlpha > 1.0 {
                strokeAlpha = oldValue
            }
        }
    }

    /**
    The true backing variable used with core graphics. Private.
    */
    fileprivate var _signature: UIImage?
    /**
    The UIImage representation of the signature. Read/write.
    */
    open var signature: UIImage? {
        get {
            return _signature
        }
        set {
            _signature = newValue
            self.setNeedsDisplay()
        }
    }

    fileprivate var cachedPath: [UIBezierPath] = []
    fileprivate var cacheIndex: Int = 0
    fileprivate var currentPath = UIBezierPath()

    open var isEmpty: Bool {
        get {
            return self.currentPath.isEmpty
        }
    }
    
    // MARK: Public Methods
    open func clear() {
        self.currentPath.removeAllPoints()
        cacheIndex = 0
        cachedPath.removeAll(keepingCapacity: true)
        signature = nil
    }

    open func undo() {

      if cachedPath.isEmpty {
        return
      }

      //If undo starts from the most top item, skip it
      //and continue verifying from the second last path.
      if cachedPath.count == cacheIndex {
        cacheIndex -= 1
      }

      cacheIndex -= 1

      if cacheIndex < 0 {
        clear()
        return
      }

      currentPath = cachedPath[cacheIndex]
      _signature = nil
      self.redraw()
    }

    open func redo() {

      if cachedPath.isEmpty {
        return
      }
      
      if cacheIndex < cachedPath.count - 1 {
        cacheIndex += 1
      }

      if cachedPath.count - 1 < cacheIndex {
        return
      }

      currentPath = cachedPath[cacheIndex]
      _signature = nil
      self.redraw()
    }
    
    // MARK: Private Methods
    fileprivate var previousPoint: CGPoint = CGPoint.zero
    fileprivate var previousEndPoint: CGPoint = CGPoint.zero
    fileprivate var previousWidth: CGFloat = 0.0

    deinit {
        clear()
        delegate = nil
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)        
        initialize()
    }
    
    public func getCroppedSignature() -> UIImage? {
        guard let fullRender = signature else { return nil }
        let bounds = self.scale(currentPath.bounds.insetBy(dx: -maximumStrokeWidth/2 , dy: -maximumStrokeWidth/2), byFactor: fullRender.scale)
        guard let imageRef = fullRender.cgImage?.cropping(to: bounds) else { return nil }
        return UIImage(cgImage: imageRef)
    }

    fileprivate func initialize() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SwiftSignatureView.tap(_:)))
        self.addGestureRecognizer(tap)
        
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwiftSignatureView.pan(_:)))
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        self.addGestureRecognizer(pan)

        self.cachedPath.reserveCapacity(100)
    }
    
    @objc func tap(_ tap: UITapGestureRecognizer) {
        let rect = self.bounds
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        if _signature == nil {
            _signature = UIGraphicsGetImageFromCurrentImageContext()
        }
        _signature?.draw(in: rect)
        let currentPoint = tap.location(in: self)
        drawPointAt(currentPoint, pointSize: 5.0)
        _signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setNeedsDisplay()

        pushCurrentBelzierPath(currentPath)

        self.delegate?.swiftSignatureViewDidTapInside(self)
    }
    
    @objc func pan(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            previousPoint = pan.location(in: self)
            previousEndPoint = previousPoint
        case .changed:
            let currentPoint = pan.location(in: self)
            let strokeLength = distance(previousPoint, pt2: currentPoint)
            if strokeLength >= 1.0 {
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
            pushCurrentBelzierPath(currentPath)
            break
        }
        
        self.delegate?.swiftSignatureViewDidPanInside(self, pan)
    }
    
    fileprivate func distance(_ pt1:CGPoint, pt2:CGPoint) -> CGFloat {
        return sqrt((pt1.x - pt2.x)*(pt1.x - pt2.x) + (pt1.y - pt2.y)*(pt1.y - pt2.y))
    }
    
    fileprivate func CGPointMid(p0: CGPoint, p1: CGPoint)-> CGPoint {
        return CGPoint(x: (p0.x+p1.x)/2.0, y: (p0.y+p1.y)/2.0)
    }
    
    override open func draw(_ rect: CGRect) {
        _signature?.draw(in: rect)
    }
    
    fileprivate func getOffsetPoints(p0: CGPoint, p1: CGPoint, width: CGFloat) -> (p0: CGPoint, p1: CGPoint) {
        let pi_by_2: CGFloat = 3.14/2
        let delta: CGFloat = width/2.0
        let v0: CGFloat = p1.x - p0.x
        let v1: CGFloat = p1.y - p0.y
        let divisor: CGFloat = sqrt(v0*v0 + v1*v1)
        let u0: CGFloat = v0/divisor
        let u1: CGFloat = v1/divisor
        
        // rotate vector
        let ru0: CGFloat = cos(pi_by_2)*u0 - sin(pi_by_2)*u1
        let ru1: CGFloat = sin(pi_by_2)*u0 + cos(pi_by_2)*u1
        
        // scale the vector
        let du0: CGFloat = delta * ru0
        let du1: CGFloat = delta * ru1
        
        return (CGPoint(x: p0.x+du0, y: p0.y+du1), CGPoint(x: p0.x-du0, y: p0.y-du1))
    }
    
    fileprivate func drawQuadCurve(_ start:CGPoint, control:CGPoint, end:CGPoint, startWidth:CGFloat, endWidth:CGFloat) {
        if start != control {
            
            let controlWidth: CGFloat = (startWidth+endWidth)/2.0
            
            let startOffsets = getOffsetPoints(p0: start, p1: control, width: startWidth)
            let controlOffsets = getOffsetPoints(p0: control, p1: start, width: controlWidth)
            let endOffsets = getOffsetPoints(p0: end, p1: control, width: endWidth)
            
            currentPath.move(to: startOffsets.p0)
            currentPath.addQuadCurve(to: endOffsets.p1, controlPoint: controlOffsets.p1)
            currentPath.addLine(to: endOffsets.p0)
            currentPath.addQuadCurve(to: startOffsets.p1, controlPoint: controlOffsets.p0)
            currentPath.addLine(to: startOffsets.p1)
            
            let signatureColor = strokeColor.withAlphaComponent(strokeAlpha)
            signatureColor.setFill()
            signatureColor.setStroke()
            
            currentPath.lineWidth = 1
            currentPath.lineJoinStyle = CGLineJoin.round
            currentPath.lineCapStyle = CGLineCap.round
            currentPath.stroke()
            currentPath.fill()
        }
    }
    
    fileprivate func drawPointAt(_ point: CGPoint, pointSize: CGFloat = 1.0) {
        let signatureColor = strokeColor.withAlphaComponent(strokeAlpha)
        signatureColor.setStroke()
        currentPath.lineWidth = pointSize
        currentPath.lineCapStyle = CGLineCap.round
        currentPath.move(to: point)
        currentPath.addLine(to: point)
        currentPath.stroke()
    }

    fileprivate func redraw() {
        let rect = self.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        if _signature == nil {
              _signature = UIGraphicsGetImageFromCurrentImageContext()
        }
        _signature?.draw(in: rect)
        currentPath.stroke()
        currentPath.fill()
        _signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setNeedsDisplay()
    }
    
    fileprivate func scale(_ rect: CGRect, byFactor factor: CGFloat) -> CGRect {
        var scaledRect: CGRect = rect
        scaledRect.origin.x *= factor
        scaledRect.origin.y *= factor
        scaledRect.size.width *= factor
        scaledRect.size.height *= factor
        return scaledRect
    }

    private func pushCurrentBelzierPath(_ belzierPath: UIBezierPath) {
        if cachedPath.count == 100 {
            cachedPath.remove(at: 0)
        }

        let last: Int = (cachedPath.count - 1) - cacheIndex
        if last > 0 {
            cachedPath.removeLast(last)
        }

        cachedPath.append(belzierPath.copy() as! UIBezierPath)
        cacheIndex = cachedPath.count
    }

}
