//
//  DebugLogTool.swift
//  summer
//
//  Created by cts on 2017/7/20.
//  Copyright © 2017年 FangLin. All rights reserved.
//
//主要用来在Debug模式下打印信息的时候使用
import UIKit

final class DebugLogTool: NSObject {
    //只打印信息
    static func XLPrint<T>( item: T) {
        #if DEBUG
            print(item)
        #endif
    }
    //打印信息和所调用函数名字
    static func XLPrintWithFunc<T>(item: T, method: String = #function) {
        #if DEBUG
            print("\(method): \(item)")
        #endif
    }
    //打印信息、调用函数名字以及函数所在行号
    static func XLPrintWithFuncOnLine<T>(item: T, file: NSString = #file, method: String = #function, line: Int = #line)
    {
        #if DEBUG
            print("\(method)[\(line)]: \(item)")
        #endif
    }
    //打印详细信息，包括调用函数所在目录
    static func XLPrintWithDescription<T>(item: T, file: NSString = #file, method: String = #function, line: Int = #line)
    {
        #if DEBUG
            print("\(file)->\(method)[\(line)]: \(item)")
        #endif
    }
    
}
