//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import <Foundation/Foundation.h>

// 一个 OC 请求返回数据的数据头结构类，包含是否成功、地址、数据段等
@interface OCARResponse : NSObject
@property(assign, nonatomic) NSInteger      statusCode;
@property(  copy, nonatomic) NSString*      message;
@property(strong, nonatomic) NSString*      timestamp;
@property(strong, nonatomic) NSDictionary*  restult;

// 解析给定 json 对象
-(instancetype)initWithJSON:(NSDictionary*)json;

// 获取该请求状态是否正常
-(BOOL)isStatusCodeOK;

//-(BOOL)isPastThanDate:(NSDate*)date;
//-(BOOL)isFutureThanDate:(NSDate*)date;
//
//-(BOOL)isPastThanTime:(NSTimeInterval)time;
//-(BOOL)isFutureThanTime:(NSTimeInterval)time;

@end
