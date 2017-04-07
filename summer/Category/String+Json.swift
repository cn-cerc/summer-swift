//
//  String+Json.swift
//  summer
//
//  Created by FangLin on 17/4/6.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit

extension String{
    func parseJSONStringToNSDictionary(jsonString:String) -> NSDictionary {
        let jsonData = jsonString.data(using: String.Encoding.utf8)
        let responseJson = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableLeaves)
        let jsonDic = responseJson as!NSDictionary
        
        return jsonDic
    }
    
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
}
