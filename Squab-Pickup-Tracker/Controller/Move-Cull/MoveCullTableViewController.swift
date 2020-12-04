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
    
    func sumData(data: [Double]) -> Double {
        var sum: Double = 0
        for item in data {
            sum += item
        }
        return sum
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
//            var totals: [Double] = []
            for _ in 0...11 {
                let number = Double(Int.random(in: 0...2))
                randomData.append(number)
//
//                let newTotal = sumData(data: randomData)
//                totals.append(newTotal)
            }
            
            var lineChartEntry = [ChartDataEntry]()
//            var totalsEntry = [ChartDataEntry]()
            
            
            for i in 0..<randomData.count {
                let value = ChartDataEntry(x: Double(i), y: randomData[i])
                lineChartEntry.append(value)
                
//                let total = ChartDataEntry(x: Double(i), y: totals[i])
//                totalsEntry.append(total)
            }
            
            
            let line1 = LineChartDataSet(entries: lineChartEntry)
            line1.colors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)]
            line1.drawFilledEnabled = true
            line1.circleRadius = 4.5
            line1.drawValuesEnabled = false
            
            let gradientColors = [UIColor.blue.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
            let colorLocations:[CGFloat] = [0.75, 0.0] // Positioning of the gradient
            let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
            line1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
            line1.drawFilledEnabled = true // Draw the Gradient
            
//            let line2 = LineChartDataSet(entries: totalsEntry)
//            line2.colors = [NSUIColor.red]
//            line2.circleRadius = 2
//            line2.drawValuesEnabled = false
            
            let data = LineChartData(dataSets: [line1])
            safeCell.chart.data = data
            
            safeCell.chart.isUserInteractionEnabled = false
            
            
            safeCell.chart.animate(xAxisDuration: 1.0)
            
            
            safeCell.chart.legend.enabled = false
            safeCell.chart.leftAxis.axisMaximum = 2.25
            
            safeCell.chart.leftAxis.granularity = 1
            safeCell.chart.rightAxis.granularity = 1
            safeCell.chart.leftAxis.axisMinimum = 0

            let limit = ChartLimitLine(limit: 0.67)
            limit.lineColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            limit.lineWidth = 1
            safeCell.chart.leftAxis.addLimitLine(limit)
            
            safeCell.chart.leftAxis.drawZeroLineEnabled = true
            safeCell.chart.leftAxis.drawLimitLinesBehindDataEnabled = true
            safeCell.chart.leftAxis.drawGridLinesEnabled = false
            safeCell.chart.leftAxis.drawAxisLineEnabled = false
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
