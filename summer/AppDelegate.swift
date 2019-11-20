//
//  AppDelegate.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit
import AVFoundation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate,SDWebImageManagerDelegate {
    
    var window: UIWindow?
    var loginVC : LoginViewController?
    var mainVC: MainViewController?
    var mainNav: BaseNavViewController?
    var adTool : AdOnlineTool? = AdOnlineTool()
    var launchView : UIView?
    var timer:Timer?
    var time : NSInteger = 0
    var isTimer:Bool = false
    var selectServerVC : STSelectServerViewController?
    var selectServerNav : BaseNavViewController?
    fileprivate lazy var addArr:Array<UIImage> = {
        let addArr = Array<UIImage>()
        return addArr
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Bugly.start(withAppId: "9430ce63c1")
        //保存uuid
        if isFirst() == true {
            PDKeyChain.keyChainSave(NSUUID().uuidString)
        }
        //配置信息
//        getImageData()
        //沉睡
//        Thread.sleep(forTimeInterval: 1.2)
        
        self.window = UIWindow(frame:UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.mainVC = MainViewController()
        self.mainNav = BaseNavViewController(rootViewController:self.mainVC!)
        self.window?.rootViewController = mainNav
//        #if DEBUG
        //在调试模式下，弹出手动输入服务器地址
//        self.selectServerVC = STSelectServerViewController()
//        self.selectServerNav = BaseNavViewController(rootViewController: selectServerVC!)
//        self.window?.rootViewController = selectServerNav
//        #else
//        self.mainVC = MainViewController()
//        self.mainNav = BaseNavViewController(rootViewController:mainVC!)
//        self.window?.rootViewController = mainNav
//        #endif
        self.window?.makeKeyAndVisible()
        
        //MARK: - 检测是否有版本更新
        detectionVersion()
        //接收通知
        let NotifyChatMsgRecv = NSNotification.Name(rawValue:"ShowBanner")
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarHiddenNotfi), name: NotifyChatMsgRecv, object: nil)
        let NotifyHeartbeatCheck = NSNotification.Name(rawValue: "HeartbeatCheck")
        NotificationCenter.default.addObserver(self, selector: #selector(heartBeatCheck(notifi:)), name: NotifyHeartbeatCheck, object: nil)
        
        UserDefaultsUtils.saveValue(value: "1.00" as AnyObject, key: "scale")
        
        //判断网络
        monitorNetworkState()
        
        //极光推送
        if #available(iOS 10.0, *){
            let entiity = JPUSHRegisterEntity()
            entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
                UNAuthorizationOptions.badge.rawValue |
                UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entiity, delegate: self)
        } else if #available(iOS 8.0, *) {
            let types = UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
        }else {
            let type = UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
        
        let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        JPUSHService.setup(withOption: launchOptions, appKey: appkey, channel: channel, apsForProduction: isProduction, advertisingIdentifier: advertisingId)
        //设置启动页
//        getLaunchImage()
        
        do {
           try AVAudioSession.sharedInstance().setCategory("AVAudioSessionCategoryPlayback")
        }catch{
            return false
            
        }
         do {
            try AVAudioSession.sharedInstance().setActive(true)
         }catch{
            return false
        }
        return true
    }
    //MARK:--- 设置启动页
    func getLaunchImage(){
        let launchVC = UIStoryboard.init(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "LaunchScreen")
        self.launchView = launchVC.view
        self.launchView?.backgroundColor = UIColor.orange
        let mainWindow = UIApplication.shared.keyWindow
        self.launchView?.frame = (mainWindow?.frame)!
        mainWindow?.addSubview(self.launchView!)
        //启动页图片
        let imgView = UIImageView()
        imgView.frame = (self.launchView?.bounds)!
        launchView?.addSubview(imgView)
        let getImgTool = AdOnlineTool()
        let imgArray = getImgTool.getImages(type: PhotoType.PhotoTypeLaunch)
        if imgArray.count == 0 {
            imgView.image = UIImage.init(named: "LaunchScreen")
        } else {
//            let imgFilePath = Bundle.main.path(forResource: "launchImg", ofType: "gif")
            
            let imgFilePath = AdOnlineTool().getLaunchImageURL()
            let imgData = NSData.init(contentsOfFile: imgFilePath)
            let imgType = getImgTool.contentTypeForImageData(imgData!)
            
            if imgType == "gif"{
                self.gifImageAnimationFilePath(gifImgPath: imgFilePath, imgView: imgView)
            }else{
                imgView.image = imgArray[0] as? UIImage
            }
        }
        
        //当前版本号展示
        let versionLbl = UILabel()
        versionLbl.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 50, width: SCREEN_WIDTH, height: 50)
        versionLbl.backgroundColor = UIColor.clear
        versionLbl.textAlignment = NSTextAlignment.center
        versionLbl.textColor = UIColor.white
        versionLbl.font = UIFont.systemFont(ofSize: 18)
        //获取版本号
        let infoDict = Bundle.main.infoDictionary
        versionLbl.text = "V" + (infoDict?["CFBundleShortVersionString"] as! String)
        self.launchView?.addSubview(versionLbl)
        //启动页显示时间
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(removeLaunchView), userInfo: nil, repeats: false)
    }
    //移除启动页
    @objc func removeLaunchView(){
        self.launchView?.removeFromSuperview()
    }
    //MARK:启动页Gif
    func gifImageAnimationFilePath(gifImgPath : String,imgView : UIImageView){
        //1.获取gif文件数据
        let cfUrl = URL.init(fileURLWithPath: gifImgPath)
        let source = CGImageSourceCreateWithURL(cfUrl as CFURL, nil)
        //2.获取gif文件中图片的个数
        let count = CGImageSourceGetCount(source!)
        var imageArray = [UIImage]()
        //遍历gif
        for i in 0..<count{
            
            let cgimage = CGImageSourceCreateImageAtIndex(source!, i, nil)
            let uiImage = UIImage.init(cgImage: cgimage!)
            imageArray.append(uiImage)
        }
        imgView.animationImages = imageArray
        imgView.animationDuration = 3.0
        imgView.animationRepeatCount = Int(MAXFRAG)
        imgView.startAnimating()
    }
    
    @objc func statusBarHiddenNotfi() {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = false
    }
    
    func monitorNetworkState() {
        let manager = AFNetworkReachabilityManager.shared()
        manager.startMonitoring()
        manager.setReachabilityStatusChange { (status:AFNetworkReachabilityStatus) in
            switch status{
            case .notReachable:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: KLoadDataBase), object: nil, userInfo: ["netType":"NotReachable"])
            case .reachableViaWiFi:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:KLoadDataBase), object: nil, userInfo: ["netType":"WiFi"])
            case .reachableViaWWAN:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:KLoadDataBase), object: nil, userInfo: ["netType":"WWAN"])
            default:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:KLoadDataBase), object: nil, userInfo: ["netType":"Unknown"])
            }
        }
    }
    
    func getImageData() {
        var paremDict:Dictionary<String, Any>?
        //获取版本号
        var infoDict = Bundle.main.infoDictionary
        let appVersion = infoDict?["CFBundleShortVersionString"]
        paremDict = ["curVersion":appVersion as Any,"appCode":"vine-iphone-standard"]
        //检测版本更新
        let URLString = "https://m.yiyoupin.com.cn/elves/FrmIndex_Phone?device=phone"
        AFNetworkManager.get(URLString, parameters: paremDict, success: { (operation:AFHTTPRequestOperation?, responseObject:[AnyHashable : Any]?) in
            printLog(message: "\(String(describing: responseObject))")
            let launchImageUrlStr = responseObject!["startupImage"] as? String
            var launchImageVersion = ""
            var launchUrl = ""
            if (launchImageUrlStr!.count == 0) {
                return
            }
            if launchImageUrlStr!.contains(";") {
                let arr : [String] = launchImageUrlStr!.components(separatedBy: ";")
                launchImageVersion = arr[0]
                launchUrl = arr[1]
            } else{
                launchImageVersion = "0"
                launchUrl = launchImageUrlStr!
            }
            self.checkImageVersion(imageVersion: launchImageVersion, imageUrls: [launchUrl], type: .PhotoTypeLaunch)
            //2.判断广告页图片是否更新、下载
            var adImageVersion = ""
            var adUrl = ""
            var adImageUrls : [String]?
            
            //获取广告图片数据的数组
            guard let adImageUrlStrs = responseObject!["adImages"] as? [String] else{return}
            if(adImageUrlStrs.count == 0) {
                return;
            }
            for adImageUrlStr in adImageUrlStrs {
                if adImageUrlStr.contains(";") {
                    let arr : [String] = adImageUrlStr.components(separatedBy: ";")
                    adImageVersion = arr[0];
                    adUrl = arr[1];
                } else {
                    adImageVersion = "0";
                    adUrl = adImageUrlStr;
                }
                adImageUrls?.append(adUrl)
            }
            self.checkImageVersion(imageVersion: adImageVersion, imageUrls: adImageUrls!, type: .PhotoTypeAd)
            
        
        })  { (operation:AFHTTPRequestOperation?, error:Error?) in
            print(error)
        }
    }
    
    func uploadAddImage(imageArr:Array<String>) {
        UserDefaultsUtils.saveIntValue(value: imageArr.count, key: "addCount")
        let manager = SDWebImageManager.shared()
        manager?.imageCache.removeImage(forKey: "adImage", fromDisk: true)
        for i in 0..<imageArr.count {
            let imageUrl = imageArr[i]
            manager?.delegate = self
            _ = manager?.imageDownloader.downloadImage(with: URL.init(string: imageUrl), options: .continueInBackground, progress: { (receivedSize:Int, expectedSize:Int) in
                
                }, completed: { (image:UIImage?, data:Data?, error:Error?, finished:Bool) in
                    manager?.imageCache.store(image, forKey: String(format:"adImage%d",i), toDisk: true)
            })
        }
    }
    
    func isFirstLauch() -> Bool {
        if  UserDefaultsUtils.boolValueWithKey(key: "everLaunched") == false {
            UserDefaultsUtils.saveBoolValue(value: true, key: "everLaunched")
            UserDefaultsUtils.saveBoolValue(value: true, key: "firstLaunch")
        }else{
            UserDefaultsUtils.saveBoolValue(value: false, key: "firstLaunch")
        }
        return UserDefaultsUtils.boolValueWithKey(key: "firstLaunch")
    }
    
    func isFirst() ->Bool {
        if (PDKeyChain.keyChainLoad() == nil) {
            return true
        }else{
            return false
        }
    }
    //MARK: - 检查启动图片和广告图片的版本并进行下载操作
    func checkImageVersion(imageVersion : String, imageUrls : [String], type : PhotoType) {
        //与之前本地保存作比较
        var lastImageVersion : String?
        if (type == .PhotoTypeAd) {
            lastImageVersion = UserDefaults.standard.object(forKey: "adImageVersion") as? String
        } else{
            lastImageVersion = UserDefaults.standard.object(forKey: "launchImageVersion") as? String
        }
        
        if(lastImageVersion?.count == 0 || lastImageVersion != imageVersion){
            //进行下载操作
            for i in 0..<imageUrls.count {
                adTool?.downloadAdOnlineData(urlStr: imageUrls[i], num: i, type: type, block: { (data : Any) in
                    print("下载启动或广告图片成功")
                    //将最新的版本号保存本地
                    UserDefaults.standard.set(imageVersion, forKey: (type == .PhotoTypeAd) ?"adImageVersion" :"launchImageVersion")
                    if type == .PhotoTypeAd {
                        UserDefaults.standard.set(true, forKey: "showAdVC")
                    }
                })
            }
        }else{
           UserDefaults.standard.set(false, forKey: "showAdVC")
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        var bgTask : UIBackgroundTaskIdentifier?
        
        bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            DispatchQueue.main.async(execute: {
                if bgTask != UIBackgroundTaskInvalid {
                    bgTask = UIBackgroundTaskInvalid
                }
            })
        })
        DispatchQueue.global().async {
            DispatchQueue.main.async(execute: {
                if bgTask != UIBackgroundTaskInvalid {
                    bgTask = UIBackgroundTaskInvalid
                }
            })
        }
        if isTimer{
            print(time)
            print("在这里开启心跳")
            timer?.fireDate = .distantPast
        }else {
            timer?.fireDate = .distantFuture
            timer = nil
            print("结束计时器")
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    //MARK: - 跳转处理
    //低版本中9.0及以下会用到
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("openURL:\(url.absoluteString),\(url.host)")
        
        if url.scheme == WX_APPID {
            return WXApi.handleOpen(url, delegate: self)
        }
        
        //跳转支付宝钱包进行支付，处理支付结果
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (result:[AnyHashable : Any]?) in
                print(result)
            })
        }
        if url.host == "platformapi" {
            AlipaySDK.defaultService().processAuthResult(url) { (resultDic: [AnyHashable : Any]?) in
                print(resultDic)
            }
        }
        return true
    }
    //低版本中9.0会用到
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        print("openURL:\(url.absoluteString),\(url.host)")
        
        if url.scheme == WX_APPID {
            return WXApi.handleOpen(url, delegate: self)
        }
        
        //跳转支付宝钱包进行支付，处理支付结果
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (result:[AnyHashable : Any]?) in
                print(result)
            })
        }
        if url.host == "platformapi" {
            AlipaySDK.defaultService().processAuthResult(url) { (resultDic: [AnyHashable : Any]?) in
                print(resultDic)
            }
        }
        return true
    }
    
    //新的方法
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("openURL:\(url.absoluteString),\(url.host)")
        
        if url.scheme == WX_APPID {
            return WXApi.handleOpen(url, delegate: self)
        }
        
        //跳转支付宝钱包进行支付，处理支付结果
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (result:[AnyHashable : Any]?) in
                print(result)
            })
        }
        if url.host == "platformapi" {
            AlipaySDK.defaultService().processAuthResult(url) { (resultDic: [AnyHashable : Any]?) in
                print(resultDic)
            }
        }
        return true
    }
    //MARK: - 微信支付结果的回调
    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: PayResp.self) {
            var backCode = ""
            switch resp.errCode {
            case 0:
                backCode = "success"
            case -2:
                backCode = "用户取消"
            default:
                backCode = "failed"
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: WXPaySuccessNotification), object: nil, userInfo: ["code":backCode])
        }
    }
    
    //MARK: - 注册APNs成功并上报DeviceToken 极光推送
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    //MARK: -  注册APNs失败接口
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: %@", error);
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
//                application.applicationIconBadgeNumber = 0
//                JPUSHService.resetBadge()
    }
    
}
//MARK: - ****** 极光代理
extension AppDelegate : JPUSHRegisterDelegate{
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        printLog(message: "极光***\(userInfo)")
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        printLog(message: "极光推送\(response)")
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
        //设置角标
        var currentNumber = UIApplication.shared.applicationIconBadgeNumber
        if currentNumber > 0 {
            currentNumber -= 1
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
        
        print(userInfo.keys)
        if userInfo.keys.contains("msgId"){
           NotificationCenter.default.post(name: NSNotification.Name(rawValue:JPushMessage), object: nil, userInfo: ["msgId":userInfo["msgId"]!])
        }
    }
}

