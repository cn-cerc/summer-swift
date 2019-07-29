//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import "OCCache.h"
#import "OCARPreload.h"
#import "OCStartSchema.h"
#import "OCARBinding.h"
#import "OCARAsset.h"
#import "OCARTarget.h"
#import "OCUtil.h"
#import "Downloader.h"

#undef NSAssert
#define NSAssert(...)

@interface OCCache()
@property (nonatomic, strong) NSMutableDictionary<NSString*,OCARPreload*> *preloadsBySchemaID;
@property (nonatomic, strong) NSMutableDictionary<NSString*,OCStartSchema*> *schemasBySchemaID;
//@property (nonatomic, strong) NSMutableDictionary<NSString*,OCARBinding*> *bindingsByBindingID;
@property (nonatomic, strong) NSMutableDictionary<NSString*,OCARAsset*> *assetsByContentID;


@property (nonatomic, strong) NSMutableDictionary<NSString*,OCARTarget*> *targetsByTargetID;
@end

@implementation OCCache

static NSString *kCacheIndex = @"cache_index";
//static NSString *kPackageURL = @"packageURL";
//static NSString *kTimestamp = @"timestamp";

static NSString *kCacheInfo_OCARPreloads = @"OCARPreloads";
static NSString *kCacheInfo_OCStartSchemas = @"OCStartSchemas";
//static NSString *kCacheInfo_OCARBindings = @"OCARBindings";
static NSString *kCacheInfo_OCARAssets = @"OCARAssets";
//static NSString *kCacheInfo_OCARTargets = @"OCARTargets";

+ (NSString *)getCacheIndexPath
{
    NSString *supportDir = [OCUtil getSupportDirectory];
    [OCUtil ensureDirectory:supportDir];
    return [supportDir stringByAppendingPathComponent:kCacheIndex];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.preloadsBySchemaID = [NSMutableDictionary<NSString*,OCARPreload*> new];
        self.targetsByTargetID = [NSMutableDictionary<NSString*,OCARTarget*> new];
        self.schemasBySchemaID = [NSMutableDictionary<NSString*,OCStartSchema*> new];
        self.assetsByContentID = [NSMutableDictionary<NSString*,OCARAsset*> new];
        [self loadCacheInfo];
    }
    return self;
}

#pragma mark - loadCacheInfo

- (void)loadCacheInfo_OCARPreloads:(NSDictionary*)json
{
    __weak typeof(self) wself = self;
    [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull theId, id  _Nonnull obj, BOOL * _Nonnull stop) {
        typeof(self) sself = wself;
        OCARPreload*theARPreload = [[OCARPreload alloc] initWithResult:obj];
        
        for (OCARTarget*theARTarget in theARPreload.targets)
        {
            sself.targetsByTargetID[theARTarget.targetId] = theARTarget;
        }

        sself.preloadsBySchemaID[theId] = theARPreload;
        NSAssert(NULL != stop, @"ERROR: Load Cache OCARPreloads failed!");
    }];
}

- (void)loadCacheInfo_OCStartSchemas:(NSDictionary*)json
{
   
    
    __weak typeof(self) wself = self;
    [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull theId, id  _Nonnull obj, BOOL * _Nonnull stop) {
        typeof(self) sself = wself;
        sself.schemasBySchemaID[theId] = [[OCStartSchema alloc] initWithResult:obj];
        NSAssert(NULL != stop, @"ERROR: Load Cache OCStartSchemas failed!");
    }];
}

//- (void)loadCacheInfo_OCARBindings:(NSDictionary*)json
//{
//    self.bindingsByBindingID = [NSMutableDictionary<NSString*,OCARBinding*> new];
//
//    __weak typeof(self) wself = self;
//    [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull theId, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        typeof(self) sself = wself;
//        sself.bindingsByBindingID[theId] = [[OCARBinding alloc] initWithResult:obj];
//        assert(NULL != stop);
//    }];
//}

- (void)loadCacheInfo_OCARAssets:(NSDictionary*)json
{
    __weak typeof(self) wself = self;
    [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull theId, id  _Nonnull obj, BOOL * _Nonnull stop) {
        typeof(self) sself = wself;
        sself.assetsByContentID[theId] = [[OCARAsset alloc] initWithResult:obj];
        NSAssert(NULL != stop, @"ERROR: Load Cache OCARAssets failed!");
    }];
}

