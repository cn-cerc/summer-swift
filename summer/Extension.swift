//
//  Extension.swift
//  summer
//
//  Created by cts on 2017/7/21.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import Foundation
//扩展一个Data对象的方法来将Data转换成json
extension Data {
    func toJson() -> Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }
}
