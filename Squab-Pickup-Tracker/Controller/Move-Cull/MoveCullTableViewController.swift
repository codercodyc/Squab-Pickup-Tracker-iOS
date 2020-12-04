//
//  MoveCullTableViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/3/20.
//

import UIKit
import Charts

class MoveCullTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: K.ProductionCellNibName, bundle: nil), forCellReuseIdentifier: K.ProductionByWeekCellIdentifier)

        
    }
    
    func averageData(data: [Double]) -> [Double] {
        
        var averages: [Double] = []
        for i in 0..<data.count {
            if i == 0 {
                let newAvg = (data[i] + data[i+1]) / 2
                averages.append(newAvg)
            } else if i == data.count - 1{
                let newAvg = (data[i] + data[i-1]) / 2
                averages.append(newAvg)
            } else {
                let newAvg = (data[i-1] + data[i] + data[i+1]) / 3
                averages.append(newAvg)
            }
        }
        return averages
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
            for _ in 0...11 {
                let number = Double(Int.random(in: 0...2))
                randomData.append(number)

            }
            let runningAvg: [Double] = averageData(data: randomData)
            
            var lineChartEntry = [ChartDataEntry]()
            var avgEntry = [ChartDataEntry]()
            
            
            for i in 0..<randomData.count {
                let value = ChartDataEntry(x: Double(i), y: randomData[i])
                lineChartEntry.append(value)
                
                let average = ChartDataEntry(x: Double(i), y: runningAvg[i])
                avgEntry.append(average)
            }
            
            
            let line1 = LineChartDataSet(entries: lineChartEntry)
            line1.colors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)]
            line1.drawFilledEnabled = true
            line1.circleRadius = 4.5
            line1.circleHoleRadius = line1.circleRadius / 1.5
            line1.drawValuesEnabled = false
            line1.mode = .horizontalBezier
            
            let gradientColors = [UIColor.blue.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
            let colorLocations:[CGFloat] = [0.9, 0.0] // Positioning of the gradient
            let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
            line1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
            line1.drawFilledEnabled = true // Draw the Gradient
            
            let line2 = LineChartDataSet(entries: avgEntry)
            line2.colors = [NSUIColor.red]
            line2.drawCirclesEnabled = false
            line2.drawValuesEnabled = false
            line2.mode = .horizontalBezier
            line2.drawFilledEnabled = true
//            line2.fillColor = .red
//            line2.fillAlpha = 0.25
            
            let gradientColors2 = [UIColor.red.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
            let colorLocations2:[CGFloat] = [0.9, 0.0] // Positioning of the gradient
            let gradient2 = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors2, locations: colorLocations2) // Gradient Object
            line2.fill = Fill.fillWithLinearGradient(gradient2!, angle: 90.0) // Set the Gradient
            line2.drawFilledEnabled = true // Draw the Gradient
            
            let data = LineChartData(dataSets: [line2, line1])
            safeCell.chart.data = data
            
            safeCell.chart.isUserInteractionEnabled = false
            
            
//            safeCell.chart.animate(xAxisDuration: 1.0)
            safeCell.chart.animate(yAxisDuration: 1.0)
            
            
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
