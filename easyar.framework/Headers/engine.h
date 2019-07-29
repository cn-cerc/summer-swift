﻿//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_ENGINE_H__
#define __EASYAR_ENGINE_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

int easyar_Engine_schemaHash();
bool easyar_Engine_initialize(easyar_String * key);
void easyar_Engine_onPause();
void easyar_Engine_onResume();
void easyar_Engine_errorMessage(/* OUT */ easyar_String * * Return);
void easyar_Engine_versionString(/* OUT */ easyar_String * * Return);
void easyar_Engine_name(/* OUT */ easyar_String * * Return);

#ifdef __cplusplus
}
#endif

#endif
