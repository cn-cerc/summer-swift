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
@interface MainViewController_oc ()<WKUIDelegate, WKNavigationDelegate, WebViewJavascriptBridgeBaseDelegate, WKScriptMessageHandler>
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySucceed) name:WXPaySuccessNotification object:nil];
    //网络监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getLoadDataBase) name:KLoadDataBase object:nil];
    //推送
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jpushMessage) name:JPushMessage object:nil];
    
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
    
    _webView = [[WKWebView alloc]init];
    _webView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    _webView.customUserAgent = @"iphone";
    [_webView sizeToFit];
    [self.view addSubview:_webView];
    
    [_webView loadRequest: [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://192.168.9.154:8020/House/xg_test.html"]]];
    //[_webView loadRequest: [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    [_bridge registerHandler:@"_app_setTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"******%@", data);
        responseCallback(@"1323");
        
    }];
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
    if (![network isEqualToString:@"NotReachable"] || ![network isEqualToString:@"Unknown"]) {
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
    NSString *isChangeStr = @"";
    if ([UserDefaultsUtils valueWithKeyWithKey:@"ChangeStr"]==nil){
        isChangeStr = isRefrushStr;
    }else {
        isChangeStr = [UserDefaultsUtils valueWithKeyWithKey:@"ChangeStr"];
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
    NSDictionary *dict = message.body;
    NSString *type = dict[@"classCode"];
  
    
    
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
@end
