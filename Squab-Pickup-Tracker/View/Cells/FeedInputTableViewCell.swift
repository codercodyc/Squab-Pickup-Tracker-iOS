//
//  FeedInputTableViewCell.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/26/22.
//

import UIKit

class FeedInputTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var penLabel: UILabel!
    
    @IBOutlet weak var feedStackView: UIStackView!
    
}
