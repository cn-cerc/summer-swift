//
//  MainViewController.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation


class MainViewController: BaseViewController {
    
    fileprivate var webView: WKWebView!
    fileprivate var progressView: UIProgressView!//进度条
    fileprivate lazy var adVC : AdViewController = AdViewController()
    
    var popMenu: SwiftPopMenu!//导航栏右边菜单
    
    var isNavHidden = false
    var scale:Float!//缩放比例
    var CLASSCode: String!
    var CallbackStr: String!
    var isNewHost = true
    var newWebView: WKWebView!
    var WebArray = [WKWebView]()
    var webTag = 0
    var titleArray = [String]()
    var titleDataDict = [(icon:String,title:String)]()
    var Titlebtn: UIButton?
    var navTitle: String?
    var Hud: MBProgressHUD!
    
    var scanVC = STScanViewController()
    lazy var lineView: UIView = {
        let LV = UIView.init(frame: CGRect(x: 0, y: 36, width: 150, height: 2))
        LV.backgroundColor = RGBA(r: 38, g: 38, b: 38, a: 1.0)
        return LV
    }()
    
    var isRepeat = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
//***********************  添加启动时的视频播放   *************************
        
//        weak var weakSelf = self
        let playView = TJAVplayerView()
        playView.isNoUI = true
        playView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.view.addSubview(playView)
        let moviePath = Bundle.main.path(forResource: "startVideo", ofType: "mp4")
        playView.settingPlayerItem(with: URL.init(fileURLWithPath: moviePath!))
        playView.overBlock = {[weak self] (type : String?)->() in
            
                DispatchQueue.main.async {
                    if !self!.isRepeat{
                        playView.removeSelf()
//                    添加WkWebView
                    
                        self!.addWebView()
                    //添加错误视图
                        self!.view.addSubview(self!.errorImageView)
                    //添加ProgressView
                        self!.addProgressView()
                    //MARK: - 加载网页
//                            loadUrl(urlStr: serverURL)
                    
                        self!.loadUrl(urlStr: URLPATH)
                        self!.isRepeat = true
                    }
            
                }

        } 
        
        
        
        
//***********************************************************
        
        
        
        self.scale = 1.0
        
