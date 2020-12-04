//
//  MoveCullTableViewCell.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/3/20.
//

import UIKit

class MoveCullTableViewCell: UITableViewCell {

    @IBOutlet weak var penNest: UILabel!
    @IBOutlet weak var pairId: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var transferType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        


    }

}
