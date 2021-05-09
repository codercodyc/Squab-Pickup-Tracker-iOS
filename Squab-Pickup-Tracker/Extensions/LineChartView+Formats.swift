//
//  LineChartView+Formats.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/5/20.
//

import Foundation
import Charts

extension LineChartView {
    
    func plotProduction(with dataEntries: [ChartDataEntry]) {
        
        let line1 = LineChartDataSet(entries: dataEntries)
        
        // Colors and fill
        line1.colors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)]
        line1.drawFilledEnabled = true
        line1.circleRadius = 5
        line1.circleHoleRadius = line1.circleRadius / 1.5
        line1.drawValuesEnabled = false
        line1.mode = .horizontalBezier
        let gradientColors = [UIColor.blue.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [0.9, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        line1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        line1.drawFilledEnabled = true // Draw the Gradient
        
        isUserInteractionEnabled = false
        animate(yAxisDuration: 0.5)
        
        legend.enabled = false
//        leftAxis.axisMaximum = 4
        leftAxis.axisMinimum = 0
        leftAxis.granularity = 1
        
        //Left Axis
        leftAxis.gridLineDashLengths = [4]
        leftAxis.labelTextColor = UIColor.gray
        //Right Axis
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawLabelsEnabled = false
        
        //x Axis
        xAxis.drawGridLinesEnabled = false
//        xAxis.drawAxisLineEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = UIColor.gray
        
        
        let chartData = LineChartData(dataSet: line1)
        
        
        //Limit Line
        let limit = ChartLimitLine(limit: 0.666666)
        limit.lineColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        limit.lineWidth = 0.75
        leftAxis.addLimitLine(limit)
        
        
        data = chartData
        
        
        
    }
}
