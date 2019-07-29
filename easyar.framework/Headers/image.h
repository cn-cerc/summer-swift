//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_IMAGE_H__
#define __EASYAR_IMAGE_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_Image_buffer(const easyar_Image * This, /* OUT */ easyar_Buffer * * Return);
easyar_PixelFormat easyar_Image_format(const easyar_Image * This);
int easyar_Image_width(const easyar_Image * This);
int easyar_Image_height(const easyar_Image * This);
bool easyar_Image_empty(easyar_Image * This);
void easyar_Image_setTimeStamp(easyar_Image * This, double time);
void easyar_Image_create(easyar_Buffer * buffer, easyar_PixelFormat format, int width, int height, /* OUT */ easyar_Image * * Return);
void easyar_Image__dtor(easyar_Image * This);
void easyar_Image__retain(const easyar_Image * This, /* OUT */ easyar_Image * * Return);
const char * easyar_Image__typeName(const easyar_Image * This);

#ifdef __cplusplus
}
#endif

#endif
