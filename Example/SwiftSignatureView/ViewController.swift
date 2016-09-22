//
//  ViewController.swift
//  SwiftSignatureView
//
//  Created by Alankar Misra on 07/17/2015.
//
// SwiftSignatureView is available under the MIT license. See the LICENSE file for more info.

import UIKit
import SwiftSignatureView

public class ViewController: UIViewController, SwiftSignatureViewDelegate {


    @IBOutlet weak var signatureView: SwiftSignatureView!
    // Use signatureView.signature to get at the signature image

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.signatureView.delegate = self
    }

    @IBAction func didTapClear() {
        signatureView.clear()        
    }

    //MARK: Delegate

    public func swiftSignatureViewDidTapInside(_ view: SwiftSignatureView) {
        print("Did tap inside")
    }

    public func swiftSignatureViewDidPanInside(_ view: SwiftSignatureView) {
        print("Did pan inside")
    }
}

