//
//  MainViewController_oc.m
//  summer
//
//  Created by 王雨 on 2018/1/12.
//  Copyright © 2018年 FangLin. All rights reserved.
//

#import "MainViewController_oc.h"
#import "WKWebViewJavascriptBridge.h"
#import "summer-Swift.h"
#import "GlobalFile_oc.h"
#import "MJRefresh.h"

@interface MainViewController_oc ()<WKUIDelegate, WKNavigationDelegate, WebViewJavascriptBridgeBaseDelegate, WKScriptMessageHandler,StartAppDelegate, SettingDelegate, CustemBBI>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIProgressView *progressView;//进度条
@property (nonatomic, strong) UIImageView *errorImageView;
@property (nonatomic, strong) AdViewController *adVC;
@property (nonatomic, strong) SwiftPopMenu *popMenu;//导航栏右边菜单
@property (nonatomic, assign) BOOL isNavHidden;
@property (nonatomic, assign) CGFloat scale;//缩放比例
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isTimer;
@property (nonatomic, strong) CustemNavItem *custemNavItem;
@end

@implementation MainViewController_oc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addWebView];//添加WkWebView
    [self.view addSubview:self.errorImageView];//添加错误视图
    [self addProgressView];//添加ProgressView
    [self loadUrl: URLPATH];//加载网页
    _scale = 1.0;
    //设置别名
    [JPUSHService setAlias:[DisplayUtils uuid] callbackSelector:nil object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = RGBA(72,178,189,1.0);
    if (_isNavHidden) {
        self.navigationController.navigationBarHidden = YES;
        UIView *statusView = [[UIView alloc]init];
        statusView.frame = CGRectMake(0, 0, kScreen_width, 20);
        statusView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:statusView];
    }else {
        self.navigationController.navigationBarHidden = NO;
    }
    //支付成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySucceed:) name:WXPaySuccessNotification object:nil];
    //网络监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getLoadDataBase:) name:KLoadDataBase object:nil];
    //推送
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jpushMessage:) name:JPushMessage object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - 添加webview
- (void)addWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.preferences = [[WKPreferences alloc]init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    //通过js与webview内容交互配置
    config.userContentController = [[WKUserContentController alloc]init];
    //添加一个名称，js通过这个名称发送消息
    [config.userContentController addScriptMessageHandler:self name:@"nativeMethod"];
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) configuration:config];
    
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    _webView.customUserAgent = @"iphone";
    [_webView sizeToFit];
    [self.view addSubview:_webView];
    
//    [_webView loadRequest: [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://192.168.9.154:8020/House/xg_test.html"]]];
//
//    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
//    [_bridge setWebViewDelegate:self];
//    [_bridge registerHandler:@"_app_setTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"******%@", data);
//        responseCallback(@"1323");
//        
//    }];
}
#pragma mark - 添加进度条
- (void)addProgressView {
    _progressView = [[UIProgressView alloc]init];
    _progressView.progressViewStyle = UIProgressViewStyleDefault;
    if (_isNavHidden) {
        _progressView.frame = CGRectMake(0, 20, kScreen_width, 3);
    }else {
        _progressView.frame = CGRectMake(0, 64, kScreen_width, 3);
    }
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.progressTintColor = [UIColor blueColor];
    [self.view addSubview:_progressView];
}
#pragma mark - 加载网页
- (void)loadUrl:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - 监听支付成功
- (void)paySucceed:(NSNotification *)notifi{
    NSString *reult = notifi.userInfo[@"code"];
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"ReturnForApp(%@)",reult] completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        
    }];
}

#pragma mark - 网络监测
- (void)getLoadDataBase:(NSNotification *)notifi {
    NSString *network = notifi.userInfo[@"netType"];
    if ([network isEqualToString:@"NotReachable"] || [network isEqualToString:@"Unknown"]) {
        [DisplayUtils alertControllerDisplayWithStr:@"网络出现异常，请检查网络连接！" viewController:self confirmBlock:^{
            NSLog(@"刷新");
            [self.webView reload];
        } cancelBlock:^{
            NSLog(@"取消");
        }];
    }
}

