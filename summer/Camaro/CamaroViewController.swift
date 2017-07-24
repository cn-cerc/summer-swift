//
//  CamaroViewController.swift
//  summer
//
//  Created by cts on 2017/7/24.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit
//import MobileCoreServices
import AssetsLibrary
//定义了一个媒体类型的枚举摄像、拍照、选择照片
enum MediaType {
    case video, camaro, photo
}
class CamaroViewController: UIViewController {
    //如果需要结果可以设置一个匿名函数来获得返回获得结果
    var result: ((Any) -> Void)?
    
    fileprivate let pickerVC = UIImagePickerController()
    fileprivate var mediaType: MediaType = .photo   //默认是选择照片
    //重载父类的初始化方法,需传入一个媒体类型的枚举，不传则默认是选择照片
    init(mediaType: MediaType = .photo) {
        super.init(nibName: nil, bundle: nil)
        self.mediaType = mediaType
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configMedia()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - privateFunction
    //根据媒体类型的枚举来对UIImagePickerController进行配置
    private func configMedia() {
        switch mediaType {
        case .photo:
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                DebugLogTool.XLPrintWithDescription(item: "设备不支持图片库")
                return
            }
            pickerVC.sourceType = .photoLibrary
        case .camaro:
            pickerVC.sourceType = .camera
            pickerVC.cameraCaptureMode = .photo
            //设置闪光灯模式为自动模式
            pickerVC.cameraFlashMode = .auto
        case .video:
            //设置源类型是摄像头还是图片库或相册
            pickerVC.sourceType = .camera
            //设置媒体类型为视频，有声音的类型
            pickerVC.mediaTypes = [String(kUTTypeMovie)]
            //设置录像品质为高
            pickerVC.videoQuality = .typeHigh
            //设置视频最多录制10s
            pickerVC.videoMaximumDuration = 10
        }
        //完成后是否允许编辑,这里不允许
        pickerVC.allowsEditing = true
        //设置代理
        pickerVC.delegate = self
        self.present(pickerVC, animated: false, completion: nil)
    }
    //选择照片模式下选择完成的回调方法
    fileprivate func photoMediaCallBack(info: [String : Any]) {
        //获取选中的图片
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        /*
         //这里可以保存图片到沙盒
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage.jpg"
        let imageData = UIImageJPEGRepresentation(pickedImage, 1.0)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
         */
        
        sendResult(something: pickedImage)
    }
    //拍照模式下选择完成的回调方法
    fileprivate func camaroMediaCallback(info: [String : Any]) {
        /* 拍照的照片，系统不会自动保存拍照成功后的照片，需要手动保存到本地。
        //这是原始尺寸的照片
        let originalImg = info[UIImagePickerControllerOriginalImage]
        //这是剪裁后的图片(在允许编辑模式下才有)
        let editedImg = info[UIImagePickerControllerEditedImage]
        //这是剪裁后剩下的图片
        let cropImg = info[UIImagePickerControllerCropRect]
        //这是图片的url
        let imgUrl = info[UIImagePickerControllerMediaURL]
        //这是图片的metadata数据信息
        let imgMetadata = info[UIImagePickerControllerMediaMetadata]
        */

        let picture = info[UIImagePickerControllerOriginalImage] as! UIImage
        sendResult(something: picture)
    }
    //录制视频模式下选择完成的回调方法
    fileprivate func videoMediaCallback(info: [String : Any]) {
        let url = info[UIImagePickerControllerMediaURL] as! URL
        let urlStr = url.path
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr) {
            //UISaveVideoAtPathToSavedPhotosAlbum(urlStr, nil, nil, nil)
            //保存到相册
            ALAssetsLibrary().writeVideoAtPath(toSavedPhotosAlbum: url, completionBlock: { (url, error) in
                if let err = error {
                    DebugLogTool.XLPrintWithFuncOnLine(item: err)
                } else {
                    DebugLogTool.XLPrint(item: "保存视频到相册成功!")
                }
            })
        }
        sendResult(something: url)
    }
    //返回结果
    private func sendResult(something: Any) {
        if let result = self.result {
            result(something)
        }
    }

}
//MARK: - UIImagePickerControllerDelegate
extension CamaroViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        switch mediaType {
        case .photo:
            photoMediaCallBack(info: info)
        case .camaro:
            camaroMediaCallback(info: info)
        case .video:
            videoMediaCallback(info: info)
        }
        self.pickerVC.dismiss(animated: true) { 
            self.dismiss(animated: false, completion: nil)
        }
    }
    //取消按钮的回调
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerVC.dismiss(animated: true) {
            self.dismiss(animated: false, completion: nil)
        }
    }
}


