//
//  ProcessingView.swift
//  Tile Animations
//
//  Created by Cody Crawmer on 11/12/22.
//

import UIKit

class ProcessingView: UIView {

    /// This text label will deisplay beneath the activity indicator spinner
    let submittingLabel = UILabel(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        layer.borderWidth = 2
//        self.layer.cornerRadius = 5
        self.backgroundColor = .clear
        self.tag = 150
        let blurEffect = UIBlurEffect(style: .regular)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        let spinner = UIActivityIndicatorView(frame: .zero)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .large
        
        
        submittingLabel.translatesAutoresizingMaskIntoConstraints = false
        submittingLabel.textAlignment = .center
        
        insertSubview(blurView, at: 0)
        addSubview(spinner)
        addSubview(submittingLabel)
        
        let spinnerDim: CGFloat = 100
        
        let constraints = [
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: spinnerDim),
            spinner.widthAnchor.constraint(equalToConstant: spinnerDim),
            
            submittingLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor),
            submittingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            submittingLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            submittingLabel.heightAnchor.constraint(equalToConstant: 100),
            
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        spinner.startAnimating()
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
