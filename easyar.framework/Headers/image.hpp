//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_IMAGE_HPP__
#define __EASYAR_IMAGE_HPP__

#include "easyar/types.hpp"

namespace easyar {

class Image
{
protected:
    std::shared_ptr<easyar_Image> cdata_;
    void init_cdata(std::shared_ptr<easyar_Image> cdata);
    Image & operator=(const Image & data) = delete;
public:
    Image(std::shared_ptr<easyar_Image> cdata);
    virtual ~Image();

    std::shared_ptr<easyar_Image> get_cdata();

    std::shared_ptr<Buffer> buffer();
    PixelFormat format();
    int width();
    int height();
    bool empty();
    void setTimeStamp(double time);
    static std::shared_ptr<Image> create(std::shared_ptr<Buffer> buffer, PixelFormat format, int width, int height);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_IMAGE_HPP__
#define __IMPLEMENTATION_EASYAR_IMAGE_HPP__

#include "easyar/image.h"
#include "easyar/buffer.hpp"

namespace easyar {

inline Image::Image(std::shared_ptr<easyar_Image> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline Image::~Image()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_Image> Image::get_cdata()
{
    return cdata_;
}
inline void Image::init_cdata(std::shared_ptr<easyar_Image> cdata)
{
    cdata_ = cdata;
}
inline std::shared_ptr<Buffer> Image::buffer()
{
    easyar_Buffer * _return_value_;
    easyar_Image_buffer(cdata_.get(), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<Buffer>(std::shared_ptr<easyar_Buffer>(_return_value_, [](easyar_Buffer * ptr) { easyar_Buffer__dtor(ptr); })));
}
inline PixelFormat Image::format()
{
    auto _return_value_ = easyar_Image_format(cdata_.get());
    return static_cast<PixelFormat>(_return_value_);
}
inline int Image::width()
{
    auto _return_value_ = easyar_Image_width(cdata_.get());
    return _return_value_;
}
inline int Image::height()
{
    auto _return_value_ = easyar_Image_height(cdata_.get());
    return _return_value_;
}
inline bool Image::empty()
{
    auto _return_value_ = easyar_Image_empty(cdata_.get());
    return _return_value_;
}
inline void Image::setTimeStamp(double arg0)
{
    easyar_Image_setTimeStamp(cdata_.get(), arg0);
}
inline std::shared_ptr<Image> Image::create(std::shared_ptr<Buffer> arg0, PixelFormat arg1, int arg2, int arg3)
{
    easyar_Image * _return_value_;
    easyar_Image_create((arg0 == nullptr ? nullptr : arg0->get_cdata().get()), static_cast<easyar_PixelFormat>(arg1), arg2, arg3, &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<Image>(std::shared_ptr<easyar_Image>(_return_value_, [](easyar_Image * ptr) { easyar_Image__dtor(ptr); })));
}

}

#endif
