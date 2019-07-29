//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import <Foundation/Foundation.h>

// OC 身份验证类
@interface Auth : NSObject

// 将给定sha256字符串转换为16进制字符串
+ (NSString *)sha256Hex:(NSString *)str;
// 使用给定 secret 为给定参数生成签名字符串
+ (NSString *)generateSignature:(NSDictionary *)param withSecret:(NSString *)secret;
// 使用给定 key 和 secret 为给定参数添加签名信息
+ (NSDictionary *)signParam:(NSDictionary *)param withKey:(NSString *)key andSecret:(NSString *)secret;

@end
