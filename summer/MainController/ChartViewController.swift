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
    var type:Int?
    
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
//        print(UserDefaultsUtils.parseJSONStringToNSDictionary(jsonString: dataStr!))
        if dataStr != nil {
            let dataArr = UserDefaultsUtils.parseJSONStringToNSDictionary(jsonString: dataStr!).value(forKey: "data") as! Array<Any>
            var array1 : [String] = [String]()
            var array2 : [String] = [String]()
            var array3 : [String] = [String]()
            
            for i in 0..<dataArr.count {
                let dataDic:Dictionary<String,Any> = dataArr[i] as! Dictionary<String, Any>
//                let oneDic = dataDic as? Dictionary<String, Any>
                let keys = Array(dataDic.keys)
                print(keys)
                if keys.contains("blodSug_"){
                    let timeStr:String = (dataDic["checkDate_"] as! String) + "\n" + (dataDic["xuetangceshi_"] as! String)
                    xArray?.append(timeStr)
                    array1.append(dataDic["blodSug_"] as! String)
                    type = 1
                }else if keys.contains("height_"){
                    let timeStr:String = (dataDic["checkDate_"] as! String) + "\n" + (dataDic["xueyaceshi_"] as! String)
                    xArray?.append(timeStr)
                    array1.append(dataDic["height_"] as! String)
                    array2.append(dataDic["weight_"] as! String)
                    type = 2
                }else if keys.contains("sportTime_"){
                    let timeStr:String = (dataDic["checkDate_"] as! String) + "\n" + (dataDic["xueyaceshi_"] as! String)
                    xArray?.append(timeStr)
                    array1.append(dataDic["sportTime_"] as! String)
                    type = 3
                }else if keys.contains("xinlv_"){
                    let timeStr:String = (dataDic["checkDate_"] as! String) + "\n" + (dataDic["xueyaceshi_"] as! String)
                    xArray?.append(timeStr)
                    array1.append(dataDic["shousuo_"] as! String)
                    array2.append(dataDic["shuzhan_"] as! String)
                    array3.append(dataDic["xinlv_"] as! String)
                    type = 4
                }
            }
           
            yArray?.append(array1)
            yArray?.append(array2)
            yArray?.append(array3)
        }
    }
    
    func createView() {
        
        self.chartView.width = self.view.width
        self.chartView.yAxisViewWidth = 52
        self.chartView.numberOfYAxisElements = 5
        self.chartView.isPointUserInteractionEnabled = true
        if type == 1 {
            self.chartView.yAxisMaxValue = 35
        }else if type == 2{
            self.chartView.yAxisMaxValue = 260
        }else if type == 3{
            self.chartView.yAxisMaxValue = 260
        }else if type == 4{
            self.chartView.yAxisMaxValue = 250
        }else{
            
        }
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
//        plot.lineColor = UIColor.init(hexString: "2f7184")
        plot.lineColorArr = [UIColor.init(hexString: "DD2BB2"),UIColor.init(hexString: "FF9600"),UIColor.init(hexString: "48b2bd")];
        plot.pointColor = UIColor.init(hexString: "14b9d6")
        plot.withPoint = true
        self.chartView.addPlot(plot)
        self.chartView.draw()
        self.view.addSubview(self.chartView)
        
        let oneColorLabel = UILabel.init(frame: CGRect.init(x: 10, y: self.chartView.frame.origin.y+self.chartView.frame.size.height+20, width: 8, height: 8))
        oneColorLabel.backgroundColor = UIColor.init(hexString: "DD2BB2")
        self.view.addSubview(oneColorLabel)
        
        let oneNameLabel = UILabel.init(frame: CGRect.init(x: 25, y: self.chartView.frame.origin.y+self.chartView.frame.size.height+4, width: SCREEN_WIDTH/3-25, height: 40))
        oneNameLabel.font = UIFont.systemFont(ofSize: 13)
        self.view.addSubview(oneNameLabel)
        
        let twoColorLabel = UILabel.init(frame: CGRect.init(x: SCREEN_WIDTH/3, y: self.chartView.frame.origin.y+self.chartView.frame.size.height+20, width: 8, height: 8))
        twoColorLabel.backgroundColor = UIColor.init(hexString: "FF9600")
        self.view.addSubview(twoColorLabel)
        
        let twoNameLabel = UILabel.init(frame: CGRect.init(x: SCREEN_WIDTH/3+15, y: self.chartView.frame.origin.y+self.chartView.frame.size.height+4, width: SCREEN_WIDTH/3-25, height: 40))
        twoNameLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(twoNameLabel)
        
        let threeColorLabel = UILabel.init(frame: CGRect.init(x: (SCREEN_WIDTH/3)*2, y: self.chartView.frame.origin.y+self.chartView.frame.size.height+20, width: 8, height: 8))
        threeColorLabel.backgroundColor = UIColor.init(hexString: "48b2bd")
        self.view.addSubview(threeColorLabel)
        
        let threeNameLabel = UILabel.init(frame: CGRect.init(x: (SCREEN_WIDTH/3)*2+15, y: self.chartView.frame.origin.y+self.chartView.frame.size.height+4, width: SCREEN_WIDTH/3-25, height: 40))
        threeNameLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(threeNameLabel)
        
        if type == 1 {
            oneColorLabel.isHidden = false
            twoColorLabel.isHidden = true
            threeColorLabel.isHidden = true
            oneNameLabel.text = "血糖"
            twoNameLabel.text = ""
            threeNameLabel.text = ""
        }else if type == 2{
            oneColorLabel.isHidden = false
            twoColorLabel.isHidden = false
            threeColorLabel.isHidden = true
            oneNameLabel.text = "身高"
            twoNameLabel.text = "体重"
            threeNameLabel.text = ""
        }else if type == 3{
            oneColorLabel.isHidden = false
            twoColorLabel.isHidden = true
            threeColorLabel.isHidden = true
            oneNameLabel.text = "运动时间"
            twoNameLabel.text = ""
            threeNameLabel.text = ""
        }else if type == 4{
            oneColorLabel.isHidden = false
            twoColorLabel.isHidden = false
            threeColorLabel.isHidden = false
            oneNameLabel.text = "收缩压"
            twoNameLabel.text = "舒张压"
            threeNameLabel.text = "心率"
        }else{
            oneColorLabel.isHidden = true
            twoColorLabel.isHidden = true
            threeColorLabel.isHidden = true
            oneNameLabel.text = ""
            twoNameLabel.text = ""
            threeNameLabel.text = ""
        }
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
