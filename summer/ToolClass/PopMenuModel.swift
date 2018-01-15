//
//  PopMenuModel.swift
//  summer
//
//  Created by 王雨 on 2018/1/15.
//  Copyright © 2018年 FangLin. All rights reserved.
//

import Foundation
class PopMenuModel : NSObject {
    var icon : String = ""
    var title : String = ""
    init(dic : [String : Any]) {
        super.init()
        setValuesForKeys(dic)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
