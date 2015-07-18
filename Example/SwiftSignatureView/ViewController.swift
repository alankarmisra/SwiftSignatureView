//
//  ViewController.swift
//  SwiftSignatureView
//
//  Created by Alankar Misra on 07/17/2015.
//
// SwiftSignatureView is available under the MIT license. See the LICENSE file for more info.

import UIKit
import SwiftSignatureView

public class ViewController: UIViewController {

    
    @IBOutlet weak var signatureView: SwiftSignatureView!
    // Use signatureView.signature to get at the signature image
    
    
    @IBAction func didTapClear(sender: AnyObject) {
        signatureView.clear()
    }

}

