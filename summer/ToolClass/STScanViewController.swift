//
//  STScanViewController.swift
//  summer
//
//  Created by 王雨 on 2018/1/8.
//  Copyright © 2018年 FangLin. All rights reserved.
//

import UIKit
import AVFoundation
enum STScanType : Int {
    case STScanTypeQrCode = 0   //二维码
    case STScanTypeBarCode = 1   //条形码
}
typealias scanResultBlock = (_ result : String?, _ error : Error?) -> Void
class STScanViewController : UIViewController {
    fileprivate var device  : AVCaptureDevice?
    fileprivate var input   : AVCaptureDeviceInput?
    fileprivate var output  : AVCaptureMetadataOutput?
    fileprivate var session : AVCaptureSession?
    fileprivate var preview : AVCaptureVideoPreviewLayer?
    fileprivate var scanView : STScanView?
    fileprivate var scanRect : CGRect? //扫描的聚焦区域
    fileprivate var lightBtn : UIButton?//打开闪光灯
    fileprivate var noticeLbl : UILabel?//提示标签
    fileprivate var scanFinish : scanResultBlock?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == .authorized{
            initScanDevice()
        }else if status == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { (granted : Bool) in
                if granted == true {
                    self.initScanDevice()
                }else {
                    print("开启相机权限")
                    return
                }
            }
        }else {
            return
        }
       setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //开始捕捉
        session?.startRunning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //结束捕捉
        session?.stopRunning()
    }
}
extension STScanViewController {
    func scanData(finish : @escaping(_ result : String?, _ error : Error?) -> ()) {
        scanFinish = finish
    }
    func initScanDevice() {
        //初始化设备
        device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        guard let device = device else {return}
        //初始化输入
        input = try? AVCaptureDeviceInput.init(device: device)
        //初始化输出
        output = AVCaptureMetadataOutput.init()
        //设置输出代理，在主线程刷新
        output?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //初始化连接对象
        session = AVCaptureSession.init()
        //设置采集质量
        session?.sessionPreset = AVCaptureSessionPresetHigh
        //将输入输出流对象添加到连接对象
        if session?.canAddInput(input) == true {
            session?.addInput(input)
        }
        if session?.canAddOutput(output) == true {
            session?.addOutput(output)
        }
    
        //设置扫码支持的编码格式
        output?.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code]
        //设置扫描的聚焦区域
        //output?.rectOfInterest = scanRect!
        //output?.rectOfInterest = CGRect(x: 60, y: 200, width: 100, height: 100)
        //图层
        preview = AVCaptureVideoPreviewLayer.init(session: session)
        preview?.frame = UIScreen.main.bounds
        preview?.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.insertSublayer(preview!, at: 0)
    }
    
    func setupUI() {
        drawScanView()
        drawLightBtn()
        drawNoticeLbl()
    }
    
    func drawScanView() {
        scanView = STScanView.init(frame: view.bounds)
        scanView?.scanType = .STScanTypeQrCode
        view.addSubview(scanView!)
    }
    
    func drawLightBtn() {
        lightBtn = UIButton.init(type: .custom)
        lightBtn?.bounds = CGRect(x: 0, y: 0, width: 60, height: 50)
        let lightBtnCenterY : CGFloat = view.center.y + SCREEN_WIDTH * 70 / 320
        lightBtn?.center = CGPoint(x: view.center.x, y: lightBtnCenterY)
        lightBtn?.setImage(UIImage.init(named: "scan_light_normal"), for: .normal)
        lightBtn?.setImage(UIImage.init(named: "scan_light_select"), for: .selected)
        lightBtn?.setTitle("轻触照亮", for: .normal)
        lightBtn?.setTitle("轻触关闭", for: .selected)
        lightBtn?.setTitleColor(UIColor.white, for: .normal)
        lightBtn?.setTitleColor(RGBA(r: 72, g: 178, b: 189, a: 1.0), for: .selected)
        lightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        let imageViewW : CGFloat = (lightBtn?.imageView?.bounds.size.width)!
        let imageViewH : CGFloat = (lightBtn?.imageView?.bounds.size.height)!
        let titleLabelW : CGFloat = (lightBtn?.titleLabel?.bounds.size.width)!
        let titleLabelH : CGFloat = (lightBtn?.titleLabel?.bounds.size.height)!
        lightBtn?.titleEdgeInsets = UIEdgeInsetsMake(imageViewH + 5, -imageViewW, 0, 0)
        lightBtn?.imageEdgeInsets = UIEdgeInsetsMake(0, titleLabelW / 2, titleLabelH + 5, -titleLabelW / 2)
        lightBtn?.addTarget(self, action: #selector(openLight(sender:)), for: .touchUpInside)
        view.addSubview(lightBtn!)
    }
    
    func drawNoticeLbl() {
        noticeLbl = UILabel.init()
        noticeLbl?.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        let noticeLblCenterY : CGFloat = view.center.y + SCREEN_WIDTH/2 - 35
        noticeLbl?.center = CGPoint(x: view.center.x, y: noticeLblCenterY)
        noticeLbl?.text = "将二维码/条码放入框内,即可自动扫描"
        noticeLbl?.textAlignment = .center
        noticeLbl?.textColor = UIColor.white
        noticeLbl?.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(noticeLbl!)
    }
    //MARK:- 闪光灯开启与关闭
    @objc func openLight(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device?.hasFlash)! && (device?.hasTorch)! {
            var torch : AVCaptureTorchMode = (input?.device.torchMode)!
    
            switch torch {
            case .auto:
                return
            case .off:
                torch = .on
            case .on:
                torch = .off
        }
    }
    }
}


extension STScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects.count == 0 {
            print("未识别出二维码")
            return
        }else {
            session?.stopRunning()
            let metadataObject : AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            print("扫码类型是\(metadataObject.type)，内容是\(metadataObject.stringValue)")
            guard let scanFinish = scanFinish else{return}
            scanFinish(metadataObject.stringValue, nil)
           
            if metadataObject.type == AVMetadataObjectTypeQRCode {
                let url = URL.init(string: metadataObject.stringValue)
                let webview = UIWebView.init(frame: UIScreen.main.bounds)
                webview.loadRequest(URLRequest.init(url: url!))
                view.addSubview(webview)
            }
        }
    }
}
