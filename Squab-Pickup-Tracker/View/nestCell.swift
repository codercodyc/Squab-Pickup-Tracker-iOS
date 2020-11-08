//
//  CollectionViewCell.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import UIKit

class nestCell: UICollectionViewCell {
    
    @IBOutlet weak var penLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    func updatePenLabel(_ pen: String) {
        penLabel.text = pen
    }
    
    func updateContentsLabel(_ contents: String) {
        statusLabel.text = contents
    }
    
}
