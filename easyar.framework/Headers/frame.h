//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_FRAME_H__
#define __EASYAR_FRAME_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_Frame__ctor(/* OUT */ easyar_Frame * * Return);
double easyar_Frame_timestamp(const easyar_Frame * This);
int easyar_Frame_index(const easyar_Frame * This);
void easyar_Frame_images(const easyar_Frame * This, /* OUT */ easyar_ListOfPointerOfImage * * Return);
void easyar_Frame_cameraParameters(const easyar_Frame * This, /* OUT */ easyar_CameraParameters * * Return);
bool easyar_Frame_empty(const easyar_Frame * This);
void easyar_Frame__dtor(easyar_Frame * This);
void easyar_Frame__retain(const easyar_Frame * This, /* OUT */ easyar_Frame * * Return);
const char * easyar_Frame__typeName(const easyar_Frame * This);
void easyar_castFrameToDrawable(const easyar_Frame * This, /* OUT */ easyar_Drawable * * Return);
void easyar_tryCastDrawableToFrame(const easyar_Drawable * This, /* OUT */ easyar_Frame * * Return);

void easyar_ListOfPointerOfImage__ctor(easyar_Image * const * begin, easyar_Image * const * end, /* OUT */ easyar_ListOfPointerOfImage * * Return);
void easyar_ListOfPointerOfImage__dtor(easyar_ListOfPointerOfImage * This);
void easyar_ListOfPointerOfImage_copy(const easyar_ListOfPointerOfImage * This, /* OUT */ easyar_ListOfPointerOfImage * * Return);
int easyar_ListOfPointerOfImage_size(const easyar_ListOfPointerOfImage * This);
easyar_Image * easyar_ListOfPointerOfImage_at(const easyar_ListOfPointerOfImage * This, int index);

#ifdef __cplusplus
}
#endif

#endif
