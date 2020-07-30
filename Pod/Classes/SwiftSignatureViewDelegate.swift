//
//  SwiftSignatureViewDelegate.swift
//  Pods
//
//  Created by Alankar Avinash Misra on 16/05/20.
//

import UIKit

public protocol SwiftSignatureViewDelegate: class {
    func swiftSignatureViewDidTapInside(_ view: ISignatureView)
    func swiftSignatureViewDidPanInside(_ view: ISignatureView, _ pan:UIPanGestureRecognizer)
}
