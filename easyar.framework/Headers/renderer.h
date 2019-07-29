//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_RENDERER_H__
#define __EASYAR_RENDERER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

int easyar_TextureId_getInt(easyar_TextureId * This);
void * easyar_TextureId_getPointer(easyar_TextureId * This);
void easyar_TextureId_fromInt(int _value, /* OUT */ easyar_TextureId * * Return);
void easyar_TextureId_fromPointer(void * ptr, /* OUT */ easyar_TextureId * * Return);
void easyar_TextureId__dtor(easyar_TextureId * This);
void easyar_TextureId__retain(const easyar_TextureId * This, /* OUT */ easyar_TextureId * * Return);
const char * easyar_TextureId__typeName(const easyar_TextureId * This);

void easyar_Renderer__ctor(/* OUT */ easyar_Renderer * * Return);
void easyar_Renderer_chooseAPI(easyar_Renderer * This, easyar_RendererAPI api);
void easyar_Renderer_setDevice(easyar_Renderer * This, void * device);
bool easyar_Renderer_render(easyar_Renderer * This, easyar_Drawable * frame, float viewPortAspectRatio, int screenRotation);
bool easyar_Renderer_renderToTexture(easyar_Renderer * This, easyar_Drawable * frame, easyar_TextureId * texture);
bool easyar_Renderer_renderErrorMessage(easyar_Renderer * This, float viewPortAspectRatio, int screenRotation);
bool easyar_Renderer_renderErrorMessageToTexture(easyar_Renderer * This, easyar_TextureId * texture);
void easyar_Renderer__dtor(easyar_Renderer * This);
void easyar_Renderer__retain(const easyar_Renderer * This, /* OUT */ easyar_Renderer * * Return);
const char * easyar_Renderer__typeName(const easyar_Renderer * This);

#ifdef __cplusplus
}
#endif

#endif
