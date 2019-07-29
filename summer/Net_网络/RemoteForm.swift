//
//  RemoteForm.swift
//  模块组件
//
//  Created by 箫海岸 on 2018/3/12.
//  Copyright © 2018年 箫海岸. All rights reserved.
//

import Foundation
import Alamofire

/// 请求方式枚举
///
/// - get: get方法
/// - post: post方法
enum MethodType {
    case get
    case post
}

/// 上传内容的枚举
///
/// - image: 图片
/// - video: 视频
enum UploadType {
    case image
    case video
}
/** 回调闭包 */
typealias RemoteFormClosure = (RemoteForm)-> Void

class RemoteForm: NSObject {
    
    var onResult: RemoteFormClosure?
    /** 重复请求次数 */
    fileprivate var repeatNum: Int = 3
    fileprivate var result: Bool?
    fileprivate var message: String?
    /** 返回的数据 */
    fileprivate var dataDict: Dictionary<String , Any>?
    fileprivate var response: DataResponse<Any>?
    /** 请求的数据 */
    var parametersDict: Dictionary<String, Any> = ["":""]
    var netManager: NetworkReachabilityManager?
    
    
    
    override init() {
        super.init()
    }

   class func initRemoteForm() -> RemoteForm {
        let rf = RemoteForm.init()
        return rf
    }
    
    
}


extension RemoteForm{
    
    /// 向服务器请求数据
    ///
    /// - Parameters:
    ///   - type: 请求类型：.get 或 .post
    ///   - urlString: 请求路径URL
    func requestDataFromServer(type:MethodType,urlString: String) {
        let methodType = type == .get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(urlString, method: methodType, parameters: parametersDict, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            printLog(message: response)
            //没有response.result或response.result为空
            guard let res: Result = response.result else{
                self.setResultMessage(result: false, message: "请求失败，请检查网络连接")
                printLog(message: "result错误\(String(describing: response.result.error))")
                return
            }
            //请求服务器失败
            if res.isFailure {
                if self.repeatNum == 0{
                    //请求服务失败
                    self.setResultMessage(result: false, message: "请求服务失败")
                    return
                }else{
                   self.repeatNum -= 1
                    self.requestDataFromServer(type: type, urlString: urlString)
                }
            }
            //请求服务器成功
            if res.isSuccess{
                self.response = response
                //接收服务器返回来的数据
                self.dataDict = response.value as? Dictionary <String, Any>
                printLog(message: "数据数据****\(String(describing: self.dataDict))")
                //判断数据里面的key的数量是否为0
                if self.dataDict == nil{
                    self.setResultMessage(result: false, message: "服务器返回数据为空")
                    self.dataDict = ["":""]
                    return
                }
                let keysArray = self.dataDict?.keys
                if keysArray?.count == 0{
                    self.setResultMessage(result: false, message: "服务器返回数据错误")
                    return
                }
                //判断服务器返回的 result 的值
                if (keysArray?.contains("result"))!{
                    self.result = self.dataDict!["result"] as? Bool
                }else{
                    self.result = false
                }
                //判断服务器返回来的 message 的值
                if (keysArray?.contains("message"))!{
                    self.message = self.dataDict!["message"] as? String
                }else{
                    if self.result == false{
                        self.message = "执行失败"
                    }
                }
                self.setResultMessage(result: self.result!, message: self.message!)
            }
        }
        
    }
    
    /// 传递服务器请求状态与信息的函数
    ///
    /// - Parameters:
    ///   - result: 访问服务器状态： true/成功，false/失败。若没有则自定义为 false
    ///   - message: 服务器返回的请求信息。若没有则自定义为“执行失败”
    private func setResultMessage(result: Bool,message: String) {
        self.repeatNum = 3
        self.result = result
        self.message = message
        self.onResult!(self)
    }
    
    func uploadImageVideo(type: MethodType,urlString: String) {
        
    }
    
    func getResult() -> Bool {
        return result!
    }
    func getMessage() -> String {
        return message!
    }
    func getServerData() -> Dictionary<String, Any> {
        printLog(message: "8899:\(dataDict)")
        return dataDict!
    }
    
}











