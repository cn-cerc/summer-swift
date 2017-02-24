//
//  BaseViewController.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    fileprivate var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BaseViewController{
    func setNavTitle(title:String){
        label = UILabel()
        label?.frame = CGRect(x:0,y:0,width:60,height:44)
        label.text = title
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 19)
        self.navigationItem.titleView = label
    }
}
