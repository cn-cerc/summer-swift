//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_FrameStreamer : easyar_RefBase

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (easyar_Frame *)peek;
- (bool)start;
- (bool)stop;
- (void)setCameraParameters:(easyar_CameraParameters *)cameraParameters;
- (easyar_CameraParameters *)cameraParameters;

@end

@interface easyar_CameraFrameStreamer : easyar_FrameStreamer

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_CameraFrameStreamer *) create;
- (bool)attachCamera:(easyar_CameraDevice *)obj;
- (easyar_Frame *)peek;
- (bool)start;
- (bool)stop;
- (void)setCameraParameters:(easyar_CameraParameters *)cameraParameters;
- (easyar_CameraParameters *)cameraParameters;

@end

@interface easyar_ExternalFrameStreamer : easyar_FrameStreamer

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_ExternalFrameStreamer *) create;
- (bool)input:(easyar_Image *)image;
- (easyar_Frame *)peek;
- (bool)start;
- (bool)stop;
- (void)setCameraParameters:(easyar_CameraParameters *)cameraParameters;
- (easyar_CameraParameters *)cameraParameters;

@end
