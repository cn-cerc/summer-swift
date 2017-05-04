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
    
    var xArray:Array<Any>?
    var yArray:Array<Any>?
    
    fileprivate lazy var chartView:DVLineChartView = {
        let chartView = DVLineChartView()
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        self.setNavTitle(title: "图表")
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWithImage(image: UIImage.init(named: "ic_nav_back")!, target: self as CustemBBI, infoStr: "first")
        self.navigationItem.rightBarButtonItem = CustemNavItem.initWithString(str: "帮助", target: self, infoStr: "second")
        xArray = [String]()
        yArray = [String]()
        charChange()
        createView()
    }
    
    func charChange(){
        print(UserDefaultsUtils.parseJSONStringToNSDictionary(jsonString: dataStr!))
        let dataArr = UserDefaultsUtils.parseJSONStringToNSDictionary(jsonString: dataStr!).value(forKey: "data") as! Array<Any>
        for i in 0..<dataArr.count {
            let dataDic = dataArr[i]
            let oneDic = dataDic as? Dictionary<String, Any>
            let timeStr:String = (oneDic?["checkDate_"] as! String) + "\n" + (oneDic?["xuetangceshi_"] as! String)
            xArray?.append(timeStr)
            yArray?.append(oneDic?["blodSug_"] as! String)
        }
    }
    
    func createView() {
        
        self.chartView.width = self.view.width
        self.chartView.yAxisViewWidth = 52
        self.chartView.numberOfYAxisElements = 5
        self.chartView.isPointUserInteractionEnabled = true
        self.chartView.yAxisMaxValue = 30
        self.chartView.pointGap = 50
        
        self.chartView.isShowSeparate = true
        self.chartView.separateColor = UIColor.init(hexString: "67707c")
        
        self.chartView.textColor = UIColor.init(hexString: "9aafc1")
        self.chartView.backColor = UIColor.white
        self.chartView.axisColor = UIColor.init(hexString: "67707c")
        self.chartView.xAxisTitleArray = xArray as [Any]!
        self.chartView.textFont = UIFont.systemFont(ofSize: 10)
        
        self.chartView.x = 0
        self.chartView.y = 100
        self.chartView.width = self.view.width-30
        self.chartView.height = 300
        
        let plot = DVPlot()
        plot.pointArray = yArray!
        plot.lineColor = UIColor.init(hexString: "2f7184")
        plot.pointColor = UIColor.init(hexString: "14b9d6")
        plot.withPoint = true
        self.chartView.addPlot(plot)
        self.chartView.draw()
        self.view.addSubview(self.chartView)
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
            let helpVC = HelpViewController()
            self.navigationController?.pushViewController(helpVC, animated: true)
        }
    }
}
