//
//  AdOnlineTool.swift
//  summer
//
//  Created by 箫海岸 on 2018/1/2.
//  Copyright © 2018年 FangLin. All rights reserved.
//

import UIKit

enum PhotoType:Int {
    case PhotoTypeLaunch = 0
    case PhotoTypeAd = 1
}

class AdOnlineTool: NSObject {
    
    //MARK: --- 下载图片到本地
    func downloadAdOnlineData(urlStr : String,num : Int,type : PhotoType, block:@escaping(_ data : Any)->()){
        var photos:Array<Any>?
        let url = URL.init(string: urlStr)
        //使用SDWebImageDownloader异步下载图片
        SDWebImageDownloader.shared().downloadImage(with: url, options: SDWebImageDownloaderOptions.lowPriority, progress: nil) { (image : UIImage?, data : Data?, error : Error?, finished : Bool?) in
            let imageType = self.contentTypeForImageData(data as! NSData)
            var filePath = (type == .PhotoTypeAd) ? self.adFilePath : self.launchFilePath
            filePath = filePath + "AdImage_\(num)\(self.contentTypeForImageData(data as! NSData))"
            if (image != nil) {
                //开始存储
//                photos.ad
            }
            
            
        }
    }
    func contentTypeForImageData(_ data:NSData) -> String {
        var c : UInt = 0
        data.getBytes(&c, length: 1)
        switch c {
        case 0xFF:
            return "jpg"
        case 0x89:
            return "png"
        case 0x47:
            return "gif"
        default:
            return ""
        }
    }
    
    //MARK: ---懒加载
    /** 存放广告页图片的文件路径 */
    lazy var adFilePath: String = {
        let filePath:String = self.pathWithDocumentName(documentName: "AdImage")
        return filePath
    }()
    /** 存放启动页图片的文件路径 */
    lazy var launchFilePath: String = {
        let filePath = self.pathWithDocumentName(documentName: "LaunchImage")
        return filePath
    }()
    
    //MARK: ---搜索数据对应的路径
    func pathWithDocumentName(documentName:String) -> String {
        //获取沙盒路径
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectory:String = paths[0] as String
        //拼接文件夹路径
        let path = documentDirectory+documentName
        //判断文件夹是否存在
        let fileManager = FileManager.default
        if !(fileManager.fileExists(atPath: path)){
            try?fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
}
