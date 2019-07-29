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
        var photos:Array<Any> = []
        let url = URL.init(string: urlStr)
        //使用SDWebImageDownloader异步下载图片
        SDWebImageDownloader.shared().downloadImage(with: url, options: SDWebImageDownloaderOptions.lowPriority, progress: nil) { (image : UIImage?, data : Data?, error : Error?, finished : Bool?) in
            let imageType = self.contentTypeForImageData(data! as NSData)
            var filePath = (type == .PhotoTypeAd) ? self.adFilePath : self.launchFilePath
            filePath = (filePath as NSString).appendingPathComponent("AdImage_\(num).\(self.contentTypeForImageData(data! as NSData))")
            if (image != nil) {
                //开始存储图片
                photos.append(image as Any)
                if imageType == "gif"{
                    //保存GIF图片
                    let imageData = NSData.init(contentsOf: url!)
                    imageData?.write(toFile: filePath, atomically: true)
                }else{
                    //保存PNG、JPG的图片
                    let imageData = ((imageType == "png") ? UIImagePNGRepresentation(image!) : UIImageJPEGRepresentation(image!, 0))! as NSData
                    
                    imageData.write(toFile: filePath, atomically: true)
                }
                block(photos)
            }
        }
    }
    //MARK: ---从本地取出图片
    func getImages(type:PhotoType) -> Array<Any> {
        var adImages:Array<Any> = []
        let filePath = (type == .PhotoTypeAd) ? self.adFilePath : self.launchFilePath
        //判断文件是否存在
       let fileType = FileManager.default.fileExists(atPath: filePath)
        if !fileType {//图片文件不存在，则返回空数组
            return adImages
        }
        //获取该文件夹下所有的图片名称
        var adImageNames = try?FileManager.default.subpathsOfDirectory(atPath: filePath)
        let adImageNamesType = (adImageNames!.count > 0) ? true : false
        if adImageNamesType {
            for i in 0..<adImageNames!.count {
                let imageFilePath = (filePath as NSString).appendingPathComponent(adImageNames![i])
                let image : UIImage = UIImage.init(contentsOfFile: imageFilePath)!
                adImages.append(image)            }
        }
        return adImages
    }
    //mark: ---获取启动图片的路径
    func getLaunchImageURL() -> String {
        var filePath = self.launchFilePath
        let filePthType = FileManager.default.fileExists(atPath: filePath)
        if !filePthType {
            return ""
        }
        print("沙盒中启动图片路径：\(filePath)")
        //启动图就一张图片
        guard let launchImageNames = try? FileManager.default.subpathsOfDirectory(atPath: filePath) else {return ""}
        filePath = (filePath as NSString).appendingPathComponent(launchImageNames.last!)
        return filePath
    }
    //mark: ---获取广告图片
    func getAdImageURLs() -> Array<Any> {
        let filePath = self.adFilePath
        let  filePathType = FileManager.default.fileExists(atPath: filePath)
        if !filePathType{
            return []
        }
        var adImageUrls:Array<Any> = []
        let adImageNames = try?FileManager.default.subpathsOfDirectory(atPath: filePath)
        for i in 0..<adImageNames!.count{
            let url = (filePath as NSString).appendingPathComponent(adImageNames![i])
            adImageUrls.append(url)
        }
        return adImageUrls
    }
    func contentTypeForImageData(_ data : NSData) -> String {
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
        let filePath : String = self.pathWithDocumentName(documentName: "AdImage")
        return filePath
    }()
    /** 存放启动页图片的文件路径 */
    lazy var launchFilePath : String = {
        let filePath = self.pathWithDocumentName(documentName: "LaunchImage")
        return filePath
    }()
    
    //MARK: ---搜索数据对应的路径
    func pathWithDocumentName(documentName:String) -> String {
        //获取沙盒路径
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectory = paths[0] as NSString
        //拼接文件夹路径
        let path = documentDirectory.appendingPathComponent(documentName)
        //判断文件夹是否存在
        let fileManager = FileManager.default
        if !(fileManager.fileExists(atPath: path)){
            try?fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
}