extension AppDelegate {
    @objc fileprivate func heartBeatCheck(notifi : Notification) {
        let dict = notifi.userInfo!
        let a = dict["status"] as! NSNumber
        let aString:String = a.stringValue
        var tag : Bool
        if aString == "1" {
            tag = true
        }else {
            tag = false
        }
        let token:String = dict["token"] as! String
        UserDefaultsUtils.saveValue(value: token as AnyObject, key: "TOKEN")
        
        time = dict["time"] as! NSInteger
        time *= 60
        if tag {
            if !isTimer{
                isTimer = true
                print("在这里开启心跳")
                timer = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(Heartbeat), userInfo: nil, repeats: true)
            }
        }else{
            if isTimer{
                isTimer = false
                timer?.invalidate()
                timer = nil
                print("结束计时器")
            }
        }
    }
    
    //MARK: ---心跳请求
    @objc func Heartbeat(){
        let token = UserDefaultsUtils.valueWithKey(key: "TOKEN")
        let HeartBeat_URL = URL_APP_ROOT+"/forms/WebDefault.heartbeatCheck?sid="+(token as! String)
    
        AFNetworkManager.get(HeartBeat_URL, parameters: nil, success: { (operation:AFHTTPRequestOperation?, responseObject:[AnyHashable : Any]?) in
            print("心跳请求返回数据")
            print(responseObject)
            
        })  { (operation:AFHTTPRequestOperation?, error:Error?) in
            print(error)
        }
    }
}



