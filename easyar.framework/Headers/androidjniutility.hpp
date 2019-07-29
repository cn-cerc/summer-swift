//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_ANDROIDJNIUTILITY_HPP__
#define __EASYAR_ANDROIDJNIUTILITY_HPP__

#include "easyar/types.hpp"

namespace easyar {

class AndroidJniUtility
{
public:
    static bool copyJniByteArrayToBuffer(void * src, int srcIndex, std::shared_ptr<Buffer> dest, int destIndex, int length);
    static int getJniArrayLength(void * arr);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_ANDROIDJNIUTILITY_HPP__
#define __IMPLEMENTATION_EASYAR_ANDROIDJNIUTILITY_HPP__

#include "easyar/androidjniutility.h"
#include "easyar/buffer.hpp"

namespace easyar {

inline bool AndroidJniUtility::copyJniByteArrayToBuffer(void * arg0, int arg1, std::shared_ptr<Buffer> arg2, int arg3, int arg4)
{
    auto _return_value_ = easyar_AndroidJniUtility_copyJniByteArrayToBuffer(arg0, arg1, (arg2 == nullptr ? nullptr : arg2->get_cdata().get()), arg3, arg4);
    return _return_value_;
}
inline int AndroidJniUtility::getJniArrayLength(void * arg0)
{
    auto _return_value_ = easyar_AndroidJniUtility_getJniArrayLength(arg0);
    return _return_value_;
}

}

#endif
