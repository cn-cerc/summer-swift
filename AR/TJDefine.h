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

#define kEasyAR3DAppKey @"JSnBqSE62bU5W3J0qbcVJijOM/XHvteZU7zp0hUb94IhC/GfFQbm0lpK6JgBBvWKCA38sBMB9ZgUGLyTDwWw3EIF84MUDeC7BRHblEJSo9xCBPuTBQbhlRNKqKsbSvCFDgz+lSkM4dJaM7DFMFrQsjla3LNZRuGZFA28lQwe94NOCeKAQkSwgwkc994FBOSVE0bzgBBKz9xCHvOCCQn8hBNKqKtCGP6RGQ3g0kxK4oIPSr7SAgnhmQNKz9xCGP6RFA79gg0bsMo7SuWZDgz9hxNKvtINCfHSPUSwlRgY+4IFPPudBTvmkQ0YsMoOHf6cTEr7gywH8ZEMSqiWAQThlR1E6dICHfyUDA3blBNKqKtCXcLCIirLwi4rq94TAeaVTg3+hgUbvJEQGLCtTErkkRIB854UG7DKO0rinAER94JCRLCAEgew3EIK84MJC7CtTErinAEc9J8SBeHSWjOwkQ4M4J8JDLCtTEr3iBAB4JU0Af+VMxzznRBKqJ4VBP7cQgHhvA8L85xCUvSRDBv3jUwTsJIVBvacBSH2g0JSydITAeaVTg3+hgUbvJEQGLCtTErkkRIB854UG7DKO0rinAER94JCRLCAEgew3EIK84MJC7CtTErinAEc9J8SBeHSWjOwmQ8bsK1MSveIEAHglTQB/5UzHPOdEEqonhUE/txCAeG8DwvznEJS9JEMG/eNPRX15I2APAl7aaeMxaIkgeNC59sJPfrowZtOZwkyZKutpFNKq0on+79d5rt/j8zo9YLb3LYPYPJzhLBafzZHb7Bu9h9bJRvyQ3xKWZi9xHU6D+kNNczQZu3815E/wyva6Nf784+YIbBO4ZfIcwBJXDXNPIcbqoD58H/KKMPn4D4BgVn2RpSDKV75bb3MqqUUpEXXSylO5Iz8iZzQSwxPUQweui+JfxWzoRomaMTWx6uqe8215bWcTx0EtZN9yxWODoD++3h/I3/E+jHUKTovaihsa2HD+nLv/r0IrgzMdKb0ETJV9qkDq2a2GJMAxtwrpO3U9ID95T/2f+lxv9ZgaJLw"
#define APPID_VALUE @"5d1f0862"


#endif /* TJDefine_h */