        //设置别名
        JPUSHService.setAlias(DisplayUtils.uuid(), callbackSelector: nil, object: nil)
        UserDefaultsUtils.saveStringValue(value: "", key: "testNum")
        addSlideGsture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        //支付成功
        NotificationCenter.default.addObserver(self, selector: #selector(paySucceed), name: Notification.Name(rawValue:WXPaySuccessNotification), object: nil)
        
        //网络监听
        NotificationCenter.default.addObserver(self, selector: #selector(getLoadDataBase), name: NSNotification.Name(rawValue: KLoadDataBase), object: nil)
        //推送
        NotificationCenter.default.addObserver(self, selector: #selector(jpushMessage), name: NSNotification.Name(rawValue: JPushMessage), object: nil)
    }
    
    //支付成功返回
    @objc func paySucceed(notifi:Notification) {
        let result = notifi.userInfo?["code"]
        self.webView.evaluateJavaScript("ReturnForApp('\(result!)')") {
            (item:Any?, error:Error?) in
        }
    }
    
    //网络监测
    @objc func getLoadDataBase(notifi:Notification) {
        let netWork:String? = notifi.userInfo?["netType"] as! String?
        if netWork! == "NotReachable" || netWork! == "Unknown" {
            DisplayUtils.alertControllerDisplay(str: "网络出现异常，请检查网络连接！", viewController: self, confirmBlock: {
                print("刷新")
                self.webView.reload()
                },cancelBlock: {
                    print("取消")
            })
        }
        //        self.webView.reload()
    }
    
    //推送
    @objc func jpushMessage(notifi:Notification) {
        let msgId:String? = notifi.userInfo?["msgId"] as! String?
        self.loadUrl(urlStr: String(format:"%@/forms/FrmMessages.show?msgId=%@",URL_APP_ROOT,msgId!))
    }
    
    //添加下拉刷新
    func addRefreshView() {
        var isChangeStr:String
        if UserDefaultsUtils.valueWithKey(key: "ChangeStr") as? String == nil {
            isChangeStr = isRefrushStr
        }else{
            isChangeStr = UserDefaultsUtils.valueWithKey(key: "ChangeStr") as! String
        }
        if isChangeStr.contains((self.webView.url?.relativePath)!) {
            if self.webView.scrollView.mj_header == nil {
                
            }else{
                self.webView.scrollView.mj_header.isHidden = true
            }
        }else{
            self.webView.scrollView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        }
    }
    
    @objc func headerRefresh() {
        self.webView.reload()
    }
    
    //结束刷新
    func endRefresh() {
        if self.webView.scrollView.mj_header == nil {
            
        }else{
            self.webView.scrollView.mj_header.endRefreshing()
        }
    }
    
    //MARK: - 懒加载
    fileprivate lazy var errorImageView:UIView = {
        let errorImageView = UIView(frame:CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
        errorImageView.backgroundColor = UIColor.white
//        errorImageView.image = UIImage(named:"error.jpg")
        let X = SCREEN_WIDTH/4
        let Y = (SCREEN_HEIGHT - 64)/4
        let W = SCREEN_WIDTH/2
        let H = W
        let ImgView = UIImageView(frame: CGRect(x: X, y: Y, width: W, height: H))
        ImgView.image = UIImage(named: "webError.jpg")
        errorImageView.addSubview(ImgView)
        let fram = ImgView.frame
        let labY = fram.maxY + 20
        let label = UILabel(frame: CGRect(x: 0, y: labY, width: SCREEN_WIDTH, height: 20))
        label.textAlignment = NSTextAlignment.center
        label.text =  "Hi~,真不巧，网页走丢了"
        errorImageView.addSubview(label)
        errorImageView.isHidden = true
        return errorImageView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

extension MainViewController{
   
    //加载url
    func loadUrl(urlStr:String) {
        let urlString = URL.init(string: urlStr)
        printLog(message: "******>>>>>\(urlString)")
        let request = URLRequest.init(url: urlString!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30.0)
//        let request = URLRequest.init(url: urlStr!)
        webView.load(request)
    }
    
    //MARK: - ***** 添加wkwebview
    fileprivate func addWebView() {
        //创建webview
        //创建一个webview的配置项
        let configuretion = WKWebViewConfiguration()
        //webview的偏好设置
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = 10;
        configuretion.preferences.javaScriptEnabled = true
        //默认是不能通过js自动打开窗口的，必须通过用户交互才能打开
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false;
        //通过js与webview内容交互配置
        configuretion.userContentController = WKUserContentController()
        //添加一个名称，js通过这个名称发送消息
        configuretion.userContentController.add(self, name: "nativeMethod")
        
        webView = WKWebView(frame:CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT),configuration:configuretion)
        webView.allowsBackForwardNavigationGestures = false
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        webView?.customUserAgent = "iphone,iPhone"
        //监听支持KVO的属性
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        //内容自适应
        webView.sizeToFit()
        webView.tag = webTag
        view.addSubview(webView!)
        webTag += 1
        WebArray.append(webView)
        Hud = MBProgressHUD.show(in: view, message: "内容加载中")
        printLog(message: "当前webView个数：\(WebArray.count)")
    }
    
    //添加进度条
    fileprivate func addProgressView() {
        
        progressView = UIProgressView(progressViewStyle: .default)
        if isNavHidden == true{
            progressView.frame = CGRect.init(x: 0, y: 20, width: view.bounds.size.width, height: 3)
        }else{
            progressView.frame = CGRect.init(x: 0, y: 20, width: view.bounds.size.width, height: 3)
        }
        progressView.trackTintColor = UIColor.clear
        progressView.progressTintColor = UIColor.blue
        view.addSubview(progressView!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //KVO监听进度条变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            let animated = Float(webView.estimatedProgress) > progressView.progress;
            
            progressView .setProgress(Float(webView.estimatedProgress), animated: animated)
            
            printLog(message:webView.estimatedProgress)
            self.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
            if Float(webView.estimatedProgress) >= 1.0{
                
                //设置动画效果，动画时间长度 1 秒。
                UIView.animate(withDuration: 1, delay:0.01,options:UIViewAnimationOptions.curveEaseOut, animations:{()-> Void in
                    
                    self.progressView.alpha = 0.0
                    
                    },completion:{(finished:Bool) -> Void in
                        
                        self.progressView .setProgress(0.0, animated: false)
                })
            }
        }
    }
}

//MARK: - ***********  JS交互调用方法 ***********
extension MainViewController{
    
    func jsCallOcMethod(dict: Dictionary<String, Any>){
        printLog(message: "JS内容json:\(dict)")
        guard let classCode = dict["classCode"] else {
            return
        }
        
        var callBackStr = (dict["_callback_"] != nil) ?dict["_callback_"] as! String :""
        callBackStr = callBackStr.components(separatedBy: .newlines).joined(separator: "")
        print("_callback_:\(callBackStr)")
        CallbackStr = callBackStr
        //***********  下面判断需要调用的方法是否存在
        if classCode as! String == "startVine" {
            guard let urlStr = dict["host"] else {return}
            guard let sid = dict["sid"] else{return}
            let userDefault = UserDefaults.standard
            userDefault.set(urlStr, forKey: "newHost")
            userDefault.set(sid, forKey: "TOKEN")
            if isNewHost {
                printLog(message: "****" + URL_APP_ROOT)
                loadUrl(urlStr: shareedMyApp.getInstance().getFormUrl("WebDefault"))
                isNewHost = false
            }else{
                printLog(message: "\(URL_APP_ROOT)")
            }
            return
        }
        if classCode as! String == "ScanBarcode" {
            //MARK: - /***** 扫一扫
            scan(dict: dict, callback: { (result : String?) in
                var backStr: String
//                let boo = result?.isEmpty
                if result != nil{
                    backStr = self.callBackString(type: true, message: result!, callBack: callBackStr)
                }else{
                    backStr = self.callBackString(type: false, message: result!, callBack: callBackStr)
                }
                print("*******" + backStr)
                if callBackStr != "" {
                    self.webView.evaluateJavaScript(backStr, completionHandler: { (item: Any?, error:Error?) in
                        if error != nil{
                            print("callBackJS错误\(String(describing: error))")
                        }
                    })
                }else{
                    print("_callback_为空")
                }
            })
            return
        }
        //MARK: - /***** 跳转到打卡界面
        if classCode as! String == "clockIn"{
            clockIn(dict: dict, callback: {
                let backStr = self.callBackString(type: true, message: "转到打卡界面成功", callBack: callBackStr)
                self.callBackToJS(message: backStr)
            })
            return
        }
        //MARK: - /*****AR地图
        if classCode as! String == "ArLocation" {
            ArLocation(dict: dict) {
                let backStr = self.callBackString(type: true, message: "转到AR地图成功", callBack: callBackStr)
                self.callBackToJS(message: backStr)
            }
            return;
        }
        //MARK: - /*****
        if classCode as! String == "ArGame" {
            ArGame(dict: dict) {
                let backStr = self.callBackString(type: true, message: "转到AR游戏成功", callBack: callBackStr)
                self.callBackToJS(message: backStr)
            }
            return
        }
        //MARK: - /***** js调刷新
        if classCode as! String == "ReloadPage"{
            ReloadPage(dict: dict, callback: {
                let backStr = self.callBackString(type: true, message: "刷新成功", callBack: callBackStr)
                self.callBackToJS(message: backStr)
            })
            return
        }
        //MARK: - /***** 创建窗口
        if classCode as! String == "newWindow"{
            newWindow(dict: dict, callback: {
                printLog(message: "***** CJ ")
            })
            return
        }
        
        //MARK: - /***** 关闭窗口
        if classCode as! String == "closeWindow"{
            closeWindow(dict: dict, callback: {
                printLog(message: "***** CLOSE")
            })
           return
        }
        //MARK: - /***** 上传图片文件
        if classCode as! String == "UploadImgField" {
            UploadImgField()
            return
        }
   //*******************  有_callback_值但没有classCode所传方法的时候调用  ***************************
        let failBackStr = self.callBackString(type: false, message: "没有所要调用的方法", callBack: callBackStr)
        self.callBackToJS(message: failBackStr)
    }
    
  //MARK: - 具体执行的方法
    
    //MARK: - AR地图
    func ArLocation(dict:Dictionary<String, Any>,callback:@escaping()->()){
        let vc = ARSearchViewController()
        self.present(vc, animated: true, completion: nil)
        callback()
    }
    
    //MARK: - AR游戏
    func ArGame(dict:Dictionary<String, Any>,callback:@escaping()->()){
        let vc = ARSpiritViewController()
        self.present(vc, animated: true, completion: nil)
        callback()
    }
    //MARK: - 扫一扫（二维码/条形码）
    func scan(dict:Dictionary<String, Any>,callback:@escaping(_ result : String?)->()){
        if dict.keys.contains("_callback_"){
            
        }else
        {
            MBProgressHUD.showText("该版本暂不支持此功能")
            return
        }
        scanVC.scanData(finish: { (result : String?, error : Error?) in
            print(result!)
            callback(result)
            self.dismiss(animated: true, completion: nil)
        })
        present(scanVC, animated: true, completion: nil)
    }
  
    //MARK: - 外勤打卡
    func clockIn(dict:Dictionary<String, Any>,callback:@escaping()->()){
        let clockVC = HAFieldClockController()
        clockVC.delegate = self
        self.navigationController?.pushViewController(clockVC, animated: true)
        callback()
    }
    //MARK: - JS调用刷新
    func ReloadPage(dict: Dictionary<String, Any>,callback: @escaping()->()){
        //?device=iphone&CLIENTID=\(DisplayUtils.uuid())
        var currentUrlStr = try? String.init(contentsOf: self.webView.url!)
        if (currentUrlStr?.contains("?"))! {
            currentUrlStr = currentUrlStr! + "&device=iphone&CLIENTID=\(DisplayUtils.uuid())"
        }else{
            currentUrlStr = currentUrlStr! + "?device=iphone&CLIENTID=\(DisplayUtils.uuid())"
        }
        print("重刷新的URL\(String(describing: currentUrlStr))")
        loadUrl(urlStr: currentUrlStr!)
        callback()
    }
    //MARK: - 创建窗口
    func newWindow(dict: Dictionary<String, Any>,callback: @escaping()->()) {
        printLog(message: "创建窗口")
        //新建窗口
        if self.WebArray.count >= 5{
            MBProgressHUD.showText("已达最大窗口数量")
            return
        }
        let myApp = shareedMyApp.getInstance()
        self.navTitle = self.webView.title
        self.addWebView()
        guard var urlString: String = dict["url"] as? String else{return}
        if urlString == "" {
            urlString = "WebDefault"
        }
        self.loadUrl(urlStr: myApp.getFormUrl(urlString))
        callback()
    }
    //MARK: - 关闭窗口
    func closeWindow(dict: Dictionary<String,Any>,callback: @escaping()->()) {
        printLog(message: "关闭窗口")
        self.removeWebView(Tag: self.webView.tag)
        callback()
    }
 //返回给服务器的字符串
    /// 返回给服务器的信息函数
    ///
    /// - Parameters:
    ///   - type: 是否调用成功，true成功，false失败
    ///   - message: 传递的参数
    ///   - callBack: 服务器返回来_callback_
    /// - Returns: 返回给服务器的信息
    func callBackString(type: Bool,message: String,callBack:String) -> String {
        var backString: String
        if type {
            backString = "(new Function('return \( callBack)') ()) ('{\"result\":\(type),\"data\":\"\(message)\"}')"
        } else {
            backString = "(new Function('return \( callBack)') ()) ('{\"result\":\(type),\"message\":\"\(message)\"}')"
        }
        
        return backString
    }
    //返回信息给JS
    func callBackToJS(message: String){
        self.webView.evaluateJavaScript(message, completionHandler: { (item: Any?, error:Error?) in
            if error != nil{
                print("***callBackJS错误\(String(describing: error))")
            }
        })
        
    }
    //MARK: - 刷新清除缓存
    func removeWKWebViewCookies(){
        if #available(iOS 9.0, *) {
            let websiteDataTypes : Set<String> = ["WKWebsiteDataTypeDiskCache","WKWebsiteDataTypeMemoryCache"]
            let dateFrom = Date.init(timeIntervalSince1970: 0)
            let dataStore = WKWebsiteDataStore.default()
            dataStore.removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom, completionHandler: {
                MBProgressHUD.showText("刷新成功")
            })
        } else {
            let libraryPath = (NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first)! as NSString
            
            let cookiesPath = libraryPath.appendingPathComponent("Cookies")
            try? FileManager.default.removeItem(atPath: cookiesPath)
        }
    }
}

extension MainViewController: WKScriptMessageHandler {
    //MARK: --- js交互回调userContentController
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        guard let dict = message.body as? [String : Any] else{return}
        print(dict["classCode"] as Any)
        if dict.keys.contains("classCode") {
            
        }else{
            return
        }
        let type:String = dict["classCode"] as! String
        print("type"+type)
        if type == ""{
            return
        }
        CLASSCode = type
        if type == "SetAppliedTitle" {
            return
            let visibility = dict["visibility"] as! Bool
            if !visibility {
                self.navigationController?.navigationBar.isHidden = true
                Thread.sleep(forTimeInterval: 1.0)
                self.webView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                progressView.frame = CGRect.init(x: 0, y: 20, width: view.bounds.size.width, height: 3)
            }else{
                self.navigationController?.navigationBar.isHidden = false
                self.webView.frame = CGRect.init(x: 0, y: navHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - navHeight)
                progressView.frame = CGRect.init(x: 0, y: navHeight, width: view.bounds.size.width, height: 3)
            }
        }else if type == "HeartbeatCheck"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HeartbeatCheck"), object: nil, userInfo: dict)
        }else if type == "login" {//自动登录
            let u = (message.body as! Dictionary<String,String>)["u"]! as String
            let p = (message.body as! Dictionary<String,String>)["p"]! as String
            UserDefaultsUtils.saveValue(value: u as AnyObject, key: "userName")
            UserDefaultsUtils.saveValue(value: p as AnyObject, key: "pwd")
        }else if type == "clearLogin" {//退出登录
            UserDefaultsUtils.deleteValueWithKey(key: "userName")
            UserDefaultsUtils.deleteValueWithKey(key: "pwd")
        }else if type == "call" {//拨打电话
            let alertController = UIAlertController.init(title: (message.body as! Dictionary<String,String>)["t"], message: nil, preferredStyle: .alert)
            let alertAction1 = UIAlertAction.init(title: "取消", style: .cancel) { (action:UIAlertAction) in
                
            }
            let alertAction2 = UIAlertAction.init(title: "确定", style: .default) { (action:UIAlertAction) in
                DisplayUtils.dialphoneNumber(number: (message.body as! Dictionary<String,String>)["t"]!)
            }
            alertController.addAction(alertAction1)
            alertController.addAction(alertAction2)
            self.present(alertController, animated: true, completion: nil)
        }else if type == "showimage" {//
            let imageUrl = (message.body as! Dictionary<String,String>)["url"]
            let pinVC = PingImageViewController()
            pinVC.imageStr = imageUrl
            self.navigationController?.pushViewController(pinVC, animated: true)
        }else if type == "FrmWeChatPay"{//微信支付
            WXApi.registerApp((message.body as! Dictionary<String,String>)["appid"])
            let request = PayReq()
            request.openID = (message.body as! Dictionary<String,String>)["appid"]
            request.nonceStr = (message.body as! Dictionary<String,String>)["nonce_str"]
            request.package = "Sign=WXPay"
            request.partnerId = (message.body as! Dictionary<String,String>)["mch_id"]
            request.prepayId = (message.body as! Dictionary<String,String>)["prepay_id"]
            request.timeStamp = UInt32((message.body as! Dictionary<String,String>)["timestamp"]!)!
            request.sign = (message.body as! Dictionary<String,String>)["sign"]
            WXApi.send(request)
        }else if type == "voice" {
            
            UserDefaultsUtils.saveStringValue(value: "15202406", key: "testNum")
            
        }else{
            
        // ************************* 新增方法调用  ******************************
            jsCallOcMethod(dict: dict)
        }
    }
}

