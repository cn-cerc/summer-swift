//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import <Foundation/Foundation.h>
@class OCARBinding;

// OC 模式类，解析所请求的 schema json 对象，并提供接口以查询相应字段，相应字段的含义及解释请参阅官方 OC 网页文档
@interface OCStartSchema : NSObject

@property(strong, nonatomic)NSDictionary*result;// 序列化专用

@property(assign, nonatomic) BOOL loadARBindings;// 是否返回ARBinding信息，0不返回详细的ARBinding信息，1返回；默认为 0 不返回
@property(assign, nonatomic) BOOL loadTargets;
@property(assign, nonatomic) BOOL withDetails;// 是否返回详细的targetUrl和contentUrl信息，0不返回，1返回；默认为 0 不返回

@property(assign, nonatomic)BOOL active;
@property(strong, nonatomic)NSArray<OCARBinding*>*arbindings;
@property(strong, nonatomic)NSArray<NSString*>*arbindingArray;
@property(strong, nonatomic)NSArray<NSString*>*crsIdToStart;
@property(strong, nonatomic)NSString*created;
@property(strong, nonatomic)NSString*modified;
@property(copy, nonatomic)NSString*name;
@property(copy, nonatomic)NSString*startSchemaId;

// 解析给定 json 对象
-(instancetype)initWithResult:(NSDictionary*)result;
// 获取该信息是否有效
-(BOOL)isValid;

//-(void)arbindingForID:(NSString*)arbindingID;
@end
