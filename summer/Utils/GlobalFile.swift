//
//  GlobalFile.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit

//屏幕的宽高
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

//颜色
func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) ->UIColor{
    return UIColor(red:r/255.0, green:g/255.0, blue:b/255.0, alpha:a)
}

func current_x(object:UIView) -> CGFloat {
    return object.frame.origin.x
}
func current_y(object:UIView) -> CGFloat {
    return object.frame.origin.y
}
func current_w(object:UIView) -> CGFloat {
    return object.frame.size.width
}
func current_h(object:UIView) -> CGFloat {
    return object.frame.size.height
}
func current_x_w(object:UIView) -> CGFloat {
    return object.frame.origin.x+object.frame.size.width
}
func current_y_h(object:UIView) -> CGFloat {
    return object.frame.origin.y+object.frame.size.height
}

let isBackStr = "/forms/FrmIndex,/forms/Login,/forms/VerificationLogin"
let isRefrushStr = "/forms/Default,/,/forms/Login?device=iphone,/forms/FrmPhoneRegistered,/forms/VerificationLogin,/forms/Login,/forms/FrmLossPassword"

var URLPATH = URL_APP_ROOT+"?device=iphone&CLIENTID="+DisplayUtils.uuid()//url

//var URLPATH_CONFIG = URL_APP_ROOT+"/MobileConfig?device=iphone&CLIENTID="+DisplayUtils.uuid()//配置信息的url
//install.client

var URLPATH_CONFIG = URL_APP_ROOT+"/forms/install.client"//获取启动图片、广告图片及检测版本更新

var EXIT_URL_PATH = URL_APP_ROOT+"/form/TFrmLogout"

var BACK_MAIN = URL_APP_ROOT+"/form/TWebDefault"

let WXPaySuccessNotification = "WeixinPaySuccessNotification"//支付成功

let WX_APPID = "wx41af87527e0b6315"

let kAppVersion = "appVersion"

let KLoadDataBase = "KLoadDataBase"//网络监听

let JPushMessage = "JPushMessage"//极光推送








