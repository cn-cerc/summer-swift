//
//  ChartViewController.swift
//  summer
//
//  Created by FangLin on 17/4/1.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit

class ChartViewController: BaseViewController {
    
    var xArray:NSArray? = nil
    var yArray:NSArray? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        let chartView = DVLineChartView()
        self.view.addSubview(chartView)
        chartView.width = self.view.width
        chartView.yAxisViewWidth = 52
        chartView.numberOfYAxisElements = 5
        chartView.isPointUserInteractionEnabled = true
        chartView.yAxisMaxValue = 1000
        chartView.pointGap = 50
        
        chartView.isShowSeparate = true
        chartView.separateColor = UIColor.black
        
        chartView.textColor = UIColor.black
        chartView.backColor = UIColor.white
        chartView.axisColor = UIColor.black
        chartView.xAxisTitleArray = xArray as! [Any]!
        
        chartView.x = 0
        chartView.y = 100
        chartView.width = self.view.width-80
        chartView.height = 300
        
        let plot = DVPlot()
        plot.pointArray = yArray as! [Any]!
        plot.lineColor = UIColor.black
        plot.pointColor = UIColor.init(hexString: "14b9d6")
        plot.withPoint = true
        chartView.addPlot(plot)
        chartView.draw()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ChartViewController:DVLineChartViewDelegate {
    func lineChartView(_ lineChartView: DVLineChartView!, didClickPointAt index: Int) {
        print(index)
    }
}
