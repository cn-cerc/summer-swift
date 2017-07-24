//
//  AppDelegate.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate,SDWebImageManagerDelegate {
    
    var window: UIWindow?
    var mainVC: MainViewController?
    var mainNav: BaseNavViewController?
    
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
//        Thread.sleep(forTimeInterval: 1.2)
        
        //let testVC = CamaroViewController(mediaType: .camaro)
        
        
        self.window = UIWindow(frame:UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.mainVC = MainViewController()
        self.mainNav = BaseNavViewController(rootViewController:mainVC!)
        //self.mainNav = BaseNavViewController(rootViewController:CamaroViewController(mediaType: .photo))
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
            LaunchIntroductionView.shared(withImages: array, buttonImage: "login", buttonFrame: CGRect.init(x: SCREEN_WIDTH-SCREEN_WIDTH/4, y: 20, width: SCREEN_WIDTH/4-10, height: 20), withisBanner: false)
        }else{
            if self.addArr.count == 0 {
                UIApplication.shared.statusBarStyle = .lightContent
                UIApplication.shared.isStatusBarHidden = false
            }else{
                LaunchIntroductionView.shared(withImages: self.addArr, buttonImage: "login", buttonFrame: CGRect.init(x: SCREEN_WIDTH-SCREEN_WIDTH/4, y: 20, width: SCREEN_WIDTH/4-10, height: 20), withisBanner: true)
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
        return true
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
        
        //发送网络请求
        provider.request(.UrlPathConfig(nil)) { (result) in
            switch result {
            case .success(let response):
                self.realRequestData(result:response.data.toJson() as? [String : Any])
            case .failure(let error):
                DebugLogTool.XLPrintWithDescription(item: error)
            }
        }
/*
        Alamofire.request(URLPATH_CONFIG).responseJSON { (result) in
            result.result.ifSuccess {
                if let response = (result.value as? [AnyHashable : Any]) {
                    UserDefaultsUtils.saveStringValue(value: response["rootSite"] as! String, key: "rootSite")
                    UserDefaultsUtils.saveStringValue(value: response["msgManage"] as! String, key: "msgManage")
                    let imageArr = response["adImages"] as! [String]
                    self.uploadAddImage(imageArr: imageArr)
                }
            }
        }
*/
    }
    //处理网络请求结果
    func realRequestData(result: [String : Any]?) {
        guard let resultDic = result else {
            return
        }
        //let str = resultDic["adImages"] as! String
        UserDefaultsUtils.saveStringValue(value: resultDic["rootSite"] as! String, key: "rootSite")
        UserDefaultsUtils.saveStringValue(value: resultDic["msgManage"] as! String, key: "msgManage")
        let imageArr = resultDic["adImages"] as! [String]
        self.uploadAddImage(imageArr: imageArr)
    }
    
    func uploadAddImage(imageArr:Array<String>) {
        UserDefaultsUtils.saveIntValue(value: imageArr.count, key: "addCount")
        let manager = SDWebImageManager.shared()
        manager?.imageCache.removeImage(forKey: "adImage", fromDisk: true)
        for i in 0..<imageArr.count {
            let imageUrl = imageArr[i]
            manager?.delegate = self
            _ = manager?.imageDownloader.downloadImage(with: URL.init(string: imageUrl), options: .continueInBackground, progress: { (receivedSize:Int, expectedSize:Int) in
                
            }, completed: { (image, data, error, finished) in
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
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
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


