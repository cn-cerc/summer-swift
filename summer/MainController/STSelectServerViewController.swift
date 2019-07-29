//
//  STSelectServerViewController.swift
//  bbc-iphone
//
//  Created by 王雨 on 2018/2/7.
//  Copyright © 2018年 FangLin. All rights reserved.
//

import UIKit
class STSelectServerViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSelectServer()
        return
        
        
        let btn:UIButton = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect.init(x: 100, y: 100, width: 80, height: 50)
        btn.setTitle("导航", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(btnClick), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn)
        
        let button:UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect.init(x: 100, y: 200, width: 80, height: 50)
        button.setTitle("游戏", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(buttonClick), for: UIControl.Event.touchUpInside)
        self.view.addSubview(button)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        showSelectServer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.hidesBackButton = true
    }
    @objc func btnClick() {
        print("导航")
        let vc = ARSearchViewController()
        self.present(vc, animated: true, completion: nil)
    }
    @objc func buttonClick() {
        print("游戏")
        let vc = ARSpiritViewController()
        self.present(vc, animated: true, completion: nil)
    }
}
extension STSelectServerViewController {
    fileprivate func showSelectServer(){
        let alertVC = UIAlertController.init(title: "请输入服务器地址", message: "", preferredStyle: .alert)
        alertVC.addTextField { (inputTF) in
            inputTF.text =  UserDefaults.standard.value(forKey: "myServer") != nil ? UserDefaults.standard.value(forKey: "myServer") as! String : URL_APP_ROOT
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
            var serverUrl = alertVC.textFields?.first?.text
            if serverUrl?.count == 0{
                serverUrl = URL_APP_ROOT
            }
            
            URL_APP_ROOT = serverUrl!
            let mainVC = MainViewController()
            self.navigationController?.pushViewController(mainVC, animated: true)
            UIApplication.shared.keyWindow?.rootViewController = BaseNavViewController(rootViewController:mainVC)
            UserDefaults.standard.set(serverUrl, forKey: "myServer")
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}
