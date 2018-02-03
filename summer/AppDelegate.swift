//
//  AppDelegate.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate,SDWebImageManagerDelegate {
    
    var window: UIWindow?
    var mainVC: MainViewController?
    var mainNav: BaseNavViewController?
    var adTool : AdOnlineTool? = AdOnlineTool()
    var launchView : UIView?
    
    fileprivate lazy var addArr:Array<UIImage> = {
        let addArr = Array<UIImage>()
        return addArr
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //保存uuid
        if isFirst() == true {
            PDKeyChain.keyChainSave(NSUUID().uuidString)
        }
        //配置信息
        getImageData()
        //沉睡
        Thread.sleep(forTimeInterval: 1.2)
        
        self.window = UIWindow(frame:UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.mainVC = MainViewController()
        self.mainNav = BaseNavViewController(rootViewController:mainVC!)
        self.window?.rootViewController = mainNav
        self.window?.makeKeyAndVisible()
        
        //接收通知
        let NotifyChatMsgRecv = NSNotification.Name(rawValue:"ShowBanner")
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarHiddenNotfi), name: NotifyChatMsgRecv, object: nil)
        
        /*
         * #pragma 欢迎页
         */
        for i in 0..<UserDefaultsUtils.intValueWithKey(key: "addCount") {
            let manager = SDWebImageManager()
            let image1 = manager.imageCache.imageFromDiskCache(forKey: String(format:"adImage%d",i))
            print(image1)
            if (image1 != nil) {
                self.addArr.append(image1!)
            }
        }
        if isFirstLauch() == true {
            var array = Array<UIImage>()
            for i in 0..<WELCOME_IMAGES_COUNT {
                let image = UIImage.init(named: String(format:"welcome%d",i+1))
                array.append(image!)
            }
            //LaunchIntroductionView.shared(withImages: array, buttonImage: "login", buttonFrame: CGRect.init(x: SCREEN_WIDTH-SCREEN_WIDTH/4, y: 20, width: SCREEN_WIDTH/4-10, height: 20), withisBanner: false)
        }else{
            if self.addArr.count == 0 {
                UIApplication.shared.statusBarStyle = .lightContent
                UIApplication.shared.isStatusBarHidden = false
            }else{
               // LaunchIntroductionView.shared(withImages: self.addArr, buttonImage: "login", buttonFrame: CGRect.init(x: SCREEN_WIDTH-SCREEN_WIDTH/4, y: 20, width: SCREEN_WIDTH/4-10, height: 20), withisBanner: true)
            }
        }
        
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
        getLaunchImage()
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
            imgView.image = UIImage.init(named: "启动页")
        } else {
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
    func removeLaunchView(){
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
        imgView.animationRepeatCount = Int(MAXFLOAT)
        imgView.startAnimating()
    }
    
    func statusBarHiddenNotfi() {
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
        AFNetworkManager.get(URLPATH_CONFIG, parameters: paremDict, success: { (operation:AFHTTPRequestOperation?, responseObject:[AnyHashable : Any]?) in
            print(responseObject as! [String : Any])
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
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
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
    
    //极光推送
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: %@", error);
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        //        application.applicationIconBadgeNumber = 0
        //        JPUSHService.resetBadge()
    }
    
}

extension AppDelegate : JPUSHRegisterDelegate{
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter willPresent");
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter didReceive");
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
        UIApplication.shared.applicationIconBadgeNumber = currentNumber
        JPUSHService.setBadge(currentNumber)
        
        print(userInfo.keys)
        if userInfo.keys.contains("msgId"){
           NotificationCenter.default.post(name: NSNotification.Name(rawValue:JPushMessage), object: nil, userInfo: ["msgId":userInfo["msgId"]!])
        }
    }
}
