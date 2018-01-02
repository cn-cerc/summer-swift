//
//  AdOnlineTool.swift
//  summer
//
//  Created by 箫海岸 on 2018/1/2.
//  Copyright © 2018年 FangLin. All rights reserved.
//

import UIKit

class AdOnlineTool: NSObject {
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
//            fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: [:])
            //fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        }
        return path
    }
}
