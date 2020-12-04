//
//  MoveCullTableViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/3/20.
//

import UIKit
import Charts

class MoveCullTableViewController: UITableViewController {
    
//    //Temporary Chart Data
//    let pairData: [Double] = [3,0,2,2,2,0,2,0,1,2,3,0,0,0]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: K.ProductionCellNibName, bundle: nil), forCellReuseIdentifier: K.ProductionByWeekCellIdentifier)

        
    }
    
    func updateGraph() {
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if let safeCell = tableView.dequeueReusableCell(withIdentifier: K.ProductionByWeekCellIdentifier, for: indexPath) as? ProductionByPairTableViewCell {
            safeCell.penNestLabel.text = "40\(indexPath.row)-\(indexPath.row + 1)A"
            var randomData: [Double] = []
            for i in 0...11 {
                let number = Double(Int.random(in: 0...4))
                randomData.append(number)
            }
            
            var lineChartEntry = [ChartDataEntry]()
            
            for i in 0..<randomData.count {
                let value = ChartDataEntry(x: Double(i), y: randomData[i])
                lineChartEntry.append(value)
            }
            
            let line1 = LineChartDataSet(entries: lineChartEntry)
            line1.colors = [NSUIColor.blue]
            line1.drawFilledEnabled = true
//            line1.drawCircleHoleEnabled = false
            line1.circleRadius = 5
            line1.drawValuesEnabled = false
            
            let data = LineChartData(dataSet: line1)
            safeCell.chart.data = data
            
            safeCell.chart.isUserInteractionEnabled = false
            
            safeCell.chart.legend.enabled = false
//            safeCell.chart.leftAxis.drawLabelsEnabled = false
//            safeCell.chart.leftAxis.drawZeroLineEnabled = true
            safeCell.chart.leftAxis.granularity = 1
            safeCell.chart.rightAxis.granularity = 1
            safeCell.chart.leftAxis.axisMinimum = 0
            safeCell.chart.rightAxis.axisMinimum = 0
            safeCell.chart.rightAxis.drawLabelsEnabled = false
            safeCell.chart.rightAxis.drawGridLinesEnabled = false
            safeCell.chart.rightAxis.drawAxisLineEnabled = false
            safeCell.chart.xAxis.drawLabelsEnabled = false
            safeCell.chart.xAxis.drawAxisLineEnabled = false
            safeCell.chart.xAxis.drawGridLinesEnabled = false
            
            cell = safeCell
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Pairs to Cull"
        } else {
            return "Pair Move/Cull History"
        }
    }
    
    

    

}
