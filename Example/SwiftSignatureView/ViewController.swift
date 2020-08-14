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
    // Use signatureView.signature to get at the signature image
    @IBOutlet weak var signatureView: SwiftSignatureView!

    @IBOutlet weak var croppedSignatureView: UIImageView!

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapClear() {
        signatureView.clear()
    }

    @IBAction func didTapRedo(_ sender: Any) {
        signatureView.redo()
    }

    @IBAction func didTapUndo(_ sender: Any) {
        signatureView.undo()
    }

    @IBAction func didTapRefreshCroppedSignature() {
        croppedSignatureView.image = signatureView.getCroppedSignature()
    }
}
