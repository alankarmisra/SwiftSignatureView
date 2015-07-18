//
//  ViewController.swift
//  SwiftSignatureView
//
//  Created by Alankar Misra on 07/17/2015.
//  Copyright (c) 2015 Alankar Misra. All rights reserved.
//

import UIKit
import SwiftSignatureView

public class ViewController: UIViewController {

    @IBOutlet weak var signatureView: SwiftSignatureView!
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapClear(sender: AnyObject) {
        signatureView.clear()
    }

}

