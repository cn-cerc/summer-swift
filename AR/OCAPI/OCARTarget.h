//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import <Foundation/Foundation.h>

// OC ar 识别图类，解析所给定的 json 对象，并提供接口以查询相应字段，相应字段的含义及解释请参阅官方 OC 网页文档
@interface OCARTarget : NSObject

@property(assign, nonatomic) BOOL active;
@property(strong, nonatomic) NSString* created;
@property(strong, nonatomic) NSString* modified;
@property(assign, nonatomic) NSInteger grade;
@property(strong, nonatomic) NSData* image;
@property(  copy, nonatomic) NSString* imageUrl;
@property(  copy, nonatomic) NSString* meta;
@property(  copy, nonatomic) NSString* name;
@property(  copy, nonatomic) NSString* size;
@property(  copy, nonatomic) NSString* targetId;
@property(  copy, nonatomic) NSString* type;

// 解析给定 json 对象
-(instancetype)initWithResult:(NSDictionary*)result;
// 解析给定 json 对象，并根据是否为 image url 对结果使用不同的处理方式
-(instancetype)initWithResult:(NSDictionary*)result isImageURL:(BOOL)isImageURL;
// 获取该信息是否有效
-(BOOL)isValid;

// 获取该识别图的本地绝对路径
-(NSString*)localAbsolutePath;

//inner used, pls do not use
-(void)downloadContentToLocalPath:(NSString*)localPath force:(BOOL)force completionHandler:(void(^)(NSError*error))completionHandler;
-(void)downloadContentToLocalPath:(NSString*)localPath force:(BOOL)force completionHandler:(void(^)(NSError*error))completionHandler progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler;
//-(void)saveContentToLocalPath:(NSString*)localPath;
-(void)loadLocalImageFile;
@end
