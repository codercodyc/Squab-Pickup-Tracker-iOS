//
//  ProductionByPairTableViewCell.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/3/20.
//

import UIKit
import Charts

class ProductionByPairTableViewCell: UITableViewCell {

    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var penNestLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
