//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import <Foundation/Foundation.h>

// OC 下载器类
@interface Downloader : NSObject

// 获取 ar 识别图完整路径
+ (NSString *)targetsFullPath;
// 获取 ar 内容包完整路径
+ (NSString *)assetsFullPath;
// 获取给定内容包文件名的完整路径
+ (NSString *)fullPathForAssetFile:(NSString*)fileName;
// 获取给定识别图文件名的完整路径
+ (NSString *)fullPathForTargetFile:(NSString*)fileName;
// 将给定 url 转换为对应的本地名字
+ (NSString *)getLocalNameForURL:(NSString *)url;
// 获取下载内容在本地的保存路径
+ (NSString *)getDownloadPath:(NSString *)path;
//+ (void)saveTo:(NSString*)dst force:(BOOL)force;

// 开始下载给定 url 内容
- (NSURLSessionDownloadTask*)download:(NSString *) url to:(NSString *) dst force:(bool) force
completionHandler:(void (^)(NSError *err)) completionHandler
 progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler;

@end