extension MainViewController: WKNavigationDelegate{
    //MARK: - 网页加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        errorImageView.isHidden = true
        Hud.hide(true)
        let url = webView.url!
        printLog(message: "加载的URL:\(url)")
        let urlStr = "\(url)"
        if urlStr.contains("TFrmWelcome") && (CLASSCode == "SetAppliedTitle") {
//            self.navigationController?.navigationBar.isHidden = true
            Thread.sleep(forTimeInterval: 1.0)
                self.webView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        
        }
        //是否自动登录
        //方法一
        let userName:String? = UserDefaultsUtils.valueWithKey(key: "userName") as? String
        let pwd:String? = UserDefaultsUtils.valueWithKey(key: "pwd") as? String
        if  userName != nil  && pwd != nil {
            self.webView.evaluateJavaScript("iosLogin(\(userName!),\(pwd!))", completionHandler: { (item:Any?, error:Error?) in
                
            })
        }
        //加载完成结束刷新
        endRefresh()
        //设置下拉刷新
        addRefreshView()
        
        //隐藏错误视图
        self.errorImageView.isHidden = true
        //设置标题
        Titlebtn = UIButton(type:.system)
        Titlebtn?.setTitle(webView.title!, for: .normal)
        Titlebtn?.frame = CGRect.init(x: 0, y: 0, width: 90, height: 40)
        self.navigationItem.titleView = Titlebtn;
        Titlebtn?.tintColor = UIColor.white;
        Titlebtn?.addTarget(self, action: #selector(titleClick), for: .touchUpInside)
        
        //判断是否需要返回按钮
        var isMainStr:String
        if UserDefaultsUtils.valueWithKey(key: "MainUrlStr") as? String == nil {
            isMainStr = isBackStr
        }else{
            isMainStr = UserDefaultsUtils.valueWithKey(key: "MainUrlStr") as! String
        }
        if isMainStr.contains((webView.url?.relativePath)!) && (webView.url?.absoluteString.contains(URL_APP_ROOT))! {
            self.navigationItem.leftBarButtonItem = nil
        }else{
            self.navigationItem.leftBarButtonItem = CustemNavItem.initWithImage(image: UIImage.init(named: "ic_nav_back")!, target: self as CustemBBI, infoStr: "first")
        }
        //高度自适应
        var isChangeStr:String
        if UserDefaultsUtils.valueWithKey(key: "ChangeStr") as? String == nil {
            isChangeStr = isRefrushStr
        }else{
            isChangeStr = UserDefaultsUtils.valueWithKey(key: "ChangeStr") as! String
        }
        if isChangeStr.contains((webView.url?.relativePath)!){
            self.navigationItem.rightBarButtonItem = nil
        }else{
//            return
            //设置导航栏按钮
            self.navigationItem.rightBarButtonItem = CustemNavItem.initWithImage(image: UIImage.init(named: "ic_nav_classify")!, target: self as CustemBBI, infoStr: "third")
            let js_fit_code = "document.getElementsByTagName('body')[0].style.zoom= '\(self.scale!)'"
            webView .evaluateJavaScript(js_fit_code, completionHandler: { (item:Any?, error:Error?) in
                
            })
        }
        // TODO alipay需要刷新唤起支付宝客户端，临时解决方案，待进一步改进
        if webView.url?.relativePath == "/cashier/mobilepay.htm" {
            self.webView.reload()
        }
        if webView.url?.relativePath == "/forms/TFrmWelcome" {

        }
    }
    //MARK: - **** 标题按钮
    @objc func titleClick() {
        titlePopuViewData()
        popMenu = SwiftPopMenu(frame:CGRect.init(x: Int(SCREEN_WIDTH/2-75), y: 51, width: 150, height: titleDataDict.count*40),arrowMargin:17)
        //数据
        popMenu.popData = titleDataDict
        popMenu.tableView.addSubview(lineView)
        //点击菜单的回调
        popMenu.didSelectMenuBlock = {[weak self](index:Int)->Void in self?.popMenu.dismiss()
            let myApp = shareedMyApp.getInstance()
            let msgUrl = "\(URL_APP_ROOT)/\(UserDefaultsUtils.valueWithKey(key: "msgManage"))"
           
            print(msgUrl)
            
            if index == 0 {//回到首页
                self?.loadUrl(urlStr: myApp.getFormUrl("WebDefault"))
            }else if index == 1 {//新建窗口
                //新建窗口
                if self!.WebArray.count >= 5{
                    MBProgressHUD.showText("已达最大窗口数量")
                    return
                }
                self?.navTitle = self?.webView.title
                 self?.addWebView()
                self?.loadUrl(urlStr: myApp.getFormUrl("WebDefault"))
                
            }else if index == 2 {//关闭窗口
                printLog(message: "第\(String(describing: self?.webView.tag))个webView")
                self?.removeWebView(Tag: (self?.webView.tag)!)
            }else {
                if self!.WebArray.count <= 1{
                    return
                }
                self?.navTitle = self?.webView.title
                self?.webView = self?.WebArray[index - 3]
                self?.view.bringSubview(toFront: (self?.webView)!)
                self?.Titlebtn?.setTitle(self?.webView.title, for: .normal)
                
                let indexNum = (self?.WebArray.count)! - (index - 3)
                for indx in 1..<indexNum{
                    self?.WebArray.swapAt(index - 3,(self?.WebArray.count)! - indx)
                }
            
            }
        }
        popMenu.show()

    }
    //跳转失败的时候调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }
    