#pragma mark - 推送
-(void)jpushMessage:(NSNotification *)notifi {
    NSString *msgId = notifi.userInfo[@"msgId"];
    [self loadUrl:[NSString stringWithFormat:@"%@/form/FrmMessages.show?msgId=%@", URL_APP_ROOT, msgId]];
}

#pragma mark - 添加下拉刷新
- (void)addRefreshView {
    NSString *isChangeStr = [UserDefaultsUtils valueWithKeyWithKey:@"ChangeStr"];
    if (!isChangeStr || [isChangeStr isKindOfClass:[NSNull class]]){
        isChangeStr = isRefrushStr;
    }
    
    if ([isChangeStr containsString:self.webView.URL.relativePath]) {
        if (self.webView.scrollView.mj_header) {
            self.webView.scrollView.mj_header.hidden = YES;
        }
    }else {
        self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    }
    [self removeWKWebViewCookies];
}
#pragma mark - 清除缓存
- (void)removeWKWebViewCookies {
    if (@available(iOS 9.0, *)) {
        WKWebsiteDataStore *dataStore = [WKWebsiteDataStore defaultDataStore];
        [dataStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] completionHandler:^(NSArray<WKWebsiteDataRecord *> *records) {
            for (WKWebsiteDataRecord *record in records) {
                //清除本站的cookies
                if ([record.displayName containsString:@"http://192.168.9.133"]) {
                    [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:record.dataTypes forDataRecords:@[record] completionHandler:^{
                        NSLog(@"清除成功%@", record);
                    }];
                }
            }
        }];
    }else { //ios8.0以上使用的方法
       //获取Library目录路径
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)firstObject];
        NSString *cookiesPath = [libraryPath stringByAppendingPathComponent:@"Cookies"];
        [[NSFileManager defaultManager]removeItemAtPath:cookiesPath error:nil];
    }
}

- (void) headerRefresh {
    [self.webView reload];
}

#pragma mark - 结束刷新
- (void)endRefresh {
    if (self.webView.scrollView.mj_header) {
        [self.webView.scrollView.mj_header endRefreshing];
    }
}

#pragma mark - 心跳请求
- (void)Heartbeat {
    NSString *token = [UserDefaultsUtils valueWithKeyWithKey:@"TOKEN"];
    NSString *HeartBear_URL = [NSString stringWithFormat:@"%@/forms/WebDefault.heartbeatCheck?sid=%@", URL_APP_ROOT, token];
    [AFNetworkManager GET:HeartBear_URL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"心跳请求返回数据:%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - KVO监听进度条变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _progressView.alpha = 1.0;
        BOOL animated = _webView.estimatedProgress > _progressView.progress;
        [_progressView setProgress:_webView.estimatedProgress animated:animated];
        if(_webView.estimatedProgress>=1.0) {
            //设置动画效果，动画时间长度为1秒
            [UIView animateWithDuration:1.0 delay:0.01 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [_progressView setProgress:0 animated:NO];
            }];
        }
    }
}

