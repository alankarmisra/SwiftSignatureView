//
//  SwiftSignatureViewDelegate.swift
//  Pods
//
//  Created by Alankar Avinash Misra on 16/05/20.
//

import UIKit

public protocol SwiftSignatureViewDelegate: class {
    func swiftSignatureViewDidDrawGesture(_ view: ISignatureView, _ tap: UIGestureRecognizer)
}