    //服务器请求跳转的时候调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    //MARK:---内容加载失败的时候调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(#function)
        guard let webUrl = webView.url else {
            self.setNavTitle(title: "出错了")
            errorImageView.isHidden = false
            DisplayUtils.alertControllerDisplay(str: "网络连接失败，请检查网络连接", viewController: self, confirmBlock: {
                print("刷新")
                self.webView.reload()
            },cancelBlock: {
                print("取消")
            })
            return
        }
        print("请求失败的URL)" + (webUrl.absoluteString))
        let urlBool = webView.url?.absoluteString.contains("FrmPayRequest")
        let aliBool = webView.url?.absoluteString.contains("mclient.alipay.com/cashier/mobilepay.htm")
        if aliBool! || urlBool!{
            return
        }
        self.setNavTitle(title: "出错了")
        self.errorImageView.isHidden = false
        DisplayUtils.alertControllerDisplay(str: "网络连接失败，请检查网络连接", viewController: self, confirmBlock: {
            print("刷新")
            self.webView.reload()
            },cancelBlock: {
                print("取消")
        })
    }
}

//出现白屏时刷新页面
extension MainViewController: WKUIDelegate{
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        removeWKWebViewCookies()
        let orderInfo = AlipaySDK.defaultService().fetchOrderInfo(fromH5PayUrl: webView.url?.absoluteString)
        if orderInfo != nil && (orderInfo?.characters.count)! > 0 {
            AlipaySDK.defaultService().payUrlOrder(orderInfo, fromScheme: "summer", callback: { (result:[AnyHashable : Any]?) in
                if result?["resultCode"] as! String == "9000"{
                    let urlStr = result?["returnUrl"]
                    print("urlStr\(String(describing: urlStr))")
                    self.loadUrl(urlStr: urlStr as! String)
                }else{
                    if self.webView.canGoBack {
                        self.webView.goBack()
                    }
                }
            })
        }
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        let requstURL = navigationAction.request.url?.absoluteString
        printLog(message: "标签连接：" + requstURL!)
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        
        return nil
    }
