//
//  UITextfield+extensions.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/23/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

extension UITextField {
    func addLeftPadding(padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
