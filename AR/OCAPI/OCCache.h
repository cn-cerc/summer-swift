//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import <Foundation/Foundation.h>

@class OCARPreload;
@class OCStartSchema;
@class OCARBinding;
@class OCARTarget;
@class OCARAsset;

// OC 缓存类
@interface OCCache : NSObject

#pragma mark - OCARPreload
// 获取给定 schema id 的 preload 缓存信息
- (OCARPreload *)getPreloadBySchemaID:(NSString *)schemaID;
// 检查给定 preload 信息是否需要写入缓存
- (BOOL)shouldUpdateCacheForPreload:(OCARPreload*)preload;
// 将给定 preload 信息写入缓存
- (void)updatePreload:(OCARPreload *)preload;

#pragma mark - OCARStartSchema
// 获取给定 schema id 的缓存信息
- (OCStartSchema *)getSchemaBySchemaID:(NSString *)schemaID;
// 检查给定 schema 信息是否需要写入缓存
- (BOOL)shouldUpdateCacheForSchema:(OCStartSchema*)schema;
// 将给定 schema 信息写入缓存
- (void)updateSchema:(OCStartSchema *)schema;

//#pragma mark - OCARBinding
//- (OCARBinding *)getBindingByBindingID:(NSString *)bindingID;
//- (BOOL)shouldUpdateCacheForBinding:(OCARBinding*)binding;
//- (void)updateBinding:(OCARBinding *)binding;

#pragma mark - OCARTarget
//- (BOOL)isStillValidForImageOfTarget:(OCARTarget*)target;
// 检查给定 ar target 信息是否需要写入缓存
- (BOOL)shouldUpdateImageOfTarget:(OCARTarget*)target;

#pragma mark - OCARAsset
// 获取给定 content id 的资源缓存
- (OCARAsset *)getAssetByContentID:(NSString *)contentID;
// 检查给定 ar asset 是否仍然有效
- (BOOL)isStillValidForAsset:(OCARAsset*)asset;
// 将给定 ar asset 信息写入缓存
- (void)updateAsset:(OCARAsset *)asset;

#pragma mark - Misc
//- (NSString *)getLocalPathForURL:(NSString *)url;
// 清除缓存
- (void)clearCache;

@end
