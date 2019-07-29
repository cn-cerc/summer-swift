//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import "OCARAsset.h"
#import "OCUtil.h"
#import "Downloader.h"
#import "OCCache.h"

static const NSString* kKey_active      = @"active";
static const NSString* kKey_contentId   = @"contentId";
static const NSString* kKey_fileSize    = @"fileSize";
static const NSString* kKey_fileType    = @"fileType";
static const NSString* kKey_key         = @"key";
static const NSString* kKey_modified    = @"modified";
static const NSString* kKey_resourceUrl = @"resourceUrl";

#undef NSAssert
#define NSAssert(...)

@interface OCARAsset()

@end

@implementation OCARAsset

-(instancetype)initWithResult:(NSDictionary*)result
{
    self = [super init];
    if (self) {

        NSAssert([result[kKey_active] isKindOfClass:[NSNumber class]], @"%@ should be a number, but %@", kKey_active, result[kKey_active]);
        NSAssert([result[kKey_contentId] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_contentId, result[kKey_contentId]);
        NSAssert([result[kKey_fileSize] isKindOfClass:[NSNumber class]], @"%@ should be a number, but %@", kKey_fileSize, result[kKey_fileSize]);
        NSAssert([result[kKey_fileType] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_fileType, result[kKey_fileType]);
        NSAssert([result[kKey_key] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_key, result[kKey_key]);
        NSAssert([[OCUtil dateFromString_20180509:result[kKey_modified]] isKindOfClass:[NSDate class]], @"%@ should be a date, but %@", kKey_modified, result[kKey_modified]);
        NSAssert([result[kKey_resourceUrl] isKindOfClass:[NSString class]], @"%@ should be a URL string, but %@", kKey_resourceUrl, result[kKey_resourceUrl]);

        self.active = [result[kKey_active] boolValue];
        self.contentId = result[kKey_contentId];
        self.fileSize = [result[kKey_fileSize] integerValue];
        self.fileType = result[kKey_fileType];
        self.key = result[kKey_key];
        self.modified = [NSString stringWithFormat:@"%@",result[kKey_modified]];// 仅仅用字符串进行比较即可// 仅限于做字符串比较，就不需要转化为Date类型了
        self.resourceUrl = result[kKey_resourceUrl];

        NSAssert([self.contentId length] > 0, @"");
        NSAssert(self.fileSize > 0, @"");
        NSAssert([self.fileType length] > 0, @"");
        NSAssert([self.fileType isEqualToString:@"ezp"], @"");
        NSAssert([self.key length] > 0, @"");
        NSAssert(nil != self.modified, @"");
        NSAssert([self.resourceUrl length] > 0, @"");

        self.result = result;// 这里需要保留，在Cache的逻辑里面需要序列化这个东西
    }
    return self;
}

-(BOOL)isValid
{
    return nil != self.result;// 这里的逻辑还可以进一步的细化，目前只做到这里
}

-(NSString*)localAbsolutePath
{
    NSAssert([self isValid], @"");
    NSString*fileName = self.contentId;//[Downloader getLocalNameForURL:self.contentId];
    /////////////////////////////////////////////////////////////////////////////////
    // 目前引擎仅支持通过扩展名来加载。将来可以通过文件内容判断类型之后，就可以移除这里的walkaround了
    //fileName = [fileName stringByAppendingPathExtension:@"ezp"];
    /////////////////////////////////////////////////////////////////////////////////
    NSString*localPath = [Downloader fullPathForAssetFile:fileName];
    return localPath;
}

-(void)downloadContentToLocalPath:(NSString*)localPath force:(BOOL)force completionHandler:(void(^)(NSError*error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler
{
    NSString*resourceURL = self.resourceUrl;
    Downloader*downloader = [Downloader new];
    NSLog(@"download OCARAsset contentId = %@", self.contentId);
    [downloader download:resourceURL to:localPath force:force completionHandler:^(NSError *error) {
        if (error)
            NSLog(@"Asset downloadContentToLocalPath Error: %@", error);
        if (nil == completionHandler)
            NSLog(@"WARNING: completionHandler is nil in method %s", __PRETTY_FUNCTION__);
        if(nil != completionHandler)
            completionHandler(error);
    } progressHandler:^(NSString *taskName, float progress) {
        NSLog(@"%@, progress: %f for downloading Asset %@ ", taskName, progress*100, resourceURL);
        progressHandler(taskName,progress);
    }];
}

@end
