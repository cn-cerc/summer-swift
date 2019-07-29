//
//  BaseNavViewController.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit

class BaseNavViewController: UINavigationController {
    
    var viewControll: UIViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        self.viewControll = super.popViewController(animated: animated)
        return self.viewControll
    }
    
}


