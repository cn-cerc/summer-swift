//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_FRAMESTREAMER_H__
#define __EASYAR_FRAMESTREAMER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_FrameStreamer_peek(easyar_FrameStreamer * This, /* OUT */ easyar_Frame * * Return);
bool easyar_FrameStreamer_start(easyar_FrameStreamer * This);
bool easyar_FrameStreamer_stop(easyar_FrameStreamer * This);
void easyar_FrameStreamer_setCameraParameters(easyar_FrameStreamer * This, easyar_CameraParameters * cameraParameters);
void easyar_FrameStreamer_cameraParameters(easyar_FrameStreamer * This, /* OUT */ easyar_CameraParameters * * Return);
void easyar_FrameStreamer__dtor(easyar_FrameStreamer * This);
void easyar_FrameStreamer__retain(const easyar_FrameStreamer * This, /* OUT */ easyar_FrameStreamer * * Return);
const char * easyar_FrameStreamer__typeName(const easyar_FrameStreamer * This);

void easyar_CameraFrameStreamer__ctor(/* OUT */ easyar_CameraFrameStreamer * * Return);
bool easyar_CameraFrameStreamer_attachCamera(easyar_CameraFrameStreamer * This, easyar_CameraDevice * obj);
void easyar_CameraFrameStreamer_peek(easyar_CameraFrameStreamer * This, /* OUT */ easyar_Frame * * Return);
bool easyar_CameraFrameStreamer_start(easyar_CameraFrameStreamer * This);
bool easyar_CameraFrameStreamer_stop(easyar_CameraFrameStreamer * This);
void easyar_CameraFrameStreamer_setCameraParameters(easyar_CameraFrameStreamer * This, easyar_CameraParameters * cameraParameters);
void easyar_CameraFrameStreamer_cameraParameters(easyar_CameraFrameStreamer * This, /* OUT */ easyar_CameraParameters * * Return);
void easyar_CameraFrameStreamer__dtor(easyar_CameraFrameStreamer * This);
void easyar_CameraFrameStreamer__retain(const easyar_CameraFrameStreamer * This, /* OUT */ easyar_CameraFrameStreamer * * Return);
const char * easyar_CameraFrameStreamer__typeName(const easyar_CameraFrameStreamer * This);
void easyar_castCameraFrameStreamerToFrameStreamer(const easyar_CameraFrameStreamer * This, /* OUT */ easyar_FrameStreamer * * Return);
void easyar_tryCastFrameStreamerToCameraFrameStreamer(const easyar_FrameStreamer * This, /* OUT */ easyar_CameraFrameStreamer * * Return);

void easyar_ExternalFrameStreamer__ctor(/* OUT */ easyar_ExternalFrameStreamer * * Return);
bool easyar_ExternalFrameStreamer_input(easyar_ExternalFrameStreamer * This, easyar_Image * image);
void easyar_ExternalFrameStreamer_peek(easyar_ExternalFrameStreamer * This, /* OUT */ easyar_Frame * * Return);
bool easyar_ExternalFrameStreamer_start(easyar_ExternalFrameStreamer * This);
bool easyar_ExternalFrameStreamer_stop(easyar_ExternalFrameStreamer * This);
void easyar_ExternalFrameStreamer_setCameraParameters(easyar_ExternalFrameStreamer * This, easyar_CameraParameters * cameraParameters);
void easyar_ExternalFrameStreamer_cameraParameters(easyar_ExternalFrameStreamer * This, /* OUT */ easyar_CameraParameters * * Return);
void easyar_ExternalFrameStreamer__dtor(easyar_ExternalFrameStreamer * This);
void easyar_ExternalFrameStreamer__retain(const easyar_ExternalFrameStreamer * This, /* OUT */ easyar_ExternalFrameStreamer * * Return);
const char * easyar_ExternalFrameStreamer__typeName(const easyar_ExternalFrameStreamer * This);
void easyar_castExternalFrameStreamerToFrameStreamer(const easyar_ExternalFrameStreamer * This, /* OUT */ easyar_FrameStreamer * * Return);
void easyar_tryCastFrameStreamerToExternalFrameStreamer(const easyar_FrameStreamer * This, /* OUT */ easyar_ExternalFrameStreamer * * Return);

#ifdef __cplusplus
}
#endif

#endif
