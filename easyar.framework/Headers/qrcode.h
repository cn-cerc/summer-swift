//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_QRCODE_H__
#define __EASYAR_QRCODE_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_QRCodeScannerResult_text(easyar_QRCodeScannerResult * This, /* OUT */ easyar_String * * Return);
void easyar_QRCodeScannerResult__dtor(easyar_QRCodeScannerResult * This);
void easyar_QRCodeScannerResult__retain(const easyar_QRCodeScannerResult * This, /* OUT */ easyar_QRCodeScannerResult * * Return);
const char * easyar_QRCodeScannerResult__typeName(const easyar_QRCodeScannerResult * This);

void easyar_QRCodeScanner__ctor(/* OUT */ easyar_QRCodeScanner * * Return);
bool easyar_QRCodeScanner_isAvailable();
void easyar_QRCodeScanner_getResult(const easyar_QRCodeScanner * This, easyar_Frame * frame, /* OUT */ easyar_QRCodeScannerResult * * Return);
bool easyar_QRCodeScanner_attachStreamer(easyar_QRCodeScanner * This, easyar_FrameStreamer * obj);
bool easyar_QRCodeScanner_start(easyar_QRCodeScanner * This);
bool easyar_QRCodeScanner_stop(easyar_QRCodeScanner * This);
void easyar_QRCodeScanner__dtor(easyar_QRCodeScanner * This);
void easyar_QRCodeScanner__retain(const easyar_QRCodeScanner * This, /* OUT */ easyar_QRCodeScanner * * Return);
const char * easyar_QRCodeScanner__typeName(const easyar_QRCodeScanner * This);
void easyar_castQRCodeScannerToFrameFilter(const easyar_QRCodeScanner * This, /* OUT */ easyar_FrameFilter * * Return);
void easyar_tryCastFrameFilterToQRCodeScanner(const easyar_FrameFilter * This, /* OUT */ easyar_QRCodeScanner * * Return);

#ifdef __cplusplus
}
#endif

#endif
