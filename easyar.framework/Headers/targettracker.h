//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_TARGETTRACKER_H__
#define __EASYAR_TARGETTRACKER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_TargetTrackerResult_targetInstances(const easyar_TargetTrackerResult * This, /* OUT */ easyar_ListOfPointerOfTargetInstance * * Return);
void easyar_TargetTrackerResult__dtor(easyar_TargetTrackerResult * This);
void easyar_TargetTrackerResult__retain(const easyar_TargetTrackerResult * This, /* OUT */ easyar_TargetTrackerResult * * Return);
const char * easyar_TargetTrackerResult__typeName(const easyar_TargetTrackerResult * This);

void easyar_TargetTracker_loadTarget(easyar_TargetTracker * This, easyar_Target * target, easyar_CallbackScheduler * callbackScheduler, easyar_FunctorOfVoidFromPointerOfTargetAndBool callback);
void easyar_TargetTracker_unloadTarget(easyar_TargetTracker * This, easyar_Target * target, easyar_CallbackScheduler * callbackScheduler, easyar_FunctorOfVoidFromPointerOfTargetAndBool callback);
bool easyar_TargetTracker_loadTargetBlocked(easyar_TargetTracker * This, easyar_Target * target);
bool easyar_TargetTracker_unloadTargetBlocked(easyar_TargetTracker * This, easyar_Target * target);
void easyar_TargetTracker_targets(easyar_TargetTracker * This, /* OUT */ easyar_ListOfPointerOfTarget * * Return);
bool easyar_TargetTracker_setSimultaneousNum(easyar_TargetTracker * This, int num);
int easyar_TargetTracker_simultaneousNum(easyar_TargetTracker * This);
bool easyar_TargetTracker_attachStreamer(easyar_TargetTracker * This, easyar_FrameStreamer * obj);
bool easyar_TargetTracker_start(easyar_TargetTracker * This);
bool easyar_TargetTracker_stop(easyar_TargetTracker * This);
void easyar_TargetTracker__dtor(easyar_TargetTracker * This);
void easyar_TargetTracker__retain(const easyar_TargetTracker * This, /* OUT */ easyar_TargetTracker * * Return);
const char * easyar_TargetTracker__typeName(const easyar_TargetTracker * This);
void easyar_castTargetTrackerToFrameFilter(const easyar_TargetTracker * This, /* OUT */ easyar_FrameFilter * * Return);
void easyar_tryCastFrameFilterToTargetTracker(const easyar_FrameFilter * This, /* OUT */ easyar_TargetTracker * * Return);

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
