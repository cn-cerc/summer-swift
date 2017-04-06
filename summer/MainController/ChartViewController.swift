//
//  ChartViewController.swift
//  summer
//
//  Created by FangLin on 17/4/1.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit

class ChartViewController: BaseViewController {
    
    var dataStr:String?
    
    var xArray:NSArray?
    var yArray:NSArray?
    
    fileprivate lazy var chartView:DVLineChartView = {
        let chartView = DVLineChartView()
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(hexString: "3e4a59");
        self.setNavTitle(title: "图表")
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWithImage(image: UIImage.init(named: "ic_nav_back")!, target: self as CustemBBI, infoStr: "first")
        self.navigationItem.rightBarButtonItem = CustemNavItem.initWithString(str: "帮助", target: self, infoStr: "second")
        charChange()
        createView()
    }
    
    func charChange(){
        dataStr = dataStr?.replacingOccurrences(of: "[", with: "", options: .literal, range: nil)
        dataStr = dataStr?.replacingOccurrences(of: "]", with: "", options: .literal, range: nil)
        let dataArr = dataStr?.components(separatedBy: ", ")
        print(dataArr?.count)
        for <#item#> in <#items#> {
            <#code#>
        }
    }
    
    func createView() {
        self.view.addSubview(self.chartView)
        self.chartView.width = self.view.width
        self.chartView.yAxisViewWidth = 52
        self.chartView.numberOfYAxisElements = 5
        self.chartView.isPointUserInteractionEnabled = true
        self.chartView.yAxisMaxValue = 1000
        self.chartView.pointGap = 50
        
        self.chartView.isShowSeparate = true
        self.chartView.separateColor = UIColor.init(hexString: "67707c")
        
        self.chartView.textColor = UIColor.init(hexString: "9aafc1")
        self.chartView.backColor = UIColor.init(hexString: "3e4a59")
        self.chartView.axisColor = UIColor.init(hexString: "67707c")
        self.chartView.xAxisTitleArray = xArray as! [Any]!
        
        self.chartView.x = 0
        self.chartView.y = 100
        self.chartView.width = self.view.width-80
        self.chartView.height = 300
        
        let plot = DVPlot()
        plot.pointArray = nil
        plot.lineColor = UIColor.init(hexString: "2f7184")
        plot.pointColor = UIColor.init(hexString: "14b9d6")
        plot.withPoint = true
        self.chartView.addPlot(plot)
        self.chartView.draw()
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

extension ChartViewController:CustemBBI {
    func BBIdidClickWithName(infoStr: String) {
        if infoStr == "first" {
            _ = self.navigationController?.popViewController(animated: true)
        }else if infoStr == "second" {
            
        }
    }
}