#pragma mark - WKScriptMessageHandler
//js交互回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary *dict = (NSDictionary *)message.body;
    NSString *type = dict[@"classCode"];
    if ([type isEqualToString:@"SetAppliedTitle"]) {
        CGRect frame = self.webView.frame;
        BOOL visibility = [dict[@"visibility"]boolValue];
        if (visibility) {
            self.navigationController.navigationBar.hidden = YES;
            frame.origin.y = -20;
            frame.size.height = kScreen_height + 20;
            self.webView.frame = frame;
        }else {
            self.navigationController.navigationBar.hidden = NO;
            self.webView.frame = frame;
        }
    } else if ([type isEqualToString:@"HeartbeatCheck"]) {
        
        BOOL tag = ([[dict[@"status"]stringValue] isEqualToString:@"0"]) ?NO :YES;
        NSString *token = dict[@"token"];
        [UserDefaultsUtils saveValueWithValue:token key:@"TOKEN"];
        NSInteger time = [dict[@"time"]integerValue];
        time = time * 60;
        if (tag) {
            if (!_isTimer) {
                _isTimer = YES;
                _timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(Heartbeat) userInfo:nil repeats:YES];
            }else {
                if (_isTimer) {
                    _isTimer = NO;
                    [_timer invalidate];
                    _timer = nil;
                }
            }
        }else if([type isEqualToString:@"login"]){
            //自动登录
            NSString *userName = dict[@"u"];
            NSString *pwd = dict[@"p"];
            [UserDefaultsUtils saveValueWithValue:userName key:@"userName"];
            [UserDefaultsUtils saveValueWithValue:pwd key:@"pwd"];
        }else if ([type isEqualToString:@"clearLogin"]) {
            //退出登录
            [UserDefaultsUtils deleteValueWithKeyWithKey:@"userName"];
            [UserDefaultsUtils deleteValueWithKeyWithKey:@"pwd"];
        }else if ([type isEqualToString:@"call"]) {
            //拔打电话
            NSString *title = (NSString *)dict[@"t"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [DisplayUtils dialphoneNumberWithNumber:dict[@"t"]];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else if([type isEqualToString:@"showimage"]) {
        NSString *imageUrl = (NSString *)dict[@"url"];
        PingImageViewController *pinVC = [[PingImageViewController alloc]init];
        pinVC.imageStr = imageUrl;
        [self.navigationController pushViewController:pinVC animated:YES];
    }else if ([type isEqualToString:@"FrmWeChatPay"]) {
        //微信支付
        NSString *appid  = dict[@"appid"];
        [WXApi registerApp:appid];
        PayReq *request = [[PayReq alloc]init];
        request.openID = appid;
        request.nonceStr = dict[@"nonceStr"];
        request.package = @"Sign=WXPay";
        request.partnerId = dict[@"mch_id"];
        request.prepayId = dict[@"prepay_id"];
        request.timeStamp = [dict[@"timestamp"]unsignedIntValue];
        request.sign = dict[@"sign"];
        [WXApi sendReq:request];
    }
}

#pragma mark - WKNavigationDelegate
//网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //是否自动登录
    NSString *userName = [UserDefaultsUtils valueWithKeyWithKey:@"userName"];
    NSString *pwd = [UserDefaultsUtils valueWithKeyWithKey:@"pwd"];
    if (!userName && !pwd) {
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"iosLogin(%@,%@)", userName, pwd] completionHandler:^(id _Nullable item, NSError * _Nullable error) {
            
        }];
    }
        //加载完成后结束刷新
        [self endRefresh];
        //设置下拉刷新
        [self addRefreshView];
        //隐藏错误视图
        self.errorImageView.hidden = YES;
        //设置标题
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(0, 0, 60, 40);
        [titleBtn setTitle:webView.title forState:UIControlStateNormal];
        self.navigationItem.titleView = titleBtn;
        titleBtn.tintColor = [UIColor whiteColor];
        [titleBtn addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
        //判断是否需要返回按钮
        NSString *isMainStr = [UserDefaultsUtils valueWithKeyWithKey:@"MainUrlStr"];
        if (!isMainStr || [isMainStr isKindOfClass:[NSNull class]]) {
            isMainStr = isBackStr;
        }
        if ([isMainStr containsString:(webView.URL.relativePath)] && [webView.URL.absoluteString containsString:URL_APP_ROOT]) {
            self.navigationItem.leftBarButtonItem = nil;
        }else {
            _custemNavItem = [[CustemNavItem alloc]initWithImageWithImage:[UIImage imageNamed:@"ic_nav_back"] infoStr:@"first"];
            _custemNavItem.myDelegate = self;
            self.navigationItem.leftBarButtonItem = _custemNavItem;
        }
        //高度适应
        NSString *isChangeStr = [UserDefaultsUtils valueWithKeyWithKey:@"ChangeStr"];
        if (!isChangeStr || [isChangeStr isKindOfClass:[NSNull class]]) {
            isChangeStr = isRefrushStr;
        }
        if ([isChangeStr containsString:webView.URL.relativePath]) {
            self.navigationItem.rightBarButtonItem = nil;
        }else {
            //设置导航栏按钮
            _custemNavItem = [[CustemNavItem alloc]initWithImageWithImage:[UIImage imageNamed:@"ic_nav_classify"] infoStr:@"third"];
            _custemNavItem.myDelegate = self;
            self.navigationItem.rightBarButtonItem = _custemNavItem;
            NSString *js_fit_code = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.zoom='%f'", self.scale];
            [webView evaluateJavaScript:js_fit_code completionHandler:^(id _Nullable item, NSError * _Nullable error) {
                
            }];
            
        }

    // TODO alipay需要刷新唤起支付宝客户端，临时解决方案，待进一步改进
    if ([webView.URL.relativePath isEqualToString: @"/cashier/mobilepay.htm"]) {
        [self.webView reload];
    }
    if ([webView.URL.relativePath isEqualToString: @"/forms/TFrmWelcome"]) {
        [self addAdVC];
    }
}