- (void)loadCacheInfo
{
    NSData *jsonData = [NSData dataWithContentsOfFile:[OCCache getCacheIndexPath]];
    if (jsonData)
    {
        NSError *error;
        NSDictionary *saveDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error)
        {
            NSLog(@"ERROR: %@", error);
            return;
        }
        NSAssert(nil == error, @"ERROR: Load Cache information failed!");
        
//        [self loadCacheInfo_OCARBindings:saveDict[kCacheInfo_OCARBindings]];
        [self loadCacheInfo_OCARPreloads:saveDict[kCacheInfo_OCARPreloads]];
        [self loadCacheInfo_OCStartSchemas:saveDict[kCacheInfo_OCStartSchemas]];
        [self loadCacheInfo_OCARAssets:saveDict[kCacheInfo_OCARAssets]];
    }
}

#pragma mark - saveCacheInfo

- (NSMutableDictionary*)saveCacheInfo_OCARAssets
{
    NSMutableDictionary*saveDict = [NSMutableDictionary new];
    for (OCARAsset *asset in [self.assetsByContentID allValues])
    {
        NSAssert([asset isValid], @"");
        saveDict[asset.contentId] = asset.result;
    }
    return saveDict;
}

- (NSMutableDictionary*)saveCacheInfo_OCARPreloads
{
    NSMutableDictionary*saveDict = [NSMutableDictionary new];
    for (OCARPreload *preload in [self.preloadsBySchemaID allValues])
    {
        NSAssert([preload isValid], @"");
        saveDict[preload.startSchemaId] = preload.result;
    }
    return saveDict;
}

- (NSMutableDictionary*)saveCacheInfo_OCStartSchemas
{
    NSMutableDictionary*saveDict = [NSMutableDictionary new];
    for (OCStartSchema *schema in [self.schemasBySchemaID allValues])
    {
        NSAssert([schema isValid], @"");
        saveDict[schema.startSchemaId] = schema.result;
    }
    return saveDict;
}

//- (NSMutableDictionary*)saveCacheInfo_OCARBindings
//{
//    NSMutableDictionary*saveDict = [NSMutableDictionary new];
//    for (OCARBinding *binding in [self.bindingsByBindingID allValues])
//    {
//        NSAssert([binding isValid], @"");
//        saveDict[binding.arbindingId] = binding.result;
//    }
//    return saveDict;
//}


- (void)saveCacheInfo
{
    NSMutableDictionary *saveDict = [NSMutableDictionary new];
    
    saveDict[kCacheInfo_OCARAssets] = [self saveCacheInfo_OCARAssets];
    saveDict[kCacheInfo_OCARPreloads] = [self saveCacheInfo_OCARPreloads];
    saveDict[kCacheInfo_OCStartSchemas] = [self saveCacheInfo_OCStartSchemas];
//    saveDict[kCacheInfo_OCARBindings] = [self saveCacheInfo_OCARBindings];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:saveDict options:kNilOptions error:&error];
    if (error)
    {
        NSLog(@"Error: %@", error);
    }
    BOOL isSuccess = [jsonData writeToFile:[OCCache getCacheIndexPath] atomically:YES];
    if (isSuccess) {
        NSLog(@"cache 保存成功 %@",saveDict);
    } else {
        NSLog(@"cache 保存失败 %@",saveDict);
    }
//    [jsonData writeToFile:[OCCache getCacheIndexPath] atomically:YES];
}

- (void)clearCache
{
    [self.assetsByContentID removeAllObjects];
    [self.targetsByTargetID removeAllObjects];// OCARTarget是依附于OCARPreload里面的，仅仅用于加速查找过程而已
    [self.preloadsBySchemaID removeAllObjects];
    [self.schemasBySchemaID removeAllObjects];
//    [self.bindingsByBindingID removeAllObjects];
    [self saveCacheInfo];
    [OCUtil deleteQuietly:[OCCache getCacheIndexPath]];
}


//- (NSString *)getLocalPathForURL:(NSString *)url
//{
//    for (NSString *contentID in self.assetsByContentID)
//    {
//        OCARAsset *asset = self.assetsByContentID[contentID];
//        if ([url isEqualToString:asset.resourceUrl])
//            return [asset localAbsolutePath];
//    }
//    return nil;
//}

#pragma mark - OCARPreload