//MARK: - 修复不能调起支付宝支付的BUG
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlString = navigationAction.request.url?.absoluteString
        if (urlString?.hasPrefix("alipays://"))! || (urlString?.hasPrefix("alipay://"))! {
            let alipayURL = URL.init(string: urlString!)!
            UIApplication.shared.open(alipayURL, options: [UIApplicationOpenURLOptionUniversalLinksOnly : false]) { (success : Bool) in
                print("~~~ aliPay ~~~~")
                webView.reload()
            }
        
            
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
//    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
//        print("runJavaScriptConfirmPanelWithMessage")
//        completionHandler(true)
//    }
    
   
//    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//
//        let alertVC = UIAlertController.init(title: "***提示***", message: message, preferredStyle: .alert)
//        let alerAction = UIAlertAction.init(title: "确定", style: .cancel) { (action: UIAlertAction) in
//            completionHandler()
//        }
//
//        alertVC.addAction(alerAction)
//
//        self.present(alertVC, animated: true, completion: nil)
//    }
    
}

//MARK: - 导航栏按钮
extension MainViewController:CustemBBI,SettingDelegate{
    //CustemBBI代理方法
    func BBIdidClickWithName(infoStr: String) {
        if infoStr == "first" {
                self.webView.evaluateJavaScript("ReturnBtnClick()", completionHandler: { (item:Any?, error:Error?) in
                    if error != nil{
                        if self.webView.canGoBack {
                            self.webView.goBack()
                        }else{
                            self.removeWebView(Tag: self.webView.tag)
                        }
                    }
                })
//            }
        }else if infoStr == "second" {
            
        }else{
            let dataDict = [(icon:"",title:"设置"),
                            (icon:"",title:"刷新"),
                            (icon:"",title:"退出系统")
                            ]
            
            popMenu = SwiftPopMenu(frame:CGRect.init(x: Int(SCREEN_WIDTH-155), y: 51, width: 150, height: dataDict.count*40),arrowMargin:17)
            //数据
            popMenu.popData = dataDict
            //点击菜单的回调
            popMenu.didSelectMenuBlock = {[weak self](index:Int)->Void in self?.popMenu.dismiss()
                
                let msgUrl = "\(URL_APP_ROOT)/\(UserDefaultsUtils.valueWithKey(key: "msgManage"))"
                print(msgUrl)
                if index == 0 {
                    let settingVC = SettingViewController()
                    settingVC.delegate = self
                    self?.navigationController?.pushViewController(settingVC, animated: true)
                }else if index == 1 {
//                    exit(0)
                    self?.removeWKWebViewCookies()
                    printLog(message: "点击了刷新")
                }else if index == 2 {
                    exit(0)
                }else if index == 3 {
                    self?.loadUrl(urlStr: DisplayUtils.configUrl(urlStr: BACK_MAIN))
                }else if index == 4 {
                    UserDefaultsUtils.deleteValueWithKey(key: "userName")
                    UserDefaultsUtils.deleteValueWithKey(key: "pwd")
                    self?.webView.evaluateJavaScript("exit()", completionHandler: { (item:Any?, error:Error?) in
                        
                    })
                    self?.loadUrl(urlStr: DisplayUtils.configUrl(urlStr: EXIT_URL_PATH))
                }
            }
            popMenu.show()
        }
    }
    //SettingDelegate代理方法
    func perverseInfo(scale: Float) {
        self.scale = scale
        let js_fit_code = "document.getElementsByTagName('body')[0].style.zoom= '\(scale)'"
        self.webView.evaluateJavaScript(js_fit_code, completionHandler: { (item:Any?, error:Error?) in
            
        })
    }
}

