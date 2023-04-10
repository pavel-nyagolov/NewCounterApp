//
//  CircleButton.swift
//  NewCounterApp
//
//  Created by Pavel on 10.04.23.
//

import UIKit

@IBDesignable
class CircleButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            if cornerRadius == 0 {
                self.layer.cornerRadius = layer.frame.height / 2
            } else {
                self.layer.cornerRadius = cornerRadius
            }
        }
    }
}
