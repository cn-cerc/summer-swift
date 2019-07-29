//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import <Foundation/Foundation.h>
//#import <EasyARPlayer/wwwservice.oc.h>

extern const NSString*kDownloadOptions_identifier;
extern const NSString*kDownloadOptions_localFileName;
extern const NSString*kDownloadOptions_forceDownload;

//@interface OCWWW : NSObject<easyar_IWWW>
// OC 网络请求类
@interface OCWWW : NSObject

// 从给定 url 下载文件数据
-(void)downloadFileAtURL:(NSString *)url options:(NSDictionary *)options completed:(void (^)(bool isOk, NSString *localAbsolutePath))completed progress:(void (^)(int current, int total))progress;
// 向给定 url 发起网络请求
-(void)requestWithURL:(NSString*)url options:(NSDictionary*)options response:(void(^)(NSDictionary*, NSError *err))response;
// 取消给定 url 的网络请求
-(void)cancelForURL:(NSString*)url options:(NSDictionary*)options;

@end
