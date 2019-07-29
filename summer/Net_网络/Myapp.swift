//
//  Myapp.swift
//  模块组件
//
//  Created by 箫海岸 on 2018/3/12.
//  Copyright © 2018年 箫海岸. All rights reserved.
//

import UIKit

class Myapp: NSObject {
    
    /// 不带参数拼接的URL
    ///
    /// - Parameters:
    ///   - server: 服务器地址
    ///   - formCode: 功能接口地址
    /// - Returns: 拼接后不带参数的URL
   static func getForm(server: String,formCode: String) -> String {
        return getFormParameters(Server: server, formCode: formCode, Parameters: "")
    }
    
     /// 带参数拼接的URL
     ///
     /// - Parameters:
     ///   - Server: 服务器地址
     ///   - formCode: 功能接口地址
     ///   - Parameters: 携带的请求参数
     /// - Returns: 拼接后带参数的URL
    static  func getFormParameters(Server: String,formCode: String,Parameters: String) -> String {
        let uuid = myUUID()
        let urlString = Server + "/forms/" + formCode + "?CLIENTID=" + uuid + "&device=iphone";
        if Parameters.isEmpty{
            return urlString
        }else{
            return urlString + "&" + Parameters
        }
    }
    
    

}
