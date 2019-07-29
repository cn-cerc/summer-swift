//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import "OCARTarget.h"
#import "OCUtil.h"
#import "Downloader.h"

static const NSString* kKey_active      = @"active";
static const NSString* kKey_created     = @"created";
static const NSString* kKey_modified    = @"modified";
static const NSString* kKey_grade       = @"grade";
static const NSString* kKey_image       = @"image";
static const NSString* kKey_meta        = @"meta";
static const NSString* kKey_name        = @"name";
static const NSString* kKey_size        = @"size";
static const NSString* kKey_targetId    = @"targetId";
static const NSString* kKey_type        = @"type";

#undef NSAssert
#define NSAssert(...)

@interface OCARTarget()

@end

@implementation OCARTarget
-(instancetype)initWithResult:(NSDictionary*)result
{
    self = [self initWithResult:result isImageURL:NO];
    if (self) {
    }
    return self;
}

-(instancetype)initWithResult:(NSDictionary*)result isImageURL:(BOOL)isImageURL
{
    self = [super init];
    if (self) {

        NSAssert([result[kKey_active] isKindOfClass:[NSNumber class]], @"%@ should be a number, but %@", kKey_active, result[kKey_active]);
        NSAssert([[OCUtil dateFromString_20180509:result[kKey_created]] isKindOfClass:[NSDate class]], @"%@ should be a date, but %@", kKey_created, result[kKey_created]);
        NSAssert([[OCUtil dateFromString_20180509:result[kKey_modified]] isKindOfClass:[NSDate class]], @"%@ should be a date, but %@", kKey_modified, result[kKey_modified]);
        NSAssert([result[kKey_grade] isKindOfClass:[NSNumber class]], @"%@ should be a number, but %@", kKey_grade, result[kKey_grade]);
        NSAssert([result[kKey_image] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_image, result[kKey_image]);
        NSAssert([result[kKey_meta] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_meta, result[kKey_meta]);
        NSAssert([result[kKey_name] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_name, result[kKey_name]);
        NSAssert([result[kKey_size] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_size, result[kKey_size]);
        NSAssert([result[kKey_targetId] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_targetId, result[kKey_targetId]);
        NSAssert([result[kKey_type] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_type, result[kKey_type]);

        self.active = [result[kKey_active] boolValue];
        self.created = [NSString stringWithFormat:@"%@",result[kKey_created]];
        self.modified = [NSString stringWithFormat:@"%@",result[kKey_modified]];// 仅仅用字符串进行比较即可
        self.grade = [result[kKey_grade] integerValue];
        
        if (isImageURL)
        {
            self.imageUrl = result[kKey_image];
            NSAssert([self.imageUrl length] > 0, @"");
        }
        else
        {
            self.image = [[NSData alloc] initWithBase64EncodedString:result[kKey_image] options:0];
            NSAssert([self.image length] > 0, @"");
        }
        
        self.meta = result[kKey_meta];
        self.name = result[kKey_name];
        self.size = result[kKey_size];
        self.targetId = result[kKey_targetId];
        self.type = result[kKey_type];

        NSAssert(nil != self.created, @"");
        NSAssert(nil != self.modified, @"");
        NSAssert(0 == [self.imageUrl length] * [self.image length], @"");
        NSAssert(0 <  [self.imageUrl length] + [self.image length], @"");
//        NSAssert([self.meta length] > 0, @"");
        NSAssert([self.name length] > 0, @"");
        NSAssert(self.size > 0, @"");
        NSAssert([self.targetId length] > 0, @"");
        NSAssert([self.type length] > 0, @"");
        NSAssert([self.type isEqualToString:@"ImageTarget"], @"");
    }
    return self;
}

-(BOOL)isValid
{
    return YES;
}

-(NSString*)localAbsolutePath
{
    NSAssert([self isValid], @"");
    NSAssert(nil != self.imageUrl && self.imageUrl.length>0, @"Only imageURL kind of ARTarget can be downloaded.");
    NSString*fileName = self.targetId;
    NSString*localPath = [Downloader fullPathForTargetFile:fileName];
    return localPath;
}

-(void)downloadContentToLocalPath:(NSString*)localPath force:(BOOL)force completionHandler:(void(^)(NSError*error))completionHandler
{
    NSString*resourceURL = self.imageUrl;
    [self downloadContentToLocalPath:localPath force:force completionHandler:completionHandler progressHandler:^(NSString *taskName, float progress) {
        NSLog(@"%@, progress: %f for downloading ARTarget %@ ", taskName, progress*100, resourceURL);
    }];
}

-(void)downloadContentToLocalPath:(NSString*)localPath force:(BOOL)force completionHandler:(void(^)(NSError*error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler
{
    NSAssert(nil != self.imageUrl && self.imageUrl.length>0, @"Only imageURL kind of ARTarget can be downloaded.");
    __weak typeof(self) wself = self;
    NSString*resourceURL = self.imageUrl;
    Downloader*downloader = [Downloader new];
    [downloader download:resourceURL to:localPath force:force completionHandler:^(NSError *error) {
        if (error){
            NSLog(@"Asset downloadContentToLocalPath Error: %@", error);
        } else {
            typeof(self) sself = wself;
            sself.image = [NSData dataWithContentsOfFile:localPath];
        }
        completionHandler(error);
    } progressHandler:progressHandler];
}

//-(void)saveContentToLocalPath:(NSString*)localPath
//{
//    NSAssert(nil != self.image, @"%s self.image should has data", __PRETTY_FUNCTION__);
//    if ([OCUtil pathExists:localPath])
//        [OCUtil deleteQuietly:localPath];
//    else
//        [OCUtil ensureDirectory:localPath];
//
//    [self.image writeToFile:localPath atomically:YES];
//}

-(void)loadLocalImageFile
{
    NSString*theLocalFileURL = [self localAbsolutePath];
    self.image = [NSData dataWithContentsOfFile:theLocalFileURL];
}

@end
