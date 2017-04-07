//
//  UserDefaultsUtils.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit

class UserDefaultsUtils: NSObject {
    //anyobject
    class func saveValue(value:AnyObject, key:String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    class func valueWithKey(key:String) -> AnyObject {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: key) as AnyObject
    }
    
    //bool
    class func saveBoolValue(value:Bool, key:String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    class func boolValueWithKey(key:String) -> Bool {
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: key)
    }
    
    //string
    class func saveStringValue(value:String, key:String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    class func stringValueWithKey(key:String) -> String {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: key)!
    }
    
    //int
    class func saveIntValue(value:Int, key:String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    class func intValueWithKey(key:String) -> Int {
        let userDefaults = UserDefaults.standard
        return userDefaults.integer(forKey: key)
    }
    
    class func deleteValueWithKey(key:String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
    
    class func parseJSONStringToNSDictionary(jsonString:String) -> NSDictionary {
    
        let jsonData:Data = jsonString.data(using: .utf8)!
        let responseJson = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        let jsonDic = responseJson as! NSDictionary
        
        return jsonDic
    }
}
