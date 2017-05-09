//
//  HelpViewController.swift
//  summer
//
//  Created by FangLin on 2017/5/4.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: BaseViewController {

    fileprivate var webView: WKWebView!
    fileprivate var progressView: UIProgressView!//进度条
    
    var isNavHidden = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        self.setNavTitle(title: "帮助")
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWithImage(image: UIImage.init(named: "ic_nav_back")!, target: self as CustemBBI, infoStr: "first")
        //添加WkWebView
        addWebView()
        //加载网页
//        loadUrl(urlStr: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HelpViewController{
    
    //加载url
    fileprivate func loadUrl(urlStr:String) {
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
        configuretion.allowsInlineMediaPlayback = true
        
        //默认是不能通过js自动打开窗口的，必须通过用户交互才能打开
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false;
        //通过js与webview内容交互配置
        configuretion.userContentController = WKUserContentController()
        
        webView = WKWebView(frame:CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64),configuration:configuretion)
        webView.allowsBackForwardNavigationGestures = true
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        //内容自适应
        webView.sizeToFit()
        view.addSubview(webView!)
    }
}

extension HelpViewController:WKNavigationDelegate{
    //网页加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
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
        DisplayUtils.alertControllerDisplay(str: "加载失败，请稍后再试", viewController: self, confirmBlock: {
            print("刷新")
            self.webView.reload()
        },cancelBlock: {
            print("取消")
        })
    }
}

extension HelpViewController:WKUIDelegate{
    //出现白屏时加载视图
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}

extension HelpViewController:CustemBBI {
    func BBIdidClickWithName(infoStr: String) {
        if infoStr == "first" {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
