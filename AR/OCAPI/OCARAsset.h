//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import <Foundation/Foundation.h>

// OC ar 资源包类，解析所请求的 ar asset json 对象，并提供接口以查询相应字段，相应字段的含义及解释请参阅官方 OC 网页文档
@interface OCARAsset : NSObject

@property(strong, nonatomic)NSDictionary*result;

@property(assign, nonatomic)BOOL        active;
@property(  copy, nonatomic)NSString*   contentId;
@property(assign, nonatomic)NSInteger   fileSize;
@property(  copy, nonatomic)NSString*   fileType;
@property(  copy, nonatomic)NSString*   key;
@property(strong, nonatomic)NSString*   modified;
@property(  copy, nonatomic)NSString*   resourceUrl;

// 解析给定 json 对象
-(instancetype)initWithResult:(NSDictionary*)result;
// 获取该信息是否有效
-(BOOL)isValid;

// 获取该资源包的本地绝对路径
-(NSString*)localAbsolutePath;

//inner used, pls do not use
-(void)downloadContentToLocalPath:(NSString*)localPath force:(BOOL)force completionHandler:(void(^)(NSError*error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress))progressHandler;

@end
