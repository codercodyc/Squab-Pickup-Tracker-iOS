//
//  ContentsCell.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import UIKit

class ContentsCell: UICollectionViewCell {
    @IBOutlet weak var contentsLabel: UILabel!
    
    func updateContentsLabel(_ contents: String) {
        contentsLabel.text = contents
    }
    
}
