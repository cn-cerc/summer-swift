//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_TextureId : easyar_RefBase

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (int)getInt;
- (void *)getPointer;
+ (easyar_TextureId *)fromInt:(int)_value;
+ (easyar_TextureId *)fromPointer:(void *)ptr;

@end

@interface easyar_Renderer : easyar_RefBase

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_Renderer *) create;
- (void)chooseAPI:(easyar_RendererAPI)api;
- (void)setDevice:(void *)device;
- (bool)render:(easyar_Drawable *)frame viewPortAspectRatio:(float)viewPortAspectRatio screenRotation:(int)screenRotation;
- (bool)renderToTexture:(easyar_Drawable *)frame texture:(easyar_TextureId *)texture;
- (bool)renderErrorMessage:(float)viewPortAspectRatio screenRotation:(int)screenRotation;
- (bool)renderErrorMessageToTexture:(easyar_TextureId *)texture;

@end