//extension MainViewController:ScanViewControllerProtocol {
//    func scanCardReturn(_ urlStr: String!) {
//        let strUrl = urlStr.replacingOccurrences(of: "\n", with: "")
//        let js_fit_code = String(format:"scanCall('%@')",strUrl)
//        self.webView.evaluateJavaScript(js_fit_code) { (item:Any?, error:Error?) in
//            
//        }
//    }
//    
//    func backBar() {
//        self.webView.reload()
//    }
//}
//
//extension MainViewController:lhScanQCodeViewControllerProtocol {
//    func scanCodeReturn(_ urlStr: String!) {
//        let js_fit_code = String(format:"appRichScan('%@')",urlStr)
//        self.webView.evaluateJavaScript(js_fit_code) { (item:Any?, error:Error?) in
//            
//        }
//    }
//}
//MARK: - 广告界面
extension MainViewController {
    func addAdVC() {
        //判断是否显示广告界面
        let isShow = UserDefaults.standard.bool(forKey: "showAdVC")
        if isShow {
            adVC.view.frame = view.frame
            adVC.view.isUserInteractionEnabled = true
            adVC.delegate = self
            addChildViewController(adVC)
            view.addSubview(adVC.view)
//            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            UserDefaults.standard.set(false, forKey: "showAdVC")
        } else{
//            self.navigationController?.navigationBar.isHidden = false
            
        }
        
    }
}
extension MainViewController :StartAppDelegate {
    func startApp() {
        //广告页面消失
        adVC.removeFromParentViewController()
        UIView.animate(withDuration: 0.5) {
            self.adVC.view.alpha = 0
        }
        adVC.view.removeFromSuperview()
//        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
    }
}
//MARK: - HAFieldClockControllerDelegate
extension MainViewController: HAFieldClockControllerDelegate{
    func toClockRecordInterface() {
        let Myapp = shareedMyApp.init()
        let urlString = Myapp.getFormUrl("FrmAttendance.attendance")
        loadUrl(urlStr: urlString)
    }
}
//MARK: - ***** 多窗口的相关方法
extension MainViewController{
    func removeWebView(Tag: Int) {
        if WebArray.count <= 1 {
            MBProgressHUD.showText("唯一窗口，不能被关闭！！请新建窗口后再关闭或退出应用")
            return
        }
        for var web: WKWebView in WebArray {
            if web.tag == Tag{
                UIView.animate(withDuration: 1.0, animations: {
                    web.frame.size.height = SCREENHEIGHT/2
                    web.alpha = 0.0
                }, completion: { (finished) in
                    if #available(iOS 11.0, *){
                        web.removeFromSuperview()
                    }else{
                        printLog(message: "ios10*****")
                        web.frame.size.height = 0
                    }
                    let lastIndex = self.WebArray.count - 1
                    self.WebArray.remove(at: lastIndex)
                    self.webView = self.WebArray.last
                    self.Titlebtn?.setTitle(self.webView.title, for: .normal)
                })
                
            }
        }
    }
    func titlePopuViewData()  {
        if WebArray.count > 1 {
            titleDataDict = [(icon:"",title:"转到首页"),
                             (icon:"",title:"新建窗口"),
                             (icon:"",title:"关闭窗口")
            ];
            lineView.frame.origin.y = 113
        }else{
            titleDataDict = [(icon:"",title:"转到首页"),
                             (icon:"",title:"新建窗口")
            ];
            lineView.frame.origin.y = 73
        }
        for web: WKWebView in WebArray {
            printLog(message: web.title)
            let title = (icon: "",title: web.title)
            titleDataDict.append(title as! (icon: String, title: String))
        }
    }
    
}

