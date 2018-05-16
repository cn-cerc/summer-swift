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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showSelectServer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.hidesBackButton = true
    }
}
extension STSelectServerViewController {
    fileprivate func showSelectServer(){
        let alertVC = UIAlertController.init(title: "请输入服务器地址", message: "", preferredStyle: .alert)
        alertVC.addTextField { (inputTF) in
            inputTF.text = URL_APP_ROOT
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
            
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}