- (OCARPreload *)getPreloadBySchemaID:(NSString *)schemaID
{
    return self.preloadsBySchemaID[schemaID];
}

- (NSString*)getPreloadLastModifiedFromSchemaID:(NSString *)schemaID
{
    OCARPreload *preload = [self getPreloadBySchemaID:schemaID];
    if (!preload) return @"";
    return preload.modified;
}

- (BOOL)shouldUpdateCacheForPreload:(OCARPreload*)preload
{
    return ![preload.modified isEqualToString:[self getPreloadLastModifiedFromSchemaID:preload.startSchemaId]];
}

- (void)updatePreload:(OCARPreload *)preload
{
    self.preloadsBySchemaID[preload.startSchemaId] = preload;
    [self saveCacheInfo];
}

#pragma mark - OCARStartSchema

- (OCStartSchema *)getSchemaBySchemaID:(NSString *)schemaID
{
    return self.schemasBySchemaID[schemaID];
}

- (NSString*)getSchemaLastModifiedFromSchemaID:(NSString *)schemaID
{
    OCStartSchema *schema = [self getSchemaBySchemaID:schemaID];
    if (!schema) return @"";
    return schema.modified;
}

- (BOOL)shouldUpdateCacheForSchema:(OCStartSchema*)schema
{
    return ![schema.modified isEqualToString:[self getSchemaLastModifiedFromSchemaID:schema.startSchemaId]];
}

- (void)updateSchema:(OCStartSchema *)schema
{
    self.schemasBySchemaID[schema.startSchemaId] = schema;
    [self saveCacheInfo];
}

//#pragma mark - OCARBinding
//
//- (OCARBinding *)getBindingByBindingID:(NSString *)bindingID
//{
//    return self.bindingsByBindingID[bindingID];
//}
//
//- (NSString*)getBindingLastModifiedFromBindingID:(NSString *)bindingID
//{
//    OCARBinding *binding = [self getBindingByBindingID:bindingID];
//    if (!binding) return @"";
//    return binding.modified;
//}
//
//- (BOOL)shouldUpdateCacheForBinding:(OCARBinding*)binding
//{
//    return ![binding.modified isEqualToString:[self getBindingLastModifiedFromBindingID:binding.arbindingId]];
//}
//
//- (void)updateBinding:(OCARBinding *)binding
//{
//    self.bindingsByBindingID[binding.arbindingId] = binding;
//    [self saveCacheInfo];
//}

#pragma mark - OCARTargetImage

- (OCARTarget *)getTargetByTargetID:(NSString *)targetID
{
    return self.targetsByTargetID[targetID];
}

- (NSString*)getTargetLastModifiedFromTargetID:(NSString *)targetID
{
    OCARTarget *target = [self getTargetByTargetID:targetID];
    if (!target) return @"";
    return target.modified;
}

//- (BOOL)isStillValidForImageOfTarget:(OCARTarget*)target
//{
//    return [target.modified isEqualToString:[self getTargetLastModifiedFromTargetID:target.targetId]];
//}

- (BOOL)shouldUpdateImageOfTarget:(OCARTarget*)target
{
    return ![target.modified isEqualToString:[self getTargetLastModifiedFromTargetID:target.targetId]];
}

#pragma mark - OCARAsset

- (OCARAsset *)getAssetByContentID:(NSString *)contentID
{
    return self.assetsByContentID[contentID];
}

- (NSString*)getAssetLastModifiedFromContentID:(NSString *)contentID
{
    OCARAsset *asset = [self getAssetByContentID:contentID];
    if (!asset) return @"";
    return asset.modified;
}

- (BOOL)isStillValidForAsset:(OCARAsset*)asset
{
    return [asset.modified isEqualToString:[self getAssetLastModifiedFromContentID:asset.contentId]];
}

//- (BOOL)shouldUpdateCacheForAsset:(OCARAsset*)asset
//{
//    return ![asset.modified isEqualToString:[self getAssetLastModifiedFromContentID:asset.contentId]];
//}

- (void)updateAsset:(OCARAsset *)asset
{
    self.assetsByContentID[asset.contentId] = asset;
//    if ([self shouldUpdateCacheForAsset:asset])
//    {
//        NSString*theLocalAbsolutePath = [asset localAbsolutePath];
//        [asset downloadContentToLocalPath:theLocalAbsolutePath force:YES completionHandler:nil];
//    }
    
    [self saveCacheInfo];
}

@end
