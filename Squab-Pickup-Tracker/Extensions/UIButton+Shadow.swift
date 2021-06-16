//
//  UIButton+Shadow.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/4/20.
//

import UIKit

extension UIButton {
    
    // Function to format buttons
    /// - Sets mainButton Background Color with White Text
    /// - Round Corners and Drop Shadow
    func makeMainButton(fontSize: CGFloat) {
       
        //Background and title colors
        backgroundColor = UIColor(named: K.color.mainButton)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: "Trebuchet MS", size: fontSize)
        
       
        
        
        //Corner Radius and shadow
        layer.cornerRadius = frame.height / 2
        
        shadowOn()
       
    }
    
    func shadowOn() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .init(width: 0, height: 2)
        layer.shadowRadius = 5
    }
    
    func shadowOff() {
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
    }
    
    
}

