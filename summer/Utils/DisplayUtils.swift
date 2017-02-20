//
//  DisplayUtils.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit
import AdSupport

typealias ConfirmBlock = ()->()
typealias CancelBlock = ()->()

class DisplayUtils: NSObject {
    
    fileprivate var confirmBlock:ConfirmBlock?
    fileprivate var cancelBlock:CancelBlock?
    
    class func uuid() -> String {
        var adid = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        adid = adid .replacingOccurrences(of: "-", with: "")
        return adid
    }
    
    class func alertControllerDisplay(str:String, viewController:UIViewController,confirmBlock:@escaping ConfirmBlock,cancelBlock:@escaping CancelBlock){
        let alertController = UIAlertController.init(title: "温馨提示", message: str, preferredStyle: .alert)
        let alertAction1 = UIAlertAction.init(title: "刷新", style: .default) { (action:UIAlertAction) in
            confirmBlock()
        }
        let alertAction2 = UIAlertAction.init(title: "取消", style: .cancel) { (action:UIAlertAction) in
            cancelBlock()
        }
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func dialphoneNumber(number:String) {
        let allString = "tel:\(number)"
        UIApplication.shared.openURL(NSURL.init(string: allString) as! URL)
    }
    
}
