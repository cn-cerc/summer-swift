//
//  Provider.swift
//  summer
//
//  Created by cts on 2017/7/20.
//  Copyright © 2017年 FangLin. All rights reserved.
//
//主要用来发送网络请求
import Foundation
//import Alamofire
import Moya

typealias Parameters = [String : Any]?
//创建一个全局的provider来发网络请求
let provider = MoyaProvider<RequestSession>()
//定义一个存储值为字典的枚举，主要是为了存放参数
enum RequestSession {
    case UrlPath(Parameters)
    case UrlPathConfig(Parameters)
    case ExitUrlPath
    case BackMain
}
//实现协议
extension RequestSession: TargetType {
    /// 基础的URL
    var baseURL: URL { return URL(string: URL_APP_ROOT)! }
    
    /// 这里枚举baseURL下的路径
    var path: String {
        switch self {
        case .UrlPathConfig:
            return "/MobileConfig"
        case .ExitUrlPath:
            return "/form/TFrmLogout"
        case .BackMain:
            return "/form/TWebDefault"
        default: //使用根路径(baseURL)的返回空字符串
            return ""
        }
    }
    
    /// 设置请求类型
    var method: Moya.Method {
        switch self {
        //这里需要发其他请求类型的自己加枚举，默认发get请求
        default:
            return .get
        }
    }
    
    /// 这里自己自己添加需要参数的枚举，默认参数为nil
    var parameters: [String: Any]? {
        //这里为了方便可以写上一些通用参数，这里你也可以使用自己传入的参数
        let publicParameters = ["device" : "iphone",
                                "CLIENTID" : DisplayUtils.uuid()]
        switch self {   //这里你传入了参数则使用传入的参数，否则使用通用参数
        case .UrlPath(let parameters):
            if let param = parameters {
                return param
            }
            return publicParameters
        case .UrlPathConfig(let parameters):
            if let param = parameters {
                return param
            }
            return publicParameters
            
        default:
            return nil
        }

    }
    
    /// 这里设置编码类型为默认的
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data { return "".data(using: .utf8)! }
    
    /// 这里的任务类型是request，需要其他类型自己枚举
    var task: Task {  return .request }
    
    /// 这里默认桥接Alamofire
    var validate: Bool { return false }
}

func dataToJson(data: Data) -> Any
{
   return  try! JSONSerialization.jsonObject(with: data, options: .mutableContainers)
}

/*
final class Provider {
    //基础的URL
    var baseUrl: String { return URL_APP_ROOT }
    //请求参数
    var parameters: [AnyHashable : Any]?
    //单例
    static let shareInstance = Provider()
    
    //MARK: 类方法
    /*这里一样设置默认参数，需要时可自己更改，这里会直接将传入的url用来发请求，所以在传入参数时注意
     同时这里一样默认使用get请求，post需要自己传参
     */
    @discardableResult
    static func request(
        _ url: String,
        success: @escaping ([AnyHashable : Any]) -> Void,
        failed: @escaping (Error?) -> Void,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        DebugLogTool.XLPrint(item: url)
          return Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (result) in
            if result.result.isSuccess {
                //如果请求成功则返回字典
                success(result.result.value as! [AnyHashable : Any])
            }//如果失败则返回错误
            else if result.result.isFailure {
                failed(result.result.error)
            }
          }
    }
    //MARK: 实例方法
    private init() {}   //私有初始化方法,防止被外界调用初始化方法
    //这是和上面类方法同名的实例方法，传入的url会自动加到baseUrl上
    func request(
        _ url: String,
        success: @escaping ([AnyHashable : Any]) -> Void,
        failed: @escaping (Error?) -> Void,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        //将传入的url添加到baseUrl上再发请求
        let requestUrl = url + baseUrl
        DebugLogTool.XLPrint(item: requestUrl)
        return Alamofire.request(requestUrl, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (result) in
            if result.result.isSuccess {    //请求成功
                success(result.result.value as! [AnyHashable : Any])
            }
            else if result.result.isFailure {   //请求失败
                failed(result.result.error)
            }
        }
    }
}
 */
