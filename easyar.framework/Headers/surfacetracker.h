//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_SURFACETRACKER_H__
#define __EASYAR_SURFACETRACKER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

easyar_Matrix44F easyar_SurfaceTrackerResult_transform(const easyar_SurfaceTrackerResult * This);
easyar_TargetStatus easyar_SurfaceTrackerResult_status(const easyar_SurfaceTrackerResult * This);
void easyar_SurfaceTrackerResult__dtor(easyar_SurfaceTrackerResult * This);
void easyar_SurfaceTrackerResult__retain(const easyar_SurfaceTrackerResult * This, /* OUT */ easyar_SurfaceTrackerResult * * Return);
const char * easyar_SurfaceTrackerResult__typeName(const easyar_SurfaceTrackerResult * This);

void easyar_SurfaceTracker__ctor(/* OUT */ easyar_SurfaceTracker * * Return);
bool easyar_SurfaceTracker_isAvailable();
void easyar_SurfaceTracker_alignTargetToCameraImagePoint(easyar_SurfaceTracker * This, easyar_Vec2F cameraImagePoint);
void easyar_SurfaceTracker_getResult(const easyar_SurfaceTracker * This, easyar_Frame * frame, /* OUT */ easyar_SurfaceTrackerResult * * Return);
bool easyar_SurfaceTracker_attachStreamer(easyar_SurfaceTracker * This, easyar_FrameStreamer * obj);
bool easyar_SurfaceTracker_start(easyar_SurfaceTracker * This);
bool easyar_SurfaceTracker_stop(easyar_SurfaceTracker * This);
void easyar_SurfaceTracker__dtor(easyar_SurfaceTracker * This);
void easyar_SurfaceTracker__retain(const easyar_SurfaceTracker * This, /* OUT */ easyar_SurfaceTracker * * Return);
const char * easyar_SurfaceTracker__typeName(const easyar_SurfaceTracker * This);
void easyar_castSurfaceTrackerToFrameFilter(const easyar_SurfaceTracker * This, /* OUT */ easyar_FrameFilter * * Return);
void easyar_tryCastFrameFilterToSurfaceTracker(const easyar_FrameFilter * This, /* OUT */ easyar_SurfaceTracker * * Return);

#ifdef __cplusplus
}
#endif

#endif
