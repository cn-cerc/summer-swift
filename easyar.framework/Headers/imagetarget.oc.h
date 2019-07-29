//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"
#import "easyar/target.oc.h"

@interface easyar_ImageTargetParameters : easyar_RefBase

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_ImageTargetParameters *) create;
- (easyar_Image *)image;
- (void)setImage:(easyar_Image *)image;
- (NSString *)name;
- (void)setName:(NSString *)name;
- (easyar_Vec2F *)size;
- (void)setSize:(easyar_Vec2F *)size;
- (NSString *)uid;
- (void)setUid:(NSString *)uid;
- (NSString *)meta;
- (void)setMeta:(NSString *)meta;

@end

@interface easyar_ImageTarget : easyar_Target

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_ImageTarget *) create;
+ (easyar_ImageTarget *)createFromParameters:(easyar_ImageTargetParameters *)parameters;
- (bool)setup:(NSString *)path storageType:(int)storageType name:(NSString *)name;
+ (NSArray<easyar_ImageTarget *> *)setupAll:(NSString *)path storageType:(int)storageType;
- (easyar_Vec2F *)size;
- (bool)setSize:(easyar_Vec2F *)size;
- (NSArray<easyar_Image *> *)images;
- (int)runtimeID;
- (NSString *)uid;
- (NSString *)name;
- (NSString *)meta;
- (void)setMeta:(NSString *)data;

@end
