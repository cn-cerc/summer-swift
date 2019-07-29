//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import <Foundation/Foundation.h>

// OC 所需工具类，部分常见功能可能和其他工具类重复
@interface OCUtil : NSObject

// 获取一个可以使用的预置文件路径
+ (NSString *)getSupportDirectory;
// 检查并确保给定路径的文件夹已被创建存在
+ (NSError *)ensureDirectory:(NSString *)path;
// 检查是否存在给定路径
+ (bool)pathExists:(NSString *)path;
// 删除给定路径文件
+ (void)deleteQuietly:(NSString *)path;
// 以 Get 请求方式将参数拼接到 url 末尾
+ (NSString *)addQueryParam:(NSDictionary *)params toURL:(NSString *)endPoint;

// 读取给定文件的数据并解析为 json 对象
+ (id)jsonFromFile:(NSString *)fileName;
// 将给定字符串解析为 json 对象
+ (id)jsonFromString:(NSString *)jsonStr;

// 将给定 json 对象转换为 json 字符串
+ (NSString *)stringFromJson:(NSDictionary *)dict;
// 将给定 json 对象写入给定路径的文件
+ (void)writeToFile:(NSString *)fileName fromJson:(NSDictionary *)dict;

// 将给定字符串转换为日期
+ (NSDate*)dateFromString_20180509:(NSString*)str;
// 判断给定日期是否早于给定对比日期
+ (BOOL)isPastDate:(NSDate*)date thanDate:(NSDate*)dateRef;
// 判断给定日期是否晚于给定对比日期
+ (BOOL)isFutureDate:(NSDate*)date thanDate:(NSDate*)dateRef;
// 判断给定时间是否早于给定对比时间
+ (BOOL)isPastTime:(NSTimeInterval)time thanTime:(NSTimeInterval)timeRef;
// 判断给定时间是否晚于给定对比时间
+ (BOOL)isFutureTime:(NSTimeInterval)time thanTime:(NSTimeInterval)time;

@end
