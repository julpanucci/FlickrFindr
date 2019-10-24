//
//  UIColor+extensions.swift
//  FlickrFindr
//
//  Created by Julian Panucci on 10/22/19.
//  Copyright © 2019 Panucci. All rights reserved.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension CGFloat {
    fileprivate static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
