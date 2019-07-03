//
//  SettingViewController.swift
//  summer
//
//  Created by FangLin on 2/14/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit

protocol SettingDelegate:NSObjectProtocol {
    func perverseInfo(scale:Float)
}

class SettingViewController: BaseViewController {
    
    weak var delegate:SettingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.setNavTitle(title: "设置")
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWithImage(image: UIImage.init(named: "ic_nav_back")!, target: self as CustemBBI, infoStr: "first")
        
        createUI()
    }
    
    //懒加载
    fileprivate lazy var slider:UISlider = {
        let slider = UISlider.init(frame: CGRect.init(x: 40, y: 120, width: SCREEN_WIDTH-80, height: 30))
        return slider
    }()
    
    fileprivate lazy var valueLabel:UILabel = {
        let valueLabel = UILabel(frame: CGRect.init(x: 40, y: current_y_h(object: self.slider)+10, width: 50, height: 30))
        valueLabel.text = UserDefaultsUtils.valueWithKey(key: "scale") as? String
        valueLabel.font = UIFont.systemFont(ofSize: 15)
        valueLabel.textAlignment = .center
        valueLabel.layer.borderWidth = 1.0
        valueLabel.layer.borderColor = UIColor.gray.cgColor
        valueLabel.layer.masksToBounds = true
        valueLabel.layer.cornerRadius = 15
        return valueLabel
    }()
    
    fileprivate lazy var perverseBtn:UIButton = {
        let perverseBtn = UIButton(type: UIButtonType.custom)
        perverseBtn.frame = CGRect.init(x: 40, y: current_y_h(object: self.valueLabel)+10, width: 70, height: 35)
        perverseBtn.setTitle("保存", for: .normal)
        perverseBtn.backgroundColor = RGBA(r: 200, g: 200, b: 200, a: 1.0)
        perverseBtn.setTitleColor(UIColor.white, for: .normal)
        perverseBtn.layer.cornerRadius = 5
        perverseBtn.layer.masksToBounds = true
        perverseBtn.addTarget(self, action: #selector(perverseClick), for: .touchUpInside)
        return perverseBtn
    }()
    
    @objc func perverseClick() {
        UserDefaultsUtils.saveValue(value: self.valueLabel.text! as AnyObject, key: "scale")
        if self.delegate != nil {
            print(self.valueLabel.text)
            delegate?.perverseInfo(scale: Float(self.valueLabel.text!)!)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SettingViewController{
    fileprivate func createUI() {
        custemSlider()
        view.addSubview(self.valueLabel)
        view.addSubview(self.perverseBtn)
    }
    
    fileprivate func custemSlider() {
        let label = UILabel(frame:CGRect.init(x: 20, y: 70, width: 100, height: 50))
        label.text = "缩放比例:"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.black
        view.addSubview(label)
        
        //定义两张图片
        slider.minimumValue = 0.8//最小值
        slider.maximumValue = 1.2//最大值
        let value:String? = UserDefaultsUtils.valueWithKey(key: "scale")as? String
        slider.value = Float(value!)!
        slider.addTarget(self, action: #selector(sliderAction), for: .valueChanged)
        view.addSubview(slider)
    }
    
    @objc func sliderAction(slider:UISlider) {
        print(slider.value)
        self.valueLabel.text = String(format:"%.2f",slider.value)
    }
}

extension SettingViewController:CustemBBI {
    func BBIdidClickWithName(infoStr: String) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
