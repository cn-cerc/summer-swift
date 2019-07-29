//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_Buffer : easyar_RefBase

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_Buffer *)create:(int)size;
- (void *)data;
- (int)size;
- (bool)copyFrom:(void *)src srcPos:(int)srcPos destPos:(int)destPos length:(int)length;

@end

@interface easyar_BufferDictionary : easyar_RefBase

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_BufferDictionary *) create;
- (int)count;
- (bool)contains:(NSString *)path;
- (easyar_Buffer *)tryGet:(NSString *)path;
- (void)set:(NSString *)path buffer:(easyar_Buffer *)buffer;
- (bool)remove:(NSString *)path;
- (void)clear;

@end
