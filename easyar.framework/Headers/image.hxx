﻿//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_IMAGE_HXX__
#define __EASYAR_IMAGE_HXX__

#include "easyar/types.hxx"

namespace easyar {

class Image
{
protected:
    easyar_Image * cdata_ ;
    void init_cdata(easyar_Image * cdata);
    virtual Image & operator=(const Image & data) { return *this; } //deleted
public:
    Image(easyar_Image * cdata);
    virtual ~Image();

    Image(const Image & data);
    const easyar_Image * get_cdata() const;
    easyar_Image * get_cdata();

    void buffer(/* OUT */ Buffer * * Return);
    PixelFormat format();
    int width();
    int height();
    bool empty();
    void setTimeStamp(double time);
    static void create(Buffer * buffer, PixelFormat format, int width, int height, /* OUT */ Image * * Return);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_IMAGE_HXX__
#define __IMPLEMENTATION_EASYAR_IMAGE_HXX__

#include "easyar/image.h"
#include "easyar/buffer.hxx"

namespace easyar {

inline Image::Image(easyar_Image * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline Image::~Image()
{
    if (cdata_) {
        easyar_Image__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline Image::Image(const Image & data)
    :
    cdata_(NULL)
{
    easyar_Image * cdata = NULL;
    easyar_Image__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_Image * Image::get_cdata() const
{
    return cdata_;
}
inline easyar_Image * Image::get_cdata()
{
    return cdata_;
}
inline void Image::init_cdata(easyar_Image * cdata)
{
    cdata_ = cdata;
}
inline void Image::buffer(/* OUT */ Buffer * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_Buffer * _return_value_ = NULL;
    easyar_Image_buffer(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new Buffer(_return_value_));
}
inline PixelFormat Image::format()
{
    if (cdata_ == NULL) {
        return PixelFormat();
    }
    easyar_PixelFormat _return_value_ = easyar_Image_format(cdata_);
    return static_cast<PixelFormat>(_return_value_);
}
inline int Image::width()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_Image_width(cdata_);
    return _return_value_;
}
inline int Image::height()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_Image_height(cdata_);
    return _return_value_;
}
inline bool Image::empty()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Image_empty(cdata_);
    return _return_value_;
}
inline void Image::setTimeStamp(double arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Image_setTimeStamp(cdata_, arg0);
}
inline void Image::create(Buffer * arg0, PixelFormat arg1, int arg2, int arg3, /* OUT */ Image * * Return)
{
    easyar_Image * _return_value_ = NULL;
    easyar_Image_create((arg0 == NULL ? NULL : arg0->get_cdata()), static_cast<easyar_PixelFormat>(arg1), arg2, arg3, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new Image(_return_value_));
}

}

#endif
