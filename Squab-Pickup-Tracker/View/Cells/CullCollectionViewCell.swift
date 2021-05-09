//
//  CullCollectionViewCell.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/4/20.
//

import UIKit
import Charts

class CullCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var penNestLabel: UILabel!
    @IBOutlet weak var sixMonthButton: UIButton!
    @IBOutlet weak var twelveMonthButton: UIButton!
    @IBOutlet weak var totalProductionLabel: UILabel!
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var pairIdLabel: UILabel!
    
    
    @IBAction func monthPressed(_ sender: UIButton) {
        deselectMonths()
        sender.isSelected = true
    }
    
    func deselectMonths() {
        sixMonthButton.isSelected = false
        twelveMonthButton.isSelected = false
    }
}
