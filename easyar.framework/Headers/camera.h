//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_CAMERA_H__
#define __EASYAR_CAMERA_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_CameraParameters__ctor(/* OUT */ easyar_CameraParameters * * Return);
easyar_Vec2I easyar_CameraParameters_size(const easyar_CameraParameters * This);
easyar_Vec2F easyar_CameraParameters_focalLength(const easyar_CameraParameters * This);
easyar_Vec2F easyar_CameraParameters_principalPoint(const easyar_CameraParameters * This);
easyar_Vec4F easyar_CameraParameters_distortionParameters(const easyar_CameraParameters * This);
int easyar_CameraParameters_cameraOrientation(const easyar_CameraParameters * This);
easyar_CameraDeviceType easyar_CameraParameters_getCameraType(easyar_CameraParameters * This);
void easyar_CameraParameters_setCameraType(easyar_CameraParameters * This, easyar_CameraDeviceType type);
bool easyar_CameraParameters_getHorizontalFlip(easyar_CameraParameters * This);
void easyar_CameraParameters_setHorizontalFlip(easyar_CameraParameters * This, bool flip);
void easyar_CameraParameters_setSize(easyar_CameraParameters * This, easyar_Vec2I data);
void easyar_CameraParameters_setCalibration(easyar_CameraParameters * This, easyar_Vec2I size, easyar_Vec2F focalLength, easyar_Vec2F principalPoint, float k1, float k2, float p1, float p2);
void easyar_CameraParameters_setCameraOrientation(easyar_CameraParameters * This, int rotation);
int easyar_CameraParameters_imageOrientation(const easyar_CameraParameters * This, int screenRotation);
bool easyar_CameraParameters_imageHorizontalFlip(easyar_CameraParameters * This);
easyar_Matrix44F easyar_CameraParameters_projection(easyar_CameraParameters * This, float nearPlane, float farPlane, float viewportAspectRatio, int screenRotation, bool combiningFlip);
easyar_Matrix44F easyar_CameraParameters_imageProjection(easyar_CameraParameters * This, float viewportAspectRatio, int screenRotation, bool combiningFlip);
easyar_Vec2F easyar_CameraParameters_screenCoordinatesFromImageCoordinates(easyar_CameraParameters * This, float viewportAspectRatio, int screenRotation, bool combiningFlip, easyar_Vec2F imageCoordinates);
easyar_Vec2F easyar_CameraParameters_imageCoordinatesFromScreenCoordinates(easyar_CameraParameters * This, float viewportAspectRatio, int screenRotation, bool combiningFlip, easyar_Vec2F screenCoordinates);
bool easyar_CameraParameters_equalsTo(const easyar_CameraParameters * This, easyar_CameraParameters * other);
void easyar_CameraParameters__dtor(easyar_CameraParameters * This);
void easyar_CameraParameters__retain(const easyar_CameraParameters * This, /* OUT */ easyar_CameraParameters * * Return);
const char * easyar_CameraParameters__typeName(const easyar_CameraParameters * This);

void easyar_CameraDevice__ctor(/* OUT */ easyar_CameraDevice * * Return);
bool easyar_CameraDevice_start(easyar_CameraDevice * This);
bool easyar_CameraDevice_stop(easyar_CameraDevice * This);
void easyar_CameraDevice_setAndroidCameraApiType(easyar_CameraDevice * This, easyar_AndroidCameraApiType type);
void easyar_CameraDevice_requestPermissions(easyar_CallbackScheduler * callbackScheduler, easyar_FunctorOfVoidFromPermissionStatusAndString permissionCallback);
bool easyar_CameraDevice_openWithIndex(easyar_CameraDevice * This, int cameraIndex);
bool easyar_CameraDevice_openWithType(easyar_CameraDevice * This, easyar_CameraDeviceType type);
bool easyar_CameraDevice_close(easyar_CameraDevice * This);
bool easyar_CameraDevice_isOpened(easyar_CameraDevice * This);
easyar_Vec2I easyar_CameraDevice_size(const easyar_CameraDevice * This);
int easyar_CameraDevice_supportedSizeCount(const easyar_CameraDevice * This);
easyar_Vec2I easyar_CameraDevice_supportedSize(const easyar_CameraDevice * This, int idx);
bool easyar_CameraDevice_setSize(easyar_CameraDevice * This, easyar_Vec2I size);
float easyar_CameraDevice_zoomScale(const easyar_CameraDevice * This);
bool easyar_CameraDevice_setZoomScale(easyar_CameraDevice * This, float scale);
float easyar_CameraDevice_minZoomScale(const easyar_CameraDevice * This);
float easyar_CameraDevice_maxZoomScale(const easyar_CameraDevice * This);
int easyar_CameraDevice_supportedFrameRateRangeCount(const easyar_CameraDevice * This);
float easyar_CameraDevice_supportedFrameRateRangeLower(const easyar_CameraDevice * This, int index);
float easyar_CameraDevice_supportedFrameRateRangeUpper(const easyar_CameraDevice * This, int index);
int easyar_CameraDevice_frameRateRange(const easyar_CameraDevice * This);
bool easyar_CameraDevice_setFrameRateRange(easyar_CameraDevice * This, int index);
bool easyar_CameraDevice_setFlashTorchMode(easyar_CameraDevice * This, bool on);
bool easyar_CameraDevice_setFocusMode(easyar_CameraDevice * This, easyar_CameraDeviceFocusMode focusMode);
bool easyar_CameraDevice_autoFocus(easyar_CameraDevice * This);
bool easyar_CameraDevice_setPresentProfile(easyar_CameraDevice * This, easyar_CameraDevicePresetProfile profile);
void easyar_CameraDevice_setStateChangedCallback(easyar_CameraDevice * This, easyar_CallbackScheduler * callbackScheduler, easyar_FunctorOfVoidFromCameraState stateChangedCallback);
void easyar_CameraDevice__dtor(easyar_CameraDevice * This);
void easyar_CameraDevice__retain(const easyar_CameraDevice * This, /* OUT */ easyar_CameraDevice * * Return);
const char * easyar_CameraDevice__typeName(const easyar_CameraDevice * This);

#ifdef __cplusplus
}
#endif

#endif
