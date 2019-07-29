//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_ANDROIDJNIUTILITY_H__
#define __EASYAR_ANDROIDJNIUTILITY_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

bool easyar_AndroidJniUtility_copyJniByteArrayToBuffer(void * src, int srcIndex, easyar_Buffer * dest, int destIndex, int length);
int easyar_AndroidJniUtility_getJniArrayLength(void * arr);

#ifdef __cplusplus
}
#endif

#endif
