//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_FRAME_HXX__
#define __EASYAR_FRAME_HXX__

#include "easyar/types.hxx"
#include "easyar/drawable.hxx"

namespace easyar {

class Frame : public Drawable
{
protected:
    easyar_Frame * cdata_ ;
    void init_cdata(easyar_Frame * cdata);
    virtual Frame & operator=(const Frame & data) { return *this; } //deleted
public:
    Frame(easyar_Frame * cdata);
    virtual ~Frame();

    Frame(const Frame & data);
    const easyar_Frame * get_cdata() const;
    easyar_Frame * get_cdata();

    Frame();
    double timestamp();
    int index();
    void images(/* OUT */ ListOfPointerOfImage * * Return);
    void cameraParameters(/* OUT */ CameraParameters * * Return);
    bool empty();
    static void tryCastFromDrawable(Drawable * v, /* OUT */ Frame * * Return);
};

#ifndef __EASYAR_LISTOFPOINTEROFIMAGE__
#define __EASYAR_LISTOFPOINTEROFIMAGE__
class ListOfPointerOfImage
{
private:
    easyar_ListOfPointerOfImage * cdata_;
    virtual ListOfPointerOfImage & operator=(const ListOfPointerOfImage & data) { return *this; } //deleted
public:
    ListOfPointerOfImage(easyar_ListOfPointerOfImage * cdata);
    virtual ~ListOfPointerOfImage();

    ListOfPointerOfImage(const ListOfPointerOfImage & data);
    const easyar_ListOfPointerOfImage * get_cdata() const;
    easyar_ListOfPointerOfImage * get_cdata();

    ListOfPointerOfImage(easyar_Image * * begin, easyar_Image * * end);
    int size() const;
    Image * at(int index) const;
};
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_FRAME_HXX__
#define __IMPLEMENTATION_EASYAR_FRAME_HXX__

#include "easyar/frame.h"
#include "easyar/drawable.hxx"
#include "easyar/image.hxx"
#include "easyar/camera.hxx"

namespace easyar {

inline Frame::Frame(easyar_Frame * cdata)
    :
    Drawable(static_cast<easyar_Drawable *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline Frame::~Frame()
{
    if (cdata_) {
        easyar_Frame__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline Frame::Frame(const Frame & data)
    :
    Drawable(static_cast<easyar_Drawable *>(NULL)),
    cdata_(NULL)
{
    easyar_Frame * cdata = NULL;
    easyar_Frame__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_Frame * Frame::get_cdata() const
{
    return cdata_;
}
inline easyar_Frame * Frame::get_cdata()
{
    return cdata_;
}
inline void Frame::init_cdata(easyar_Frame * cdata)
{
    cdata_ = cdata;
    {
        easyar_Drawable * cdata_inner = NULL;
        easyar_castFrameToDrawable(cdata, &cdata_inner);
        Drawable::init_cdata(cdata_inner);
    }
}
inline Frame::Frame()
    :
    Drawable(static_cast<easyar_Drawable *>(NULL)),
    cdata_(NULL)
{
    easyar_Frame * _return_value_ = NULL;
    easyar_Frame__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline double Frame::timestamp()
{
    if (cdata_ == NULL) {
        return double();
    }
    double _return_value_ = easyar_Frame_timestamp(cdata_);
    return _return_value_;
}
inline int Frame::index()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_Frame_index(cdata_);
    return _return_value_;
}
inline void Frame::images(/* OUT */ ListOfPointerOfImage * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ListOfPointerOfImage * _return_value_ = NULL;
    easyar_Frame_images(cdata_, &_return_value_);
    *Return = new ListOfPointerOfImage(_return_value_);
}
inline void Frame::cameraParameters(/* OUT */ CameraParameters * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_CameraParameters * _return_value_ = NULL;
    easyar_Frame_cameraParameters(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new CameraParameters(_return_value_));
}
inline bool Frame::empty()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Frame_empty(cdata_);
    return _return_value_;
}
inline void Frame::tryCastFromDrawable(Drawable * v, /* OUT */ Frame * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_Frame * cdata = NULL;
    easyar_tryCastDrawableToFrame(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new Frame(cdata);
}

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFIMAGE__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFIMAGE__
inline ListOfPointerOfImage::ListOfPointerOfImage(easyar_ListOfPointerOfImage * cdata)
    : cdata_(cdata)
{
}
inline ListOfPointerOfImage::~ListOfPointerOfImage()
{
    if (cdata_) {
        easyar_ListOfPointerOfImage__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ListOfPointerOfImage::ListOfPointerOfImage(const ListOfPointerOfImage & data)
    : cdata_(static_cast<easyar_ListOfPointerOfImage *>(NULL))
{
    easyar_ListOfPointerOfImage_copy(data.cdata_, &cdata_);
}
inline const easyar_ListOfPointerOfImage * ListOfPointerOfImage::get_cdata() const
{
    return cdata_;
}
inline easyar_ListOfPointerOfImage * ListOfPointerOfImage::get_cdata()
{
    return cdata_;
}

inline ListOfPointerOfImage::ListOfPointerOfImage(easyar_Image * * begin, easyar_Image * * end)
    : cdata_(static_cast<easyar_ListOfPointerOfImage *>(NULL))
{
    easyar_ListOfPointerOfImage__ctor(begin, end, &cdata_);
}
inline int ListOfPointerOfImage::size() const
{
    return easyar_ListOfPointerOfImage_size(cdata_);
}
inline Image * ListOfPointerOfImage::at(int index) const
{
    easyar_Image * _return_value_ = easyar_ListOfPointerOfImage_at(cdata_, index);
    easyar_Image__retain(_return_value_, &_return_value_);
    return (_return_value_ == NULL ? NULL : new Image(_return_value_));
}
#endif

}

#endif
