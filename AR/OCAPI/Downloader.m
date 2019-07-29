//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import "Downloader.h"
#import "Auth.h"
#import "OCUtil.h"

@interface Downloader () <NSURLSessionDownloadDelegate>
@property (nonatomic, copy) void (^completionHandler)(NSError *error);
@property (nonatomic, copy) void (^progressHandler)(NSString *taskName, float progress);
@property (nonatomic, retain) NSURL *targetURL;
@end

@implementation Downloader

static NSString *kTaskName = @"Download";
static NSString *kAssetsPath = @"assets";
static NSString *kTargetsPath = @"targets";

+ (NSString *)assetsFullPath
{
    return [self getDownloadPath:kAssetsPath];
}

+ (NSString *)targetsFullPath
{
    return [self getDownloadPath:kTargetsPath];
}

+ (NSString *)fullPathForAssetFile:(NSString*)fileName
{
    return [[self assetsFullPath] stringByAppendingPathComponent:fileName];
}

+ (NSString *)fullPathForTargetFile:(NSString*)fileName
{
    return [[self targetsFullPath] stringByAppendingPathComponent:fileName];
}

+ (NSString *)getLocalNameForURL:(NSString *)url {
    return [Auth sha256Hex:url];
}

+ (NSString *)getDownloadPath:(NSString *)path {
    NSString *dir = [OCUtil getSupportDirectory];
    NSString *targetPath = [dir stringByAppendingPathComponent:path];
    [OCUtil ensureDirectory:targetPath];
    return targetPath;
}

//+ (void)saveTo:(NSString*)dst force:(BOOL)force
//{
//    NSError *error = nil;
//    NSFileManager *fm = [NSFileManager defaultManager];
//    bool fileExists = [fm fileExistsAtPath:dst];
//    if (fileExists) {
//        if (!force) {
//            return;
//        }
//        [fm removeItemAtPath:dst error:&error];
//        if (error) {
//            return;
//        }
//    }
//    
//    NSString *path = [dst stringByDeletingLastPathComponent];
//    bool pathExists = [fm fileExistsAtPath:path];
//    if (!pathExists) {
//        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
//        if (error) {
//            return;
//        }
//    }
//}

- (NSURLSessionDownloadTask*)download:(NSString *) url to:(NSString *) dst force:(bool) force
completionHandler:(void (^)(NSError *err)) completionHandler progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    bool fileExists = [fm fileExistsAtPath:dst];
    if (fileExists) {
        if (!force) {
            NSLog(@"ImageTarget Use Cached File");
            completionHandler(nil);
            return nil;
        }
        [fm removeItemAtPath:dst error:&error];
        if (error) {
            completionHandler(error);
            return nil;
        }
    }

    NSString *path = [dst stringByDeletingLastPathComponent];
    bool pathExists = [fm fileExistsAtPath:path];
    if (!pathExists) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            completionHandler(error);
            return nil;
        }
    }

    self.targetURL = [NSURL fileURLWithPath:dst];
    self.completionHandler = completionHandler;
    self.progressHandler = progressHandler;

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:nil];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:url]];
    [task resume];
    
    return task;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
#pragma unused (session, downloadTask, bytesWritten)
    float prog = totalBytesWritten / (float)totalBytesExpectedToWrite;
    if (totalBytesExpectedToWrite < 0) {
        prog = 0;
    }
    self.progressHandler(kTaskName, prog);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
#pragma unused (session, task)
    if (error) {
        self.completionHandler(error);
        [session finishTasksAndInvalidate];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
#pragma unused (session, downloadTask)
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    BOOL isSuccess = [fm moveItemAtURL:location toURL:self.targetURL error:&error];
    if (!isSuccess)
    {
        NSLog(@"ERROR: Downloader moveItemAtURL toURL: %@ failed!", self.targetURL);
    }
    self.completionHandler(error);
    [session finishTasksAndInvalidate];
}

@end
