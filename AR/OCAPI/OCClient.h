//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import <Foundation/Foundation.h>
#import "OCStartSchema.h"
#import "OCARBinding.h"
#import "OCARTarget.h"
#import "OCARAsset.h"
#import "OCARPreload.h"

// OC 客户端类
@interface OCClient : NSObject
+ (instancetype)sharedClient;

// 设置 OC 服务器地址
- (void)setServerAddress:(NSString *)baseURL;
// 设置 OC 客户端 key 和 secret
- (void)setServerAccessKey:(NSString *)key secret:(NSString *)secret;

// 向 OC 服务器发送请求，获取给定 scheme id 的全部信息
-(void)loadStartSchema:(NSString*)startSchemaID completionHandler:(void (^)(OCStartSchema *startSchema))completionHandler;
-(void)loadStartSchema:(NSString*)startSchemaID completionHandler:(void (^)(OCStartSchema *startSchema, NSError *error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler;

// 向 OC 服务器发送请求，获取给定 schema id 的 preload 信息
-(void)preloadForStartSchema:(NSString*)startSchemaID completionHandler:(void (^)(OCARPreload *preload))completionHandler;
-(void)preloadForStartSchema:(NSString*)startSchemaID completionHandler:(void (^)(OCARPreload *preload, NSError *error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler;

//-(void)loadARBinding:(NSString*)bindingID completionHandler:(void (^)(OCARBinding *binding))completionHandler;
//-(void)loadARBinding:(NSString*)bindingID completionHandler:(void (^)(OCARBinding *binding, NSError *error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler;

//-(void)loadARTarget:(NSString*)targetID completionHandler:(void (^)(OCARTarget *target))completionHandler;
//-(void)loadARTarget:(NSString*)targetID completionHandler:(void (^)(OCARTarget *target, NSError *error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler;

// 向 OC 服务器发送请求，获取给定 content id 的内容包数据
-(void)loadARAsset:(NSString*)contentID completionHandler:(void (^)(OCARAsset *asset))completionHandler;
-(void)loadARAsset:(NSString*)contentID completionHandler:(void (^)(OCARAsset *asset, NSError *error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler;

// 向 OC 服务器发送请求，获取给定 ar target 的识别图数据
-(void)downloadImageForARTarget:(OCARTarget*)target completionHandler:(void (^)(OCARTarget *target, NSError *error))completionHandler;
-(void)downloadImageForARTarget:(OCARTarget*)target completionHandler:(void (^)(OCARTarget *target, NSError *error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler;

@end
