//
//  PageSheetViewController.swift
//  SwiftSignatureView_Example
//
//  Created by Pedro Paulo de Amorim on 14/08/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftSignatureView

final class PageSheetViewController: UIViewController {

    private lazy var signatureView: SwiftSignatureView = {
        SwiftSignatureView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width, height: 200.0)))
    }()

    override func loadView() {
        super.loadView()
        signatureView.backgroundColor = UIColor.gray
        signatureView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signatureView)
    }

}
