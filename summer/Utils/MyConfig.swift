//
//  MyConfig.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit

let URL_APP_ROOT = "https://m.knowall.cn"//域名地址//内测版
//let URL_APP_ROOT = "http://192.168.1.166:80"//域名地址//内测版
let WELCOME_IMAGES_COUNT = 3
let FORMS = "form"
let SERVICES = "services"

//推送
let appkey = "cc92570c841a688af5adc5b0"
let channel = "Publish channel"
let isProduction = true

class MyApp {
    static var instance: MyApp!
    
    static func getInstance() -> MyApp{
        if(instance == nil){
            instance = MyApp()
        }
        return instance
    }
    
    func getFormUrl(_ formCode: String) -> String{
        return "\(URL_APP_ROOT)/\(FORMS)/\(formCode)?device=iphone&CLIENTID=\(DisplayUtils.uuid())"
    }
}
