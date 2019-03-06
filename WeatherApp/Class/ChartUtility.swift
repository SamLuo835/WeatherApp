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

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate

    
    func drawChart(first:[String],second:[Double],chart:LineChartView){
        
        
        
        var chartEntries : [ChartDataEntry] = []
        for i in 0..<first.count{
            let newEntry = ChartDataEntry( x:Double(i),y:second[i])
            chartEntries.append(newEntry)
        }
        let set: LineChartDataSet = LineChartDataSet(values: chartEntries, label: nil)
        //set.setColor(NSUIColor.blue, alpha: CGFloat(1))
        //set.circleColors = [NSUIColor.blue]
        set.circleRadius = 3
        set.mode = LineChartDataSet.Mode.cubicBezier
        
        let data: LineChartData = LineChartData(dataSet: set)
        chart.legend.enabled = false
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.xAxis.labelRotationAngle = -70
        chart.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return first[Int(index)]
        })
        
        if(mainDelegate.celBoolean){
            chart.chartDescription?.text = "°C"
        }
        else {chart.chartDescription?.text = "°F"}
        chart.chartDescription?.font = UIFont.systemFont(ofSize: 15,weight: .bold)
        chart.xAxis.setLabelCount(second.count, force: true)
        DispatchQueue.main.sync {
            chart.data = data
            chart.isHidden = false
            chart.setNeedsDisplay()
        }
    }
    
    
}
