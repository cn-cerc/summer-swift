//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_IMAGETRACKER_H__
#define __EASYAR_IMAGETRACKER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_ImageTrackerResult_targetInstances(const easyar_ImageTrackerResult * This, /* OUT */ easyar_ListOfPointerOfTargetInstance * * Return);
void easyar_ImageTrackerResult__dtor(easyar_ImageTrackerResult * This);
void easyar_ImageTrackerResult__retain(const easyar_ImageTrackerResult * This, /* OUT */ easyar_ImageTrackerResult * * Return);
const char * easyar_ImageTrackerResult__typeName(const easyar_ImageTrackerResult * This);
void easyar_castImageTrackerResultToTargetTrackerResult(const easyar_ImageTrackerResult * This, /* OUT */ easyar_TargetTrackerResult * * Return);
void easyar_tryCastTargetTrackerResultToImageTrackerResult(const easyar_TargetTrackerResult * This, /* OUT */ easyar_ImageTrackerResult * * Return);

void easyar_ImageTracker__ctor(/* OUT */ easyar_ImageTracker * * Return);
bool easyar_ImageTracker_isAvailable();
void easyar_ImageTracker_createWithMode(easyar_ImageTrackerMode mode, /* OUT */ easyar_ImageTracker * * Return);
void easyar_ImageTracker_getResult(const easyar_ImageTracker * This, easyar_Frame * frame, /* OUT */ easyar_ImageTrackerResult * * Return);
void easyar_ImageTracker_loadTarget(easyar_ImageTracker * This, easyar_Target * target, easyar_CallbackScheduler * callbackScheduler, easyar_FunctorOfVoidFromPointerOfTargetAndBool callback);
void easyar_ImageTracker_unloadTarget(easyar_ImageTracker * This, easyar_Target * target, easyar_CallbackScheduler * callbackScheduler, easyar_FunctorOfVoidFromPointerOfTargetAndBool callback);
bool easyar_ImageTracker_loadTargetBlocked(easyar_ImageTracker * This, easyar_Target * target);
bool easyar_ImageTracker_unloadTargetBlocked(easyar_ImageTracker * This, easyar_Target * target);
void easyar_ImageTracker_targets(easyar_ImageTracker * This, /* OUT */ easyar_ListOfPointerOfTarget * * Return);
bool easyar_ImageTracker_setSimultaneousNum(easyar_ImageTracker * This, int num);
int easyar_ImageTracker_simultaneousNum(easyar_ImageTracker * This);
bool easyar_ImageTracker_attachStreamer(easyar_ImageTracker * This, easyar_FrameStreamer * obj);
bool easyar_ImageTracker_start(easyar_ImageTracker * This);
bool easyar_ImageTracker_stop(easyar_ImageTracker * This);
void easyar_ImageTracker__dtor(easyar_ImageTracker * This);
void easyar_ImageTracker__retain(const easyar_ImageTracker * This, /* OUT */ easyar_ImageTracker * * Return);
const char * easyar_ImageTracker__typeName(const easyar_ImageTracker * This);
void easyar_castImageTrackerToFrameFilter(const easyar_ImageTracker * This, /* OUT */ easyar_FrameFilter * * Return);
void easyar_tryCastFrameFilterToImageTracker(const easyar_FrameFilter * This, /* OUT */ easyar_ImageTracker * * Return);
void easyar_castImageTrackerToTargetTracker(const easyar_ImageTracker * This, /* OUT */ easyar_TargetTracker * * Return);
void easyar_tryCastTargetTrackerToImageTracker(const easyar_TargetTracker * This, /* OUT */ easyar_ImageTracker * * Return);

void easyar_ListOfPointerOfTargetInstance__ctor(easyar_TargetInstance * const * begin, easyar_TargetInstance * const * end, /* OUT */ easyar_ListOfPointerOfTargetInstance * * Return);
void easyar_ListOfPointerOfTargetInstance__dtor(easyar_ListOfPointerOfTargetInstance * This);
void easyar_ListOfPointerOfTargetInstance_copy(const easyar_ListOfPointerOfTargetInstance * This, /* OUT */ easyar_ListOfPointerOfTargetInstance * * Return);
int easyar_ListOfPointerOfTargetInstance_size(const easyar_ListOfPointerOfTargetInstance * This);
easyar_TargetInstance * easyar_ListOfPointerOfTargetInstance_at(const easyar_ListOfPointerOfTargetInstance * This, int index);

void easyar_ListOfPointerOfTarget__ctor(easyar_Target * const * begin, easyar_Target * const * end, /* OUT */ easyar_ListOfPointerOfTarget * * Return);
void easyar_ListOfPointerOfTarget__dtor(easyar_ListOfPointerOfTarget * This);
void easyar_ListOfPointerOfTarget_copy(const easyar_ListOfPointerOfTarget * This, /* OUT */ easyar_ListOfPointerOfTarget * * Return);
int easyar_ListOfPointerOfTarget_size(const easyar_ListOfPointerOfTarget * This);
easyar_Target * easyar_ListOfPointerOfTarget_at(const easyar_ListOfPointerOfTarget * This, int index);

#ifdef __cplusplus
}
#endif

#endif
