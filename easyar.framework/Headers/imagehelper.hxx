//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_IMAGEHELPER_HXX__
#define __EASYAR_IMAGEHELPER_HXX__

#include "easyar/types.hxx"

namespace easyar {

class ImageHelper
{
public:
    static void decode(Buffer * buffer, /* OUT */ Image * * Return);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_IMAGEHELPER_HXX__
#define __IMPLEMENTATION_EASYAR_IMAGEHELPER_HXX__

#include "easyar/imagehelper.h"
#include "easyar/buffer.hxx"
#include "easyar/image.hxx"

namespace easyar {

inline void ImageHelper::decode(Buffer * arg0, /* OUT */ Image * * Return)
{
    easyar_Image * _return_value_ = NULL;
    easyar_ImageHelper_decode((arg0 == NULL ? NULL : arg0->get_cdata()), &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new Image(_return_value_));
}

}

#endif
