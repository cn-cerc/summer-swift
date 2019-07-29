//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"
#import "easyar/targettracker.oc.h"

@interface easyar_ObjectTrackerResult : easyar_TargetTrackerResult

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (NSArray<easyar_TargetInstance *> *)targetInstances;

@end

@interface easyar_ObjectTracker : easyar_TargetTracker

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_ObjectTracker *) create;
+ (bool)isAvailable;
- (easyar_ObjectTrackerResult *)getResult:(easyar_Frame *)frame;
- (void)loadTarget:(easyar_Target *)target callbackScheduler:(easyar_CallbackScheduler *)callbackScheduler callback:(void (^)(easyar_Target * target, bool status))callback;
- (void)unloadTarget:(easyar_Target *)target callbackScheduler:(easyar_CallbackScheduler *)callbackScheduler callback:(void (^)(easyar_Target * target, bool status))callback;
- (bool)loadTargetBlocked:(easyar_Target *)target;
- (bool)unloadTargetBlocked:(easyar_Target *)target;
- (NSArray<easyar_Target *> *)targets;
- (bool)setSimultaneousNum:(int)num;
- (int)simultaneousNum;
- (bool)attachStreamer:(easyar_FrameStreamer *)obj;
- (bool)start;
- (bool)stop;

@end
