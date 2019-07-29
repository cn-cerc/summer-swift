//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import "OCUtil.h"

@implementation OCUtil

+ (NSString *)getSupportDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}

+ (NSError *)ensureDirectory:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    return error;
}

+ (bool)pathExists:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}

+ (void)deleteQuietly:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:path error:nil];
}

+ (NSString *)urlEncode:(id)object {
    NSString *str = [NSString stringWithFormat:@"%@", object];
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)addQueryParam:(NSDictionary *)params toURL:(NSString *)endPoint {
    NSURLComponents *components = [NSURLComponents componentsWithString:endPoint];
    NSMutableArray *queryItems = [NSMutableArray new];
    for (NSString *key in params) {
        NSString *part = [NSString stringWithFormat:@"%@=%@",
                          [OCUtil urlEncode:key], [OCUtil urlEncode:params[key]]];
        [queryItems addObject:part];
    }
    NSString *queryString = [queryItems componentsJoinedByString:@"&"];
    components.query = queryString;
    NSURL *url = components.URL;
    return [url absoluteString];
}

+ (id)jsonFromData:(NSData *)jsonData {
    if (!jsonData) return nil;

    NSError *error;
    id res = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    return res;
}

+ (id)jsonFromFile:(NSString *)fileName {
    NSData *jsonData = [NSData dataWithContentsOfFile:fileName];
    return [OCUtil jsonFromData:jsonData];
}

+ (id)jsonFromString:(NSString *)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    return [OCUtil jsonFromData:jsonData];
}

+ (NSData *)dataFromJson:(NSDictionary *)dict {
    NSError *error;
    NSData *res = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    return res;
}

+ (NSString *)stringFromJson:(NSDictionary *)dict {
    NSData *data = [OCUtil dataFromJson:dict];
    if (!data) return nil;
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (void)writeToFile:(NSString *)fileName fromJson:(NSDictionary *)dict {
    NSData *data = [OCUtil dataFromJson:dict];
    if (!data) return;
    [data writeToFile:fileName atomically:YES];
}

+ (NSDate*)dateFromString_20180509:(NSString*)stringDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];// 隐含约定：时区默认为北京时间所在的时区，据说是东8区
    NSDate *dateCheck = [dateFormatter dateFromString:stringDate];
    return dateCheck;
}

+ (BOOL)isPastDate:(NSDate*)date thanDate:(NSDate*)dateRef
{
    return [date timeIntervalSince1970] < [dateRef timeIntervalSince1970];
}

+ (BOOL)isFutureDate:(NSDate*)date thanDate:(NSDate*)dateRef
{
    return [date timeIntervalSince1970] > [dateRef timeIntervalSince1970];
}

+ (BOOL)isPastTime:(NSTimeInterval)time thanTime:(NSTimeInterval)timeRef
{
    return time < timeRef;
}

+ (BOOL)isFutureTime:(NSTimeInterval)time thanTime:(NSTimeInterval)timeRef
{
    return time > timeRef;
}

@end
