//
//  ChartUtility.swift
//  WeatherApp
//
//  Created by Jianlin Luo on 2019-03-04.
//  Copyright © 2019 Jianlin Luo. All rights reserved.
//

import UIKit
import Charts
class ChartUtility: NSObject {

    
    func drawChart(first:[String],second:[Double],chart:LineChartView){
        var chartEntries : [ChartDataEntry] = []
        for i in 0..<first.count{
            let newEntry = ChartDataEntry( x:Double(i),y:second[i])
            chartEntries.append(newEntry)
        }
        let set: LineChartDataSet = LineChartDataSet(values: chartEntries, label: "°C")
        set.setColor(NSUIColor.blue, alpha: CGFloat(1))
        set.circleColors = [NSUIColor.blue]
        set.circleRadius = 3
        set.mode = LineChartDataSet.Mode.cubicBezier
        
        let data: LineChartData = LineChartData(dataSet: set)
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.xAxis.labelRotationAngle = -70
        chart.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return first[Int(index)]
        })
        
        chart.chartDescription?.text = "°C"
        chart.xAxis.setLabelCount(second.count, force: true)
        chart.data = data
        DispatchQueue.main.sync {
            chart.setNeedsDisplay()
        }
    }
    
    
}
