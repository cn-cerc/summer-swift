//
//  GlobalFile_oc.h
//  summer
//
//  Created by 王雨 on 2018/1/12.
//  Copyright © 2018年 FangLin. All rights reserved.
//

#ifndef GlobalFile_oc_h
#define GlobalFile_oc_h
#import "summer-Swift.h"
static NSString *URL_APP_ROOT = @"https://m.knowall.cn";//master版
//static NSString *URL_APP_ROOT = @"https://c1.knowall.cn";//Beta版

#define WELCOME_IMAGES_COUNT = 3
static const NSString *FORMS = @"forms";
static const NSString *SERVICES = @"services";

//推送
static const NSString * appkey = @"cc92570c841a688af5adc5b0";
static const NSString * channel = @"Publish channel";
static const BOOL isProduction = YES;
//屏幕的宽高
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
NSString *const isBackStr = @"/forms/FrmIndex,/forms/Login,/forms/VerificationLogin";
NSString *const isRefrushStr = @"/forms/Default,/,/forms/Login?device=iphone,/forms/FrmPhoneRegistered,/forms/VerificationLogin,/forms/Login,/forms/FrmLossPassword";

#define URLPATH [[URL_APP_ROOT stringByAppendingString:@"?device=iphone&CLIENTID="]stringByAppendingString:[DisplayUtils uuid]]//url


#define URLPATH_CONFIG [NSString stringWithFormat:@"%@/forms/install.client", URL_APP_ROOT]//获取启动图片、广告图片及检测版本更新

#define EXIT_URL_PATH [URL_APP_ROOT stringByAppendingString:@"/form/TFrmLogout"]

#define BACK_MAIN [URL_APP_ROOT stringByAppendingString:@"/form/TWebDefault"]

NSString *const WXPaySuccessNotification = @"WeixinPaySuccessNotification";//支付成功

NSString *const WX_APPID = @"wx41af87527e0b6315";

NSString *const kAppVersion = @"appVersion";

NSString *const KLoadDataBase = @"KLoadDataBase";//网络监听

NSString *const JPushMessage = @"JPushMessage";//极光推送

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#endif /* GlobalFile_oc_h */


