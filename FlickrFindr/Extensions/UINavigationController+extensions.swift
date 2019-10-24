//
//  UINavigationController+extensions.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/24/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit


extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
