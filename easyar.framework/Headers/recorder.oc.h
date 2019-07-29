//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_Recorder : easyar_RefBase

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (bool)isAvailable;
+ (void)requestPermissions:(easyar_CallbackScheduler *)callbackScheduler permissionCallback:(void (^)(easyar_PermissionStatus status, NSString * value))permissionCallback;
+ (easyar_Recorder *)create:(easyar_RecorderConfiguration *)config callbackScheduler:(easyar_CallbackScheduler *)callbackScheduler statusCallback:(void (^)(easyar_RecordStatus status, NSString * value))statusCallback;
- (void)start;
- (void)updateFrame:(easyar_TextureId *)texture width:(int)width height:(int)height;
- (void)stop;

@end
