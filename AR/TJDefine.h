//
//  TJDefine.h
//  helloarscene
//
//  Created by YangTengJiao on 2018/6/8.
//  Copyright © 2018年 VisionStar Information Technology (Shanghai) Co., Ltd. All rights reserved.
//

#ifndef TJDefine_h
#define TJDefine_h

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nNSLog:%s line:%d %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kUserDefaults      [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define ScreenTJSize [UIScreen mainScreen].bounds.size
#define ScreenTJHeight [UIScreen mainScreen].bounds.size.height
#define ScreenTJWidth [UIScreen mainScreen].bounds.size.width
#define WidthTJ(obj)   (!obj?0:(obj).frame.size.width)
#define HeightTJ(obj)   (!obj?0:(obj).frame.size.height)
#define XTJ(obj)   (!obj?0:(obj).frame.origin.x)
#define YTJ(obj)   (!obj?0:(obj).frame.origin.y)
#define XWidthTJ(obj) (X(obj)+W(obj))
#define YHeightTJ(obj) (Y(obj)+H(obj))
//获取图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
//颜色
#define RGBATJ(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGBTJ(r,g,b) RGBATJ(r,g,b,1.0f)
#define ClearColorTJ [UIColor clearColor]
//随机颜色
#define RandomColorTJ [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
//字体大小
#define BoldFontTJ(x) [UIFont boldSystemFontOfSize:x]
#define MediumFontTJ(x) [UIFont systemFontOfSize:x weight:UIFontWeightMedium]
#define RegularFontTJ(x) [UIFont systemFontOfSize:x weight:UIFontWeightRegular]
#define FontTJ(x) [UIFont systemFontOfSize:x]
//强弱引用
#define WeakSelfTJ(type)  __weak typeof(type) weak##type = type;
#define StrongSelfTJ(type)  __strong typeof(type) strong##type = type;
//发送通知
#define PostNotificationTJ(name,userInfo) ({\
dispatch_async(dispatch_get_main_queue(), ^{\
[[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];\
});})
//接收通知
#define GetNotificationTJ(name,action) ({\
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action:) name:name object:nil];\
})
//创建Label
#define CreatLabelTJ(frame, title, font, textColor, bgColor, textAlignment) ({\
UILabel *label = [[UILabel alloc]initWithFrame:frame];\
if (title) {\
label.text = title;\
}\
if (font) {\
label.font = font;\
}\
if (textColor) {\
label.textColor = textColor;\
}\
if (bgColor) {\
label.backgroundColor = bgColor;\
}\
if (textAlignment) {\
label.textAlignment = textAlignment;\
}\
label;\
})
//创建Button
#define CreatButtonTJ(frame,title,font,titleColor,bgColor,image,bgImage) ({\
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];\
button.frame = frame;\
if (title) {\
    [button setTitle:title forState:UIControlStateNormal];\
} else {\
    [button setTitle:@"" forState:UIControlStateNormal];\
}\
if (font) {\
    button.titleLabel.font = font;\
}\
if (titleColor) {\
    [button setTitleColor:titleColor forState:UIControlStateNormal];\
}\
if (bgColor) {\
    button.backgroundColor = bgColor;\
}\
if (image) {\
    [button setImage:image forState:UIControlStateNormal];\
}\
if (bgImage) {\
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];\
}\
button;\
});
//设置圆角
#define ViewRadiusTJ(View, Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]
//设置边框
#define ViewBorderTJ(View,Width,Color)\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]
//角度弧度转化
#define DegreesToRadianTJ(x) (M_PI * (x) / 180.0)
#define RadianToDegreesTJ(radian) (radian*180.0)/(M_PI)
//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
// 判断是否为 iPhone 5SE
#define iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
// 判断是否为iPhone 6/6s
#define iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f
//判断机型是否为iphonex
#define KIsiPhoneX ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) {\
if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 20) {\
tmp = 1;\
}else{\
tmp = 0;\
}\
}else{\
tmp = 0;\
}\
tmp;\
})
#define kStatusBarHeight (KIsiPhoneX?44:20)
#define KBottomHeight (KIsiPhoneX?34:0) // 适配iPhone x 底部提升高度
//获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//判断 iOS 8 或更高的系统版本
#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))
//获取根目录
#define kPathHome NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//获取字符串宽度
#define GetStingWidth(text,font) ({\
CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];\
size.width;\
})
//获取字符串高度
#define GetStingHeight(text,width,font) ({\
CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}  context:nil].size;\
size.height;\
})
//获取语言环境
// zh-Hans是简体中文，zh-Hant是繁体中文  en英语
#define GetLanguage ({\
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];\
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];\
    NSString * preferredLang = [allLanguages objectAtIndex:0];\
    if ([preferredLang isEqualToString:@"zh-Hans-CN"] || [preferredLang isEqualToString:@"zh-Hans"]) {\
        return @"zh_cn";\
    } else if ([preferredLang isEqualToString:@"zh-Hant-CN"] || [preferredLang isEqualToString:@"zh-Hant"]) {\
        return @"zh_tw";\
    } else {\
        return @"en_us";\
    }\
})

#define kEasyAR3DAppKey @"NVGlzTFCvdEpI5sY4cXs/jNxe+eCzdhVdpWNtgVjk+Yxc5X7BX6Ctkoymv0YcZ/4EX6R1AN5kfwEYNj3H33UuFJ9l+cEdYTfFWm/8FIqx7hSfJ/3FX6F8QMyzM8LMpThHnSa8Tl0hbZKS9T3H33Y8Rxmk+decYbkUjzU9x992PEcZpPnXnGG5FJN2rYGcYT9EX6C51IqrbYAfJftFWLUuFJghPtSPNT2EWOf91JN2rYAfJfgFn+E+QMyzM9SZ5/6FH+B51I81PkRc9TJXDKT7AB5hPEkeZvxI2SX+QAyzPoFfJq4UnmF2B9zl/hSKpD1HGOT6Vxr1PYFfpL4FVmS51IqrbYTf5u6FXyA8QM+l+QAMqu4UmaX5hlxmOADMszPUmCa9Ql1hLZcMobmHzLathJxhf0TMqu4UmCa9QR2meYdY9SuKzKX+hRimf0UMqu4UnWO5Blik8AZfZPHBHGb5FIqmOEcfNq2GWO6+xNxmrZKdpf4A3WLuAsylOEedJrxOXSFtkpL1PcffdjxHGaT515xhuRSTdq2BnGE/RF+gudSKq22AHyX7RVi1LhSYIT7UjzU9hFjn/dSTdq2AHyX4BZ/hPkDMszPUnmZ51JN2rYVaIb9AnWi/R11peARfYa2Sn6D+Bw81P0DXJn3EXzUrhZxmucVbavpAwFc7E+4A+t4jxRdHBZIPIkKsdC3Vb2wpr72G8caUnHlXrnXbpv7Dbvzr0i2MVaJT+Wd1HX3EJTWs4KvYYEslyP6YWIWIxZv7TQL8EU485pO+5S3KczsPwxq1YvojgFhVqNTiSos4HhjNY4JwFP/zRf7nwicoowxeWIvXg99kbBVeckjxcNIY+XCHq7USTWmo0JAKioLyWMANw099mLr7W1nOk5IsQ66qsIZT+MM3oPSs66C8fTWd0V31uvHcdKUdU9I/Jb/d75KNSP4DTi76JZwIMhJ/vzy0ug/WCTp69uX9RX1ag3ZC9Y4jJtNVHiSDPSnXVhmJkj3MueWcBD2lA=="
#define APPID_VALUE @"5d1f0862"


#endif /* TJDefine_h */