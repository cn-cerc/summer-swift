//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_CameraParameters : easyar_RefBase

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_CameraParameters *) create;
- (easyar_Vec2I *)size;
- (easyar_Vec2F *)focalLength;
- (easyar_Vec2F *)principalPoint;
- (easyar_Vec4F *)distortionParameters;
- (int)cameraOrientation;
- (easyar_CameraDeviceType)getCameraType;
- (void)setCameraType:(easyar_CameraDeviceType)type;
- (bool)getHorizontalFlip;
- (void)setHorizontalFlip:(bool)flip;
- (void)setSize:(easyar_Vec2I *)data;
- (void)setCalibration:(easyar_Vec2I *)size focalLength:(easyar_Vec2F *)focalLength principalPoint:(easyar_Vec2F *)principalPoint k1:(float)k1 k2:(float)k2 p1:(float)p1 p2:(float)p2;
- (void)setCameraOrientation:(int)rotation;
- (int)imageOrientation:(int)screenRotation;
- (bool)imageHorizontalFlip;
- (easyar_Matrix44F *)projection:(float)nearPlane farPlane:(float)farPlane viewportAspectRatio:(float)viewportAspectRatio screenRotation:(int)screenRotation combiningFlip:(bool)combiningFlip;
- (easyar_Matrix44F *)imageProjection:(float)viewportAspectRatio screenRotation:(int)screenRotation combiningFlip:(bool)combiningFlip;
- (easyar_Vec2F *)screenCoordinatesFromImageCoordinates:(float)viewportAspectRatio screenRotation:(int)screenRotation combiningFlip:(bool)combiningFlip imageCoordinates:(easyar_Vec2F *)imageCoordinates;
- (easyar_Vec2F *)imageCoordinatesFromScreenCoordinates:(float)viewportAspectRatio screenRotation:(int)screenRotation combiningFlip:(bool)combiningFlip screenCoordinates:(easyar_Vec2F *)screenCoordinates;
- (bool)equalsTo:(easyar_CameraParameters *)other;

@end

@interface easyar_CameraDevice : easyar_RefBase

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_CameraDevice *) create;
- (bool)start;
- (bool)stop;
- (void)setAndroidCameraApiType:(easyar_AndroidCameraApiType)type;
+ (void)requestPermissions:(easyar_CallbackScheduler *)callbackScheduler permissionCallback:(void (^)(easyar_PermissionStatus status, NSString * value))permissionCallback;
- (bool)openWithIndex:(int)cameraIndex;
- (bool)openWithType:(easyar_CameraDeviceType)type;
- (bool)close;
- (bool)isOpened;
- (easyar_Vec2I *)size;
- (int)supportedSizeCount;
- (easyar_Vec2I *)supportedSize:(int)idx;
- (bool)setSize:(easyar_Vec2I *)size;
- (float)zoomScale;
- (bool)setZoomScale:(float)scale;
- (float)minZoomScale;
- (float)maxZoomScale;
- (int)supportedFrameRateRangeCount;
- (float)supportedFrameRateRangeLower:(int)index;
- (float)supportedFrameRateRangeUpper:(int)index;
- (int)frameRateRange;
- (bool)setFrameRateRange:(int)index;
- (bool)setFlashTorchMode:(bool)on;
- (bool)setFocusMode:(easyar_CameraDeviceFocusMode)focusMode;
- (bool)autoFocus;
- (bool)setPresentProfile:(easyar_CameraDevicePresetProfile)profile;
- (void)setStateChangedCallback:(easyar_CallbackScheduler *)callbackScheduler stateChangedCallback:(void (^)(easyar_CameraState status))stateChangedCallback;

@end
