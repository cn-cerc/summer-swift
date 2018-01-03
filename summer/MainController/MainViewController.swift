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
    fileprivate var adVC : AdViewController!
    
    var popMenu: SwiftPopMenu!//导航栏右边菜单
    
    var isNavHidden = false
    var scale:Float!//缩放比例
    var timer:Timer?
    var isTimer:Bool = false
    
    
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
        removeWKWebViewCookies()
    }
    
    //清除缓存
    func removeWKWebViewCookies(){
        if #available(iOS 9.0, *) {
            let dataStore = WKWebsiteDataStore.default()
            dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), completionHandler: { (records) in
                for record in records{
                    //清除本站的cookie
                    if record.displayName.contains("http://192.168.9.133"){//这个判断注释掉的话是清理所有的cookie
                        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                            //清除成功
                            print("清除成功\(record)")
                        })
                    }
                }
            })
        } else {
            //ios8.0以上使用的方法
            let libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let cookiesPath = libraryPath! + "/Cookies"
            try!FileManager.default.removeItem(atPath: cookiesPath)
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
    
    //懒加载
    fileprivate lazy var errorImageView:UIImageView = {
        let errorImageView = UIImageView(frame:CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
        errorImageView.image = UIImage(named:"error.jpg")
        errorImageView.isHidden = true
        return errorImageView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController{
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
    //加载url
    func loadUrl(urlStr:String) {
        let urlStr = URL.init(string: urlStr)
        print(URLPATH)
        let request = URLRequest.init(url: urlStr!)
        webView.load(request)
    }
    
    //添加wkwebview
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
        webView.allowsBackForwardNavigationGestures = true
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


extension MainViewController: WKScriptMessageHandler {
    //MARK: --- js交互回调
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        let type = (message.body as! Dictionary<String,String>)["type"]
        print(message.body)
        guard let dict = message.body as? [String : Any] else{return}
        print(dict["classCode"] as Any)
        let type:String = dict["classCode"] as! String
        print("type"+type)
        
        if type == "SetAppliedTitle" {
            var Frame = self.webView.frame
            let visibility:Bool = (dict["visibility"] != nil)
            if visibility {
                self.navigationController?.navigationBar.isHidden = true
                Frame.origin.y = -20
                Frame.size.height = SCREEN_HEIGHT + 20;
                self.webView.frame = Frame
            }else{
                self.navigationController?.navigationBar.isHidden = false
                self.webView.frame = Frame
            }
        }else if type == "HeartbeatCheck"{
            let a = dict["status"] as! NSNumber
            let aString:String = a.stringValue
            var tag : Bool
            if aString == "1" {
                tag = true
            }else {
                tag = false
            }
//
            let token:String = dict["token"] as! String
            UserDefaultsUtils.saveValue(value: token as AnyObject, key: "TOKEN")
            
            var time:NSInteger = dict["time"] as! NSInteger
                time *= 10
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
        }
//        else if type == "scan" {//扫描卡号
//            let scanVC = ScanViewController()
//            scanVC.delegate = self
//            self.navigationController?.pushViewController(scanVC, animated: true)
//        }else if type == "scanPay" {//二维码扫描
//            let sqVC = lhScanQCodeViewController()
//            sqVC.delegate = self
//            let navVC = UINavigationController.init(rootViewController: sqVC)
//            self.present(navVC, animated: true, completion: nil)
//        }
        else if type == "FrmWeChatPay"{//微信支付
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
        }
    }
}

extension MainViewController: WKNavigationDelegate{
    //网页加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
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
        print(webView.url?.relativePath)
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
    
    //内容加载失败的时候调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(#function)
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
        let orderInfo = AlipaySDK.defaultService().fetchOrderInfo(fromH5PayUrl: webView.url?.absoluteString)
        if orderInfo != nil && (orderInfo?.characters.count)! > 0 {
            AlipaySDK.defaultService().payUrlOrder(orderInfo, fromScheme: "alipay", callback: { (result:[AnyHashable : Any]?) in
                if result?["resultCode"] as! String == "9000"{
                    let urlStr = result?["returnUrl"]
                    self.loadUrl(urlStr: urlStr as! String)
                }else{
                    if self.webView.canGoBack {
                        self.webView.goBack()
                    }
                }
            })
        }
    }
}

//导航栏按钮
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
                    exit(0)
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
            self.navigationController?.navigationBar.isHidden = false
            
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