#pragma mark - 标题按钮
- (void)titleClick {
    NSArray *dataDict = @[@{@"icon" : @""}, @{@"title" : @"转到首页"}];
    _popMenu = [[SwiftPopMenu alloc]initWithFrame:CGRectMake(kScreen_width/2-75, 51, 150, dataDict.count * 40) arrowMargin:17];
    //数据
    _popMenu.popData = dataDict;
    //点击菜单的回调
    __weak __typeof(self)weakSelf = self;
    _popMenu.didSelectMenuBlock = ^(NSInteger index) {
        [weakSelf.popMenu dismiss];
        shareedMyApp *myApp = [shareedMyApp getInstance];
        NSString *msgUrl = [NSString stringWithFormat:@"%@/%@", URL_APP_ROOT, [UserDefaultsUtils valueWithKeyWithKey:@"msgManage"]];
        if (index == 0) {
            [weakSelf loadUrl:[myApp getFormUrl:@"WebDefault"]];
        }else if (index == 1) {
            [weakSelf loadUrl:[DisplayUtils configUrlWithUrlStr:msgUrl]];
        }else if (index == 2) {
            SettingViewController *settingVC = [[SettingViewController alloc]init];
            settingVC.delegate = weakSelf;
            [weakSelf.navigationController pushViewController:settingVC animated:YES];
        }else if (index == 3) {
            [weakSelf loadUrl:[DisplayUtils configUrlWithUrlStr:BACK_MAIN]];
        }else if (index == 4) {
            [UserDefaultsUtils deleteValueWithKeyWithKey:@"userName"];
            [UserDefaultsUtils deleteValueWithKeyWithKey:@"pwd"];
            [weakSelf.webView evaluateJavaScript:@"exit()" completionHandler:^(id _Nullable item, NSError * _Nullable error) {
                
            }];
            [weakSelf loadUrl:[DisplayUtils configUrlWithUrlStr:EXIT_URL_PATH]];
        }
    };
    [_popMenu show];
}

#pragma mark - 跳转失败的时候调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"跳转失败:%s", __func__);
}

#pragma mark - 服务器请求跳转的时候调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"服务器请求跳转:%s", __func__);
}

#pragma mark - 内容加载失败的时候调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"请求失败的URL：%@", webView.URL.absoluteString);
    BOOL urlBool = [webView.URL.absoluteString containsString:@"FrmPayRequest"];
    BOOL aliBool = [webView.URL.absoluteString containsString:@"mclient.alipay.com/cashier/mobilepay.htm"];
    if (urlBool || aliBool) {
        return;
    }
    [self setNavTitle:@"出错了"];
    self.errorImageView.hidden = NO;
    [DisplayUtils alertControllerDisplayWithStr:@"加载失败，请稍后再试" viewController:self confirmBlock:^{
        NSLog(@"刷新");
        [self.webView reload];
    } cancelBlock:^{
        NSLog(@"取消");
    }];
    
}


#pragma mark - getter
//添加错误视图
- (UIImageView *)errorImageView {
    if (!_errorImageView) {
        _errorImageView = [[UIImageView alloc]init];
        _errorImageView.frame = CGRectMake(0, 64, kScreen_width, kScreen_height-64);
        _errorImageView.image = [UIImage imageNamed:@"error.jpg"];
        _errorImageView.hidden = YES;
    }
    return _errorImageView;
}

