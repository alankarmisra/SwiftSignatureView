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

    private var viewReady: Bool = false

    private lazy var signatureView: SwiftSignatureView = {
        SwiftSignatureView(frame: CGRect.zero)
    }()

    override func loadView() {
        super.loadView()
        signatureView.backgroundColor = UIColor.red
        signatureView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signatureView)
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        self.signatureView.layer.borderWidth = 1.0
        self.signatureView.layer.borderColor = UIColor.black.cgColor
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        if viewReady {
            return
        }
        viewReady = true
        view.addConstraint(NSLayoutConstraint(item: signatureView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 16.0))
        view.addConstraint(NSLayoutConstraint(item: signatureView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 16.0))
        view.addConstraint(NSLayoutConstraint(item: signatureView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -16.0))
        view.addConstraint(NSLayoutConstraint(item: signatureView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
    }

}
