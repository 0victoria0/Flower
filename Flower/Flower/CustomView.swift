//
//  UIView+Extension.swift
//  Flower
//
//  Created by victoria on 16/7/15.
//  Copyright © 2016年 victoria. All rights reserved.
//

import UIKit
@IBDesignable

class CustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}