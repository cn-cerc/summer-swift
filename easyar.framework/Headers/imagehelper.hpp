//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_IMAGEHELPER_HPP__
#define __EASYAR_IMAGEHELPER_HPP__

#include "easyar/types.hpp"

namespace easyar {

class ImageHelper
{
public:
    static std::shared_ptr<Image> decode(std::shared_ptr<Buffer> buffer);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_IMAGEHELPER_HPP__
#define __IMPLEMENTATION_EASYAR_IMAGEHELPER_HPP__

#include "easyar/imagehelper.h"
#include "easyar/buffer.hpp"
#include "easyar/image.hpp"

namespace easyar {

inline std::shared_ptr<Image> ImageHelper::decode(std::shared_ptr<Buffer> arg0)
{
    easyar_Image * _return_value_;
    easyar_ImageHelper_decode((arg0 == nullptr ? nullptr : arg0->get_cdata().get()), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<Image>(std::shared_ptr<easyar_Image>(_return_value_, [](easyar_Image * ptr) { easyar_Image__dtor(ptr); })));
}

}

#endif
