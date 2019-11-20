//
//  MyConfig.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit
var serverURL = "https://app.yiyoupin.com.cn/elves/FrmIndex_Phone"
//判断是否需要cdn转向
var URL_APP_ROOT =  (UserDefaults.standard.value(forKey: "newHost")) != nil ? "https://" + (UserDefaults.standard.value(forKey: "newHost") as! String) :serverURL
let WELCOME_IMAGES_COUNT = 3
let FORMS = "forms"
let SERVICES = "services"

//推送
let appkey = "cc92570c841a688af5a0b5cd"
let channel = "Publish channel"
let isProduction = true

class shareedMyApp {
    static var instance: shareedMyApp!
    
    static func getInstance() -> shareedMyApp{
        if(instance == nil){
            instance = shareedMyApp()
        }
        return instance
    }
    
    func getFormUrl(_ formCode: String) -> String{
        if formCode.contains("?"){
            return "\(URL_APP_ROOT)/\(FORMS)/\(formCode)&device=iphone&CLIENTID=\(DisplayUtils.uuid())&sid=\(UserDefaultsUtils.valueWithKey(key: "TOKEN"))"
        }else{
            return "\(URL_APP_ROOT)/\(FORMS)/\(formCode)?device=iphone&CLIENTID=\(DisplayUtils.uuid())&sid=\(UserDefaultsUtils.valueWithKey(key: "TOKEN"))"
        }
        
    }
}
//https://m.yiyoupin.com.cn/elves/install.client?curVersion=1.0.1&appCode=elves-iphone-beta
//MARK: - 版本更新使用
var SERVER = "https://app.yiyoupin.com.cn/elves/"
let APPCODE = "elves-iphone-release"

/// 获取APP版本号
///
/// - Returns: APP当前版本号
func getVersion() -> String{
    let infoDict = Bundle.main.infoDictionary
    let appVersion = infoDict!["CFBundleShortVersionString"] as! String
    return appVersion
}
/// 获取设备唯一识别码
///
/// - Returns: UUID
func myUUID() -> String {
    let uuid = UIDevice.current.identifierForVendor?.description
    return String(format: "i_%@", (uuid?.replacingOccurrences(of: "-", with: ""))!)
}
