//
//  MyConfig.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit
var serverURL = "https://m.knowall.cn"//master版
//var serverURL = "https://c1.knowall.cn"//Beta版
//var URL_APP_ROOT = "http://192.168.2.14"
//判断是否需要cdn转向
var URL_APP_ROOT =  (UserDefaults.standard.value(forKey: "newHost")) != nil ? "https://" + (UserDefaults.standard.value(forKey: "newHost") as! String) :serverURL
let WELCOME_IMAGES_COUNT = 3
let FORMS = "forms"
let SERVICES = "services"

//推送
let appkey = "cc92570c841a688af5adc5b0"
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
        return "\(URL_APP_ROOT)/\(FORMS)/\(formCode)?device=iphone&CLIENTID=\(DisplayUtils.uuid())&sid=\(UserDefaultsUtils.valueWithKey(key: "TOKEN"))"
    }
}