//MARK: - 上传图片文件
extension MainViewController{
    func UploadImgField() {
        
    let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
    let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
        printLog(message: "点击了取消")
    }
    let photo = UIAlertAction.init(title: "相册", style: .default) { (action) in
        printLog(message: "相册")
        self.openCameraPhoto(sourceType: .photoLibrary)
    }
    let camera = UIAlertAction.init(title: "相机", style: .default) { (action) in
        printLog(message: "相机")
        self.openCameraPhoto(sourceType: .camera)
    }
    let file = UIAlertAction.init(title: "文件", style: .default) { (action) in
        printLog(message: "文件")
    }
    alertVC.addAction(cancel)
    alertVC.addAction(camera)
    alertVC.addAction(photo)
//    alertVC.addAction(file)
    
    self.present(alertVC, animated: true, completion: nil)
    
    }
    
    func openCameraPhoto(sourceType: UIImagePickerControllerSourceType) {
        
        let isAvailable = UIImagePickerController.isSourceTypeAvailable(sourceType)
        if  isAvailable {
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = sourceType
            self.present(pickerVC, animated: true) {
                printLog(message: "选取相片成功")
            }
        }else{
            printLog(message: "打不开")
        }
    }
    func UploadImgFieldAction(image: UIImage) {
        let Hud = MBProgressHUD.show(in: view, message: "上传中")
        let Myapp = shareedMyApp.init()
        let urlString = Myapp.getFormUrl("FrmCusFollowUp.uploadFile")
        let imgData = UIImageJPEGRepresentation(image, 0.00001)
        let paramet = ["":""]
        AFNetworkManager.post(urlString, parameters: paramet, formData: { (formData: AFMultipartFormData?) in
            let fileManager = FileManager.default
            var path =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
            try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            path = path + "/image.jpg"
            if  fileManager.createFile(atPath: path, contents: imgData, attributes: nil){
                let fileURL = URL.init(fileURLWithPath: path)
                try? formData?.appendPart(withFileURL: fileURL, name: "followup")
            }
        } , success: { (operation : AFHTTPRequestOperation?, responseObject : [AnyHashable: Any]?) in
            Hud?.hide(true)
            
            print("上传图片成功\(String(describing: responseObject))")
            guard var result = responseObject?["result"] as? Bool else{
                return;
            }
            if result{
                MBProgressHUD.showText("上传成功！")
                self.navigationController?.popViewController(animated: true)
                self.webView.reload()
            }else{
                MBProgressHUD.showText("\(String(describing: responseObject!["message"]))")
            }
        } ) { (operation: AFHTTPRequestOperation?, error: Error?) in
            Hud?.hide(true)
            MBProgressHUD.showText("上传失败")
        }
    }
}

extension MainViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let Img = info[UIImagePickerControllerOriginalImage] as! UIImage
        UploadImgFieldAction(image: Img)
        picker.dismiss(animated: true) {
            printLog(message: "选好图片，退出")
        }
    }
}
//MARK: - 添加左右滑动手势
extension MainViewController{
    func addSlideGsture() {
        let leftSlide = UISwipeGestureRecognizer.init(target: self, action: #selector(leftSlideAction))
        leftSlide.direction = .left
        view.addGestureRecognizer(leftSlide)
        let rightSlide = UISwipeGestureRecognizer.init(target: self, action: #selector(rightSlideAction))
        rightSlide.direction = .right
        view.addGestureRecognizer(rightSlide)
    }
    
    @objc func leftSlideAction() {
        printLog(message: "左滑")
    }
    @objc func rightSlideAction() {
        printLog(message: "右滑")
    }
    
}
