//
//  String+Json.swift
//  summer
//
//  Created by FangLin on 17/4/6.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit

extension String{
    func parseJSONStringToNSDictionary(jsonString:String) -> NSDictionary? {
        let jsonData = jsonString.data(using: String.Encoding.utf8)
        let responseJson:Any = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
        let jsonDic = responseJson as!Dictionary<String,Any>
        
        return jsonDic as NSDictionary?
    }
}