//**************************************************************************
#pragma mark - WKUIDelegate代理方法
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
   NSString *orderInfo = [[AlipaySDK defaultService] fetchOrderInfoFromH5PayUrl:webView.URL.absoluteString];
    if (orderInfo == nil && orderInfo.length <= 0) {
        return;
    }
    [[AlipaySDK defaultService] payUrlOrder:orderInfo fromScheme:@"summer" callback:^(NSDictionary *resultDic) {
        NSString *result = resultDic[@"resultCode"];
        if ([result isEqualToString:@"9000"]) {
            NSString *urlStr = resultDic[@"returnUrl"];
            [self loadUrl:urlStr];
        }else{
            if ([self.webView canGoBack]) {
                [self.webView goBack];
            }
        }
    }];
}
#pragma mark - CustemBBI代理方法、SettingDelegate代理方法
//CustemBBI代理方法
- (void)BBIdidClickWithNameWithInfoStr:(NSString *)infoStr {
    if ([infoStr isEqualToString:@"first"]) {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }else{
            [self.webView evaluateJavaScript:@"ReturnBtnClick()" completionHandler:^(id _Nullable item, NSError * _Nullable error) {
                
            }];
        }
    }else if ([infoStr isEqualToString:@"second"]){
        
    }else{
        NSArray *dataDict = @[@{@"icon":@"",@"title":@"设置"},@{@"icon":@"",@"title":@"退出系统"}];
        self.popMenu = [[SwiftPopMenu alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 51, 150, dataDict.count * 40) arrowMargin:17];
        //菜单数据
        self.popMenu.popData = dataDict;
        //点击菜单的回调
        __weak typeof(self)weakSelf = self;
        self.popMenu.didSelectMenuBlock = ^(NSInteger index){
            if (index == 0) {
                SettingViewController *settingVC = [[SettingViewController alloc]init];
                settingVC.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:settingVC animated:YES];
            }else if (index == 1){
                exit(0);
            }else if (index == 2){
                SettingViewController *settingVC = [[SettingViewController alloc]init];
                settingVC.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:settingVC animated:YES];
            }else if (index == 3){
                NSString *urlStr = [DisplayUtils configUrlWithUrlStr:BACK_MAIN];
                [weakSelf loadUrl:urlStr];
            }else if (index == 4){
                [UserDefaultsUtils deleteValueWithKeyWithKey:@"userName"];
                [UserDefaultsUtils deleteValueWithKeyWithKey:@"pwd"];
                [weakSelf.webView evaluateJavaScript:@"exit()" completionHandler:^(id _Nullable item, NSError * _Nullable error) {
                    
                }];
                NSString *exitUrl = [DisplayUtils configUrlWithUrlStr:EXIT_URL_PATH];
                [weakSelf loadUrl:exitUrl];
            }
        };
        [self.popMenu show];
    }
}
//SettingDelegate代理方法
- (void)perverseInfo:(CGFloat)scale{
    self.scale = scale;
    NSString *js_fit_code = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.zoom=%f",scale];
    [self.webView evaluateJavaScript:js_fit_code completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        
    }];
}
#pragma mark - 添加广告页
- (void)addAdVC{
    BOOL isShow = [[NSUserDefaults standardUserDefaults] boolForKey:@"showAdVC"];
    if (isShow) {
        self.adVC = [[AdViewController alloc]init];
        self.adVC.view.frame = self.view.frame;
        [self.adVC.view setIsAccessibilityElement:YES];
        self.adVC.delegate = self;
        [self addChildViewController:self.adVC];
        [self.view addSubview:self.adVC.view];
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showAdVC"];
    }else
    {
        self.navigationController.navigationBar.hidden = NO;
    }
}

#pragma mark - 广告业代理StartAppDelegate
- (void)startApp{
    [self.adVC removeFromParentViewController];
    [UIView animateWithDuration:0.5 animations:^{
        self.adVC.view.alpha = 0;
    }];
    [self.adVC.view removeFromSuperview];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
}

#pragma mark - 设置导航栏的标题
- (void) setNavTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, 60, 44);
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:19];
    self.navigationItem.titleView = label;
}

@end

