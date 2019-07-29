//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import "OCWWW.h"
#import "JSONLoader.h"
#import "Downloader.h"
#import "OCUtil.h"

const NSString*kDownloadOptions_identifier    = @"identifier";
const NSString*kDownloadOptions_localFileName = @"localFileName";
const NSString*kDownloadOptions_forceDownload = @"forceDownload";

#undef NSAssert
#define NSAssert(...)

@interface OCWWW()
@property(strong, nonatomic)NSMutableDictionary<NSNumber*,NSURLSessionTask*>* tasks;
@end

@implementation OCWWW

- (NSNumber*)make_sure_has_option_identifier:(NSDictionary*)options
{
    NSNumber*identifier = options[kDownloadOptions_identifier];
    if (nil == identifier)
    {
        NSAssert([identifier integerValue]>0, @"downloadFileAtURL should has valid %@ (integer)", kDownloadOptions_identifier);
    }
    else
    {
        NSAssert([identifier isKindOfClass:[NSNumber class]], @"%@ should be a number(integer) value", kDownloadOptions_identifier);
    }
    return identifier;
}
-(void)downloadFileAtURL:(NSString *)url options:(NSDictionary *)options completed:(void (^)(bool isOk, NSString *localAbsolutePath))completed progress:(void (^)(int current, int total))progressHandler
{
#pragma unused(options)
    Downloader*downloader = [Downloader new];
    
    NSNumber*identifier = [self make_sure_has_option_identifier:options];
    NSURLSessionTask*task = nil;
    
    NSString*localFileName = options[kDownloadOptions_localFileName];
    {
        if (nil != localFileName)
        {
            NSAssert([localFileName length]>0, @"downloadFileAtURL should has valid %@", kDownloadOptions_localFileName);
        }
        else
        {
            localFileName = [Downloader getLocalNameForURL:url];// 生成SHA256字符串作为最终的文件名
        }
    }
    
    NSString*assetAbsolutePath = [Downloader fullPathForAssetFile:localFileName];
    
    BOOL forceDownload = NO;
    {
        id option = options[kDownloadOptions_forceDownload];
        if (nil != option)
        {
            NSAssert([option isKindOfClass:[NSNumber class]], @"%@ should be a number(bool) value", kDownloadOptions_forceDownload);
            forceDownload = [options[kDownloadOptions_forceDownload] boolValue];
        }
    }
    
    // 检查磁盘上的缓存，存在，且不需要强制下载，那么直接将磁盘上的绝对路径返回
    if ([OCUtil pathExists:assetAbsolutePath] && !forceDownload)
    {
        completed(assetAbsolutePath, nil);
        return;
    }
    
    if (![OCUtil pathExists:assetAbsolutePath] || forceDownload)
    {
        task = [downloader download:url to:assetAbsolutePath force:forceDownload completionHandler:^(NSError*error){
            completed(nil == error, assetAbsolutePath);
        } progressHandler:^(NSString *taskName, float progress) {
#pragma unused(taskName)
            progressHandler(progress*100, 100);
        }];
    }
    
    NSAssert(nil != task, @"task created failed for identifier [%@]", identifier);
    self.tasks[identifier] = task;
}

-(void)requestWithURL:(NSString*)url options:(NSDictionary*)options response:(void(^)(NSDictionary*, NSError *err))response
{
#pragma unused (url, options, response)
    NSNumber*identifier = [self make_sure_has_option_identifier:options];
    NSURLSessionTask*task = nil;
    task = [JSONLoader loadFromURL:url completionHandler:response progressHandler:^(NSString *taskName, float progress) {
        NSLog(@"requestWithURL task %@: progress %f", taskName, progress*100);
    }];
    
    NSAssert(nil != task, @"task created failed for identifier [%@]", identifier);
    self.tasks[identifier] = task;
}

- (void)cancelForURL:(NSString*)url options:(NSDictionary*)options
{
#pragma unused (url, options)
    NSNumber*identifier = [self make_sure_has_option_identifier:options];
    NSURLSessionTask*task = [self.tasks objectForKey:identifier];
    if (nil == task)
    {
        NSLog(@"WARNING: task not exist with identifier=[%@], url=[%@]", identifier, url);
        return;
    }
    [task cancel];
}

@end
