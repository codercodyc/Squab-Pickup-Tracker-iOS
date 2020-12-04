//
//  UIView+Shadow+Radius.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/4/20.
//

import UIKit

extension UIView {
    
    func setRadius(with radius: Double) {
        layer.cornerRadius = CGFloat(radius)
    }
    
    func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = .init(width: 0, height: 3)
        layer.shadowRadius = 5
    }
}
