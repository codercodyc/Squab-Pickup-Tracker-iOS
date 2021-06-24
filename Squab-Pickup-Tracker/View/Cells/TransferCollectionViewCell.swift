//
//  TransferCollectionViewCell.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 6/22/21.
//

import UIKit

class TransferCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var transferTypeImage: UIImageView!
    @IBOutlet weak var transferTypeLabel: UILabel!
    @IBOutlet weak var pairIdLabel: UILabel!
    @IBOutlet weak var transferDateLabel: UILabel!
    @IBOutlet weak var penNestLabel: UILabel!
    @IBOutlet weak var inOutImage: UIImageView!
    @IBOutlet weak var inOutLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        view.layer.cornerRadius = 15
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.15
        
        layer.masksToBounds = false
        
        
    }

}
