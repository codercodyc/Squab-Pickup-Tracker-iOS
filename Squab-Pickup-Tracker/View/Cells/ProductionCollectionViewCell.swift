//
//  ProductionCollectionViewCell.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/4/20.
//

import UIKit
import Charts

class ProductionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var sixMonthButton: UIButton!
    @IBOutlet weak var penNestLabel: UILabel!
    @IBOutlet weak var productionTotalLabel: UILabel!
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var pairId: UILabel!
    
    
}