extension AppDelegate{
    //MARK: - 检测版本更新
    func detectionVersion() {
        //获取APP当前版本号
        let infoDict = Bundle.main.infoDictionary
        let appVersion = infoDict!["CFBundleShortVersionString"] as! String
        let rf = RemoteForm.initRemoteForm()
        rf.parametersDict = ["curVersion": appVersion as Any ,"appCode": APPCODE as Any]
        rf.onResult = {(RF) in
            let result = RF.getResult()
            if !result{
                let msg = RF.getMessage()
                MBProgressHUD.show(in: self.window?.rootViewController?.view, message: msg)
                return
            }
            let dataDict = RF.getServerData()
            printLog(message: "更新数据：\(dataDict)")
            //数据逻辑处理
            //获取当前版本号
            let infoDict = Bundle.main.infoDictionary
            let appVersion = infoDict!["CFBundleShortVersionString"] as! String
            //获取服务器数据信息
            let version = dataDict["appVersion"] as! String
            let appUpdateReadme: Array = dataDict["appUpdateReadme"] as! Array <String>
            printLog(message: "更新内容：\(appUpdateReadme)")
            //比对版本号
            if appVersion == version {
                printLog(message: "已是最新版本")
                return
            }
            //是否强制更新
            guard let appUpdateReset: Bool = dataDict["appUpdateReset"] as? Bool else {
                return
            }
            //弹窗提醒
            var massage = ""
            massage = appUpdateReadme[0]
            if massage == "" {
                massage = "优化交互体验及系统运行流畅度"
            }
            self.updateNewVersionApp(url: "", appUpdateReadme: massage,appUpdateReset: appUpdateReset)
            
        }
        let urlString = "https://app.yiyoupin.com.cn/elves/install.client"
        printLog(message: "版本检测URL：" + urlString)
        rf.requestDataFromServer(type: .post, urlString: urlString)
        
        
    }
    //MARK: - *********** 弹窗 *************
    func updateNewVersionApp(url: String,appUpdateReadme: String,appUpdateReset: Bool) {
        
        let alertVC = UIAlertController.init(title: "发现新版本", message: appUpdateReadme, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "下次再说", style: .cancel) { (Action) in
            
        }
        let ok_Action = UIAlertAction.init(title: "立即更新", style: .default) { (Action) in
            let version = getVersion()
            let appCode = "&appCode=" + APPCODE
            let parameter = "curVersion=" + version + appCode
            let urlString = Myapp.getFormParameters(Server: SERVER, formCode: "install.update", Parameters: parameter)
            let Url = URL.init(string: urlString)
            UIApplication.shared.open(Url!, options: ["":""], completionHandler: nil)
        }
        let exit_Action = UIAlertAction.init(title: "退出", style: .default) { (action) in
            exit(0)
        }
        if appUpdateReset{
            alertVC.addAction(exit_Action)
            alertVC.addAction(ok_Action)
        }else{
            alertVC.addAction(cancel)
            alertVC.addAction(ok_Action)
        }
        
        window?.rootViewController?.present(alertVC, animated: true, completion: nil)
        
    }
}


