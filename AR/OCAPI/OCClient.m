//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import "OCClient.h"
#import "Auth.h"
#import "JSONLoader.h"
#import "Downloader.h"
#import "OCUtil.h"
#import "OCARResponse.h"
#import "OCStartSchema.h"
#import "OCARBinding.h"
#import "OCARTarget.h"
#import "OCARAsset.h"
#import "OCCache.h"

static const NSString *kStatusCode  = @"statusCode";
static const NSString *kResult      = @"result";
static const NSString *kMessage     = @"msg";
static const NSString *kDate        = @"date";

#undef NSAssert
#define NSAssert(...)

@interface OCClient()
@property (nonatomic, strong) NSString  *ocBaseURL;
@property (nonatomic, strong) NSString  *ocKey;
@property (nonatomic, strong) NSString  *ocSecret;
@property (nonatomic, strong) OCCache   *ocCache;
@end

@implementation OCClient

+ (instancetype)sharedClient
{
    static OCClient *inst = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [OCClient new];
    });
    return inst;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.ocCache = [OCCache new];
    }
    return self;
}

- (void)setServerAddress:(NSString *)baseURL
{
    self.ocBaseURL = baseURL;
}

- (void)setServerAccessKey:(NSString *)key secret:(NSString *)secret
{
    self.ocKey = key;
    self.ocSecret = secret;
}

- (void)clearCache
{
    [self.ocCache clearCache];
    [OCUtil deleteQuietly:[Downloader assetsFullPath]];
    [OCUtil deleteQuietly:[Downloader targetsFullPath]];
}

#pragma mark -

-(void)preloadForStartSchema:(NSString*)startSchemaID completionHandler:(void (^)(OCARPreload *preload))completionHandler
{
    [self preloadForStartSchema:startSchemaID
                            key:self.ocKey
                         secret:self.ocSecret
              completionHandler:^(OCARPreload *preload, NSError *error) { (void)error; completionHandler(preload); }
                progressHandler:^(NSString *taskName, float progress) { NSLog(@"task[%@] startSchemaID %@: %f", taskName, startSchemaID, progress*100); }];
}

-(void)preloadForStartSchema:(NSString*)startSchemaID completionHandler:(void (^)(OCARPreload *preload, NSError *error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler
{
    [self preloadForStartSchema:startSchemaID
                            key:self.ocKey
                         secret:self.ocSecret
              completionHandler:^(OCARPreload *preload, NSError *error) { (void)error; completionHandler(preload, error); }
                progressHandler:^(NSString *taskName, float progress) { NSLog(@"task[%@] startSchemaID %@: %f", taskName, startSchemaID, progress*100); }];
}

- (void)preloadForStartSchema:(NSString *)startSchemaID key:(NSString *)key secret:(NSString *)secret completionHandler:(void (^)(OCARPreload *preload, NSError *error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler
{
    __weak typeof(self) wself = self;
    NSDictionary *params = [Auth signParam:@{} withKey:key andSecret:secret];
    NSString *endPoint = [self.ocBaseURL stringByAppendingFormat:@"/preload/targets/schema/%@", startSchemaID];
    NSString *urlStr = [OCUtil addQueryParam:params toURL:endPoint];
    [JSONLoader loadFromURL:urlStr completionHandler:^(NSDictionary *jso, NSError *err)
     {
         typeof(self) sself = wself;
         if (err)
         {
             NSLog(@"preloadForStartSchema failed, use cache instead, error: %@", err);
             OCARPreload*theARPreload = [sself.ocCache getPreloadBySchemaID:startSchemaID];
             completionHandler(theARPreload, nil==theARPreload?err:nil);
             return;
         }

         OCARResponse*response = [[OCARResponse alloc] initWithJSON:jso];

         if (![response isStatusCodeOK])
         {
             OCARPreload*theARPreload = [self.ocCache getPreloadBySchemaID:startSchemaID];
             NSError*err = [NSError errorWithDomain:response.message code:response.statusCode userInfo:nil];
             NSLog(@"preloadForStartSchema failed, use cache instead, error: %@", err);
             completionHandler(theARPreload, nil==theARPreload?err:nil);
             return;
         }

         OCARPreload*theARPreload = [[OCARPreload alloc] initWithResult:response.restult];
         NSAssert([startSchemaID isEqualToString:theARPreload.startSchemaId], @"");
         if ([sself.ocCache shouldUpdateCacheForPreload:theARPreload])
         {
             NSLog(@"preloadForStartSchema cache is modified, so update cache!");
             [sself.ocCache updatePreload:theARPreload];
         }

         completionHandler(theARPreload, nil);
     } progressHandler:progressHandler];
}


#pragma mark -
/*
 if download failed, startSchema == nil
 */
-(void)loadStartSchema:(NSString*)startSchemaID completionHandler:(void (^)(OCStartSchema *startSchema))completionHandler
{
    [self loadStartSchema:startSchemaID
                      key:self.ocKey
                   secret:self.ocSecret
        completionHandler:^(OCStartSchema *startSchema, NSError*error) { (void)error; completionHandler(startSchema); }
          progressHandler:^(NSString*taskName, float progress){ NSLog(@"task[%@] startSchemaID %@: %f", taskName, startSchemaID, progress*100); }];
}

-(void)loadStartSchema:(NSString*)startSchema completionHandler:(void (^)(OCStartSchema *startSchema, NSError *error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler
{
    [self loadStartSchema:startSchema
                      key:self.ocKey
                   secret:self.ocSecret
        completionHandler:completionHandler
          progressHandler:progressHandler];
}

- (void)loadStartSchema:(NSString *)startSchemaID key:(NSString *)key secret:(NSString *)secret completionHandler:(void (^)(OCStartSchema *startSchema, NSError *error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler
{
    __weak typeof(self) wself = self;
    NSDictionary *params = [Auth signParam:@{@"loadARBindings":@"true", @"withDetails":@"true"} withKey:key andSecret:secret];
//    NSDictionary *params = [Auth signParam:@{@"loadARBindings":@"1", @"withDetails":@"1"} withKey:key andSecret:secret];
//    NSDictionary *params = [Auth signParam:@{@"loadARBindings":@"1"} withKey:key andSecret:secret];
//    NSDictionary *params = [Auth signParam:@{@"withDetails":@"1"} withKey:key andSecret:secret];
    NSString *endPoint = [self.ocBaseURL stringByAppendingFormat:@"/startschema/%@", startSchemaID];
    NSString *urlStr = [OCUtil addQueryParam:params toURL:endPoint];
    [JSONLoader loadFromURL:urlStr completionHandler:^(NSDictionary *jso, NSError *err)
     {
         typeof(self) sself = wself;
         if (err)
         {
             NSLog(@"loadStartSchema failed, use cache instead, error: %@", err);
             OCStartSchema*theStartSchema = [sself.ocCache getSchemaBySchemaID:startSchemaID];
             completionHandler(theStartSchema, nil==theStartSchema?err:nil);
             return;
         }
         
         OCARResponse*response = [[OCARResponse alloc] initWithJSON:jso];
         
         if (![response isStatusCodeOK])
         {
             OCStartSchema*theStartSchema = [sself.ocCache getSchemaBySchemaID:startSchemaID];
             NSError*err = [NSError errorWithDomain:response.message code:response.statusCode userInfo:nil];
             NSLog(@"loadStartSchema failed, use cache instead, error: %@", err);
             completionHandler(theStartSchema, nil==theStartSchema?err:nil);
             return;
         }
         
         OCStartSchema*theStartSchema = [[OCStartSchema alloc] initWithResult:response.restult];
         NSAssert([startSchemaID isEqualToString:theStartSchema.startSchemaId], @"");
         if ([sself.ocCache shouldUpdateCacheForSchema:theStartSchema])
         {
             NSLog(@"loadStartSchema cache is modified, so update cache!");
             [sself.ocCache updateSchema:theStartSchema];
         }
         
         completionHandler(theStartSchema, nil);
     } progressHandler:progressHandler];
}

#pragma mark -
/*
 if download failed, asset == nil
 */

-(void)loadARAsset:(NSString*)assetID completionHandler:(void (^)(OCARAsset *asset))completionHandler
{
    [self loadARAsset:assetID
                  key:self.ocKey
               secret:self.ocSecret
    completionHandler:^(OCARAsset *asset, NSError*error){ (void)error; completionHandler(asset); }
      progressHandler:^(NSString*taskName, float progress){ NSLog(@"task[%@] assetID %@: %f", taskName, assetID, progress*100); }];
}

-(void)loadARAsset:(NSString*)contentID completionHandler:(void (^)(OCARAsset *package, NSError *error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler
{
    [self loadARAsset:contentID
                  key:self.ocKey
               secret:self.ocSecret
    completionHandler:^(OCARAsset *asset, NSError*error){ completionHandler(asset,error); }
      progressHandler:^(NSString*taskName, float progress){ NSLog(@"task[%@] assetID %@: %f", taskName, contentID, progress*100);
          progressHandler(taskName,progress);
      }];

}

-(void)loadARAsset:(NSString*)contentID key:(NSString *)key secret:(NSString *)secret completionHandler:(void (^)(OCARAsset *package, NSError *error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler
{
    __weak typeof(self) wself = self;
    NSDictionary *params = [Auth signParam:[NSDictionary new] withKey:key andSecret:secret];
    NSString *endPoint = [self.ocBaseURL stringByAppendingFormat:@"/assetslibrary/%@", contentID];
    NSString *urlStr = [OCUtil addQueryParam:params toURL:endPoint];
    [JSONLoader loadFromURL:urlStr completionHandler:^(NSDictionary *jso, NSError *err){
        typeof(self) sself = wself;
        if (err)
        {
            NSLog(@"loadARAsset failed, use Cached instead, error: %@", err);
            OCARAsset*theARAsset = [self.ocCache getAssetByContentID:contentID];
            completionHandler(theARAsset, nil==theARAsset?err:nil);
            return;
        }
        
        OCARResponse*response = [[OCARResponse alloc] initWithJSON:jso];
        
        if (![response isStatusCodeOK])
        {
            OCARAsset*theARAsset = [self.ocCache getAssetByContentID:contentID];
            NSError*err = [NSError errorWithDomain:response.message code:response.statusCode userInfo:nil];
            NSLog(@"loadARAsset failed, use Cached instead, error: %@", err);
            completionHandler(theARAsset, nil==theARAsset?err:nil);
            return;
        }
        
        OCARAsset*asset = [[OCARAsset alloc] initWithResult:response.restult];
        NSAssert([contentID isEqualToString:asset.contentId], @"");
        if ([sself.ocCache isStillValidForAsset:asset])
        {
            NSLog(@"loadARAsset cache is still valid, use Cached instead!");
            completionHandler([sself.ocCache getAssetByContentID:contentID], nil);
            return;
        }
            
        NSString*assetLocalAbsolutePath = [asset localAbsolutePath];
        [asset downloadContentToLocalPath:assetLocalAbsolutePath force:YES completionHandler:^(NSError*error) {
            if (error)
            {
                completionHandler(nil, error);
            }
            else
            {
                typeof(self) sself = wself;
                [sself.ocCache updateAsset:asset];
                completionHandler(asset, nil);
            }
        }progressHandler:^(NSString *taskName, float progress) {
            progressHandler(taskName,progress);
        }];
    }progressHandler:^(NSString *taskName, float progress) {
        //此回调为json读取时的回调！！！
    }];
}

#pragma mark -
/*
 if download failed, OCARTarget == nil
 */

-(void)downloadImageForARTarget:(OCARTarget *)target completionHandler:(void (^)(OCARTarget*,NSError *))completionHandler
{
    [self downloadImageForARTarget:target
                 completionHandler:completionHandler
                   progressHandler:^(NSString *taskName, float progress) { NSLog(@"downloadARTarget task[%@] targetId %@: %f", taskName, target.targetId, progress*100); }];
}

-(void)downloadImageForARTarget:(OCARTarget *)target completionHandler:(void (^)(OCARTarget*,NSError *))completionHandler progressHandler:(void (^)(NSString *, float))progressHandler
{
    NSAssert(nil == target.image, @"");
    NSAssert(nil != target.imageUrl, @"");
    
    bool force = [self.ocCache shouldUpdateImageOfTarget:target];
    
    NSString*theLocalFileURL = [target localAbsolutePath];
    [target downloadContentToLocalPath:theLocalFileURL force:force completionHandler:^(NSError *error) {
        if (nil == error)
        {
            [target loadLocalImageFile];
        }
        completionHandler(target, error);
    } progressHandler:progressHandler];
}

@end
