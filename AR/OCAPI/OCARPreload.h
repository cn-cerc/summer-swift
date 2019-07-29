//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import <Foundation/Foundation.h>
@class OCARTarget;

// OC 预设绑定类，解析所请求的 preload json 对象，并提供接口以查询相应字段，相应字段的含义及解释请参阅官方 OC 网页文档
@interface OCARPreload : NSObject
@property(strong, nonatomic)NSDictionary*result;// 序列化专用

@property(assign, nonatomic) BOOL                   active;
@property(strong, nonatomic) NSArray<NSString*>*    arbindingArray;
@property(strong, nonatomic) NSArray<NSString*>*    crsIdToStart;
@property(strong, nonatomic) NSString*              created;
@property(strong, nonatomic) NSString*              modified;
@property(assign, nonatomic) BOOL                   loadARBindings;
@property(assign, nonatomic) BOOL                   loadTargets;
@property(  copy, nonatomic) NSString*              name;
@property(  copy, nonatomic) NSString*              startSchemaId;
@property(strong, nonatomic) NSArray<OCARTarget*>*  targets;

// 解析给定 json 对象
-(instancetype)initWithResult:(NSDictionary*)result;
// 获取该信息是否有效
-(BOOL)isValid;
@end
