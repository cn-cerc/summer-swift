//
//  MainViewController.swift
//  summer
//
//  Created by FangLin on 2/10/17.
//  Copyright © 2017 FangLin. All rights reserved.
//

import UIKit
import WebKit

class MainViewController: BaseViewController {
    
    fileprivate var webView: WKWebView!
    fileprivate var progressView: UIProgressView!//进度条
    fileprivate lazy var adVC : AdViewController = AdViewController()
    
    var popMenu: SwiftPopMenu!//导航栏右边菜单
    
    var isNavHidden = false
    var scale:Float!//缩放比例
    var CLASSCode: String!
    var CallbackStr: String!
    
    var scanVC = STScanViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        //添加WkWebView
        addWebView()
        //添加错误视图
        view.addSubview(self.errorImageView)
        //添加ProgressView
        addProgressView()
        //加载网页
        loadUrl(urlStr: URLPATH)
        
        self.scale = 1.0
        
        //设置别名
        JPUSHService.setAlias(DisplayUtils.uuid(), callbackSelector: nil, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.red
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.barTintColor = RGBA(r: 72, g: 178, b: 189, a: 1.0)
        
        if isNavHidden == true {
            navigationController?.isNavigationBarHidden = true
            let statusBarView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.size.width, height: 20))
            statusBarView.backgroundColor = UIColor.white
            view.addSubview(statusBarView)
        }else{
            navigationController?.isNavigationBarHidden = false
        }
        
        //支付成功
        NotificationCenter.default.addObserver(self, selector: #selector(paySucceed), name: Notification.Name(rawValue:WXPaySuccessNotification), object: nil)
        
        //网络监听
        NotificationCenter.default.addObserver(self, selector: #selector(getLoadDataBase), name: NSNotification.Name(rawValue: KLoadDataBase), object: nil)
        //推送
        NotificationCenter.default.addObserver(self, selector: #selector(jpushMessage), name: NSNotification.Name(rawValue: JPushMessage), object: nil)
    }
    
    //支付成功返回
    func paySucceed(notifi:Notification) {
        let result = notifi.userInfo?["code"]
        self.webView.evaluateJavaScript("ReturnForApp('\(result!)')") {
            (item:Any?, error:Error?) in
        }
    }
    
    //网络监测
    func getLoadDataBase(notifi:Notification) {
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
    func jpushMessage(notifi:Notification) {
        let msgId:String? = notifi.userInfo?["msgId"] as! String?
        self.loadUrl(urlStr: String(format:"%@/form/FrmMessages.show?msgId=%@",URL_APP_ROOT,msgId!))
    }
    
    //添加下拉刷新
    func addRefreshView() {
        var isChangeStr:String
        if UserDefaultsUtils.valueWithKey(key: "ChangeStr").stringValue == nil {
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
    
    func headerRefresh() {
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
        let urlStr = URL.init(string: urlStr)
//        print(URLPATH)
        let request = URLRequest.init(url: urlStr!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30.0)
//        let request = URLRequest.init(url: urlStr!)
        webView.load(request)
    }
    
    //MARK: - 添加wkwebview
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
        
        webView = WKWebView(frame:CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64),configuration:configuretion)
        webView.allowsBackForwardNavigationGestures = false
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        webView?.customUserAgent = "iphone"
        //监听支持KVO的属性
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        //内容自适应
        webView.sizeToFit()
        view.addSubview(webView!)
    }
    
    //添加进度条
    fileprivate func addProgressView() {
        
        progressView = UIProgressView(progressViewStyle: .default)
        if isNavHidden == true{
            progressView.frame = CGRect.init(x: 0, y: 20, width: view.bounds.size.width, height: 3)
        }else{
            progressView.frame = CGRect.init(x: 0, y: 64, width: view.bounds.size.width, height: 3)
        }
        progressView.trackTintColor = UIColor.clear
        progressView.progressTintColor = UIColor.blue
        view.addSubview(progressView!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //        webView.configuration.userContentController.removeScriptMessageHandler(forName: "webViewApp")
        NotificationCenter.default.removeObserver(self)
    }
    
    //KVO监听进度条变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            let animated = Float(webView.estimatedProgress) > progressView.progress;
            
            progressView .setProgress(Float(webView.estimatedProgress), animated: animated)
            
            print(webView.estimatedProgress)
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

//MARK: - JS交互调用方法
extension MainViewController{
    
    func jsCallOcMethod(dict: Dictionary<String, Any>){
        print(URLPATH)
        guard let classCode = dict["classCode"] else {
            return
        }
        
        let callBackStr = (dict["_callback_"] != nil) ?dict["_callback_"] as! String :""
        print("_callback_:\(callBackStr)")
        CallbackStr = callBackStr
        //***********  下面判断需要调用的方法是否存在
        if classCode as! String == "startVine" {
            guard let urlStr = dict["host"] else {return}
            guard let sid = dict["sid"] else{return}
            let userDefault = UserDefaults.standard
            userDefault.set(urlStr, forKey: "newHost")
            userDefault.set(sid, forKey: "TOKEN")
            loadUrl(urlStr: shareedMyApp.getInstance().getFormUrl("WebDefault"))
        }
        if classCode as! String == "ScanBarcode" {
            //扫一扫
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
                            print("***callBackJS错误\(String(describing: error))")
                        }
                    })
                }else{
                    print("_callback_为空")
                }
            })
            return
        }
        //跳转到打卡界面
        if classCode as! String == "clockIn"{
            clockIn(dict: dict, callback: {
                let backStr = self.callBackString(type: true, message: "转到打卡界面成功", callBack: callBackStr)
                self.callBackToJS(message: backStr)
            })
            return
        }
        //js调刷新
        if classCode as! String == "ReloadPage"{
            ReloadPage(dict: dict, callback: {
                let backStr = self.callBackString(type: true, message: "刷新成功", callBack: callBackStr)
                self.callBackToJS(message: backStr)
            })
            return
        }
        
   //*******************  有_callback_值但，没有classCode所传方法的时候调用  ***************************
        let failBackStr = self.callBackString(type: false, message: "没有所要调用的方法", callBack: callBackStr)
        self.callBackToJS(message: failBackStr)
    }
    
  //具体执行的方法
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
            backString = "(new Function('return \( callBack)') ()) ('{\"result\":\(type),\"data\":\(message)}')"
        } else {
            backString = "(new Function('return \( callBack)') ()) ('{\"result\":\(type),\"message\":\(message)}')"
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
            let visibility = dict["visibility"] as! Bool
            if !visibility {
                self.navigationController?.navigationBar.isHidden = true
                Thread.sleep(forTimeInterval: 1.0)
                
                if SCREEN_HEIGHT < 736{
                    self.webView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                }else{
                    self.webView.frame = CGRect.init(x: 0, y: -20, width: SCREEN_WIDTH, height: SCREEN_HEIGHT + 20)
                }
                progressView.frame = CGRect.init(x: 0, y: 20, width: view.bounds.size.width, height: 3)
            }else{
                self.navigationController?.navigationBar.isHidden = false
                self.webView.frame = CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64)
                progressView.frame = CGRect.init(x: 0, y: 64, width: view.bounds.size.width, height: 3)
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
        let url = webView.url!
        let urlStr = "\(url)"
        if urlStr.contains("TFrmWelcome") && (CLASSCode == "SetAppliedTitle") {
            self.navigationController?.navigationBar.isHidden = true
            Thread.sleep(forTimeInterval: 1.0)
            if SCREEN_HEIGHT < 736{
                self.webView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            }else{
                self.webView.frame = CGRect.init(x: 0, y: -20, width: SCREEN_WIDTH, height: SCREEN_HEIGHT + 20)
            }
        
        }
        //是否自动登录
        //方法一
        let userName:String? = UserDefaultsUtils.valueWithKey(key: "userName") as? String
        let pwd:String? = UserDefaultsUtils.valueWithKey(key: "pwd") as? String
        if  userName != nil  && pwd != nil {
            self.webView.evaluateJavaScript("iosLogin(\(userName!),\(pwd!))", completionHandler: { (item:Any?, error:Error?) in
                
            })
        }
        //方法二
        //        let userName = UserDefaultsUtils.valueWithKey(key: "userName")
        //        let pwd = UserDefaultsUtils.valueWithKey(key: "pwd")
        //        if !(userName as! String).isEmpty && !(pwd as! String).isEmpty  {
        //            self.webView.evaluateJavaScript("iosLogin(\(userName as! String),\(pwd as! String))", completionHandler: { (item:Any?, error:Error?) in
        //
        //            })
        //        }
        //加载完成结束刷新
        endRefresh()
        //设置下拉刷新
        addRefreshView()
        
        //隐藏错误视图
        self.errorImageView.isHidden = true
        //设置标题
        let Titlebtn = UIButton(type:.system)
        Titlebtn.setTitle(webView.title!, for: .normal)
        Titlebtn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 40)
        self.navigationItem.titleView = Titlebtn;
        Titlebtn.tintColor = UIColor.white;
        Titlebtn.addTarget(self, action: #selector(titleClick), for: .touchUpInside)
        
        //判断是否需要返回按钮
        var isMainStr:String
        if UserDefaultsUtils.valueWithKey(key: "MainUrlStr").stringValue == nil {
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
        if UserDefaultsUtils.valueWithKey(key: "ChangeStr").stringValue == nil {
            isChangeStr = isRefrushStr
        }else{
            isChangeStr = UserDefaultsUtils.valueWithKey(key: "ChangeStr") as! String
        }
        if isChangeStr.contains((webView.url?.relativePath)!){
            self.navigationItem.rightBarButtonItem = nil
        }else{
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
            addAdVC()
        }
    }
    //标题按钮
    func titleClick() {
        let dataDict = [(icon:"",title:"转到首页")
                    ];
        
        popMenu = SwiftPopMenu(frame:CGRect.init(x: Int(SCREEN_WIDTH/2-75), y: 51, width: 150, height: dataDict.count*40),arrowMargin:17)
        //数据
        popMenu.popData = dataDict
        //点击菜单的回调
        popMenu.didSelectMenuBlock = {[weak self](index:Int)->Void in self?.popMenu.dismiss()
            let myApp = shareedMyApp.getInstance()
            let msgUrl = "\(URL_APP_ROOT)/\(UserDefaultsUtils.valueWithKey(key: "msgManage"))"
           
            print(msgUrl)
            
            if index == 0 {
                self?.loadUrl(urlStr: myApp.getFormUrl("WebDefault"))
            }else if index == 1 {
                self?.loadUrl(urlStr: DisplayUtils.configUrl(urlStr: "\(msgUrl)"))
            }else if index == 2 {
                let settingVC = SettingViewController()
                settingVC.delegate = self
                self?.navigationController?.pushViewController(settingVC, animated: true)
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
            DisplayUtils.alertControllerDisplay(str: "加载失败，请稍后再试", viewController: self, confirmBlock: {
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
        DisplayUtils.alertControllerDisplay(str: "加载失败，请稍后再试", viewController: self, confirmBlock: {
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
            if (self.webView.url?.absoluteString.contains(URL_APP_ROOT))! || !(self.webView.url?.absoluteString.contains(URL_APP_ROOT))! {
                if self.webView.canGoBack {
                    self.webView.goBack()
                }
            }else{
                self.webView.evaluateJavaScript("ReturnBtnClick()", completionHandler: { (item:Any?, error:Error?) in
                    
                })
            }
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
                    print("点击了刷新")
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
            self.navigationController?.navigationBar.isHidden = true
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
        self.navigationController?.navigationBar.isHidden = false
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

