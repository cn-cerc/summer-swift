//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import <Foundation/Foundation.h>

// OC ar 绑定关系类，解析所给定的 json 对象，并提供接口以查询相应字段，相应字段的含义及解释请参阅官方 OC 网页文档
@interface OCARBinding : NSObject
@property(strong, nonatomic)NSDictionary*result;// 序列化专用

@property(assign, nonatomic)BOOL active;
@property(copy, nonatomic)NSString* arbindingId;
@property(copy, nonatomic)NSString* contentId;
@property(copy, nonatomic)NSString* crsId;
@property(strong, nonatomic)NSString* created;
@property(strong, nonatomic)NSString* modified;
@property(copy, nonatomic)NSString* name;
@property(copy, nonatomic)NSString* targetId;
@property(copy, nonatomic)NSString* targetType;

// 解析给定 json 对象
-(instancetype)initWithResult:(NSDictionary*)result;
// 获取该信息是否有效
-(BOOL)isValid;
@end
