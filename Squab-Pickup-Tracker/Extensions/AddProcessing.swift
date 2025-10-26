//
//  AddProcessing.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/13/22.
//

import UIKit

/// Will add a subview that blurs the background, and shows a processing spinner.
func addProcessingView(to view: UIView, label: String) {
    
    // Add processing view.
    let processingView = ProcessingView(frame: .zero)
    processingView.submittingLabel.text = label
    processingView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(processingView)
    
    let constraints = [
        processingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        processingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        processingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        processingView.topAnchor.constraint(equalTo: view.topAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
}
