//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_FRAMESTREAMER_HXX__
#define __EASYAR_FRAMESTREAMER_HXX__

#include "easyar/types.hxx"

namespace easyar {

class FrameStreamer
{
protected:
    easyar_FrameStreamer * cdata_ ;
    void init_cdata(easyar_FrameStreamer * cdata);
    virtual FrameStreamer & operator=(const FrameStreamer & data) { return *this; } //deleted
public:
    FrameStreamer(easyar_FrameStreamer * cdata);
    virtual ~FrameStreamer();

    FrameStreamer(const FrameStreamer & data);
    const easyar_FrameStreamer * get_cdata() const;
    easyar_FrameStreamer * get_cdata();

    void peek(/* OUT */ Frame * * Return);
    bool start();
    bool stop();
    void setCameraParameters(CameraParameters * cameraParameters);
    void cameraParameters(/* OUT */ CameraParameters * * Return);
};

class CameraFrameStreamer : public FrameStreamer
{
protected:
    easyar_CameraFrameStreamer * cdata_ ;
    void init_cdata(easyar_CameraFrameStreamer * cdata);
    virtual CameraFrameStreamer & operator=(const CameraFrameStreamer & data) { return *this; } //deleted
public:
    CameraFrameStreamer(easyar_CameraFrameStreamer * cdata);
    virtual ~CameraFrameStreamer();

    CameraFrameStreamer(const CameraFrameStreamer & data);
    const easyar_CameraFrameStreamer * get_cdata() const;
    easyar_CameraFrameStreamer * get_cdata();

    CameraFrameStreamer();
    bool attachCamera(CameraDevice * obj);
    void peek(/* OUT */ Frame * * Return);
    bool start();
    bool stop();
    void setCameraParameters(CameraParameters * cameraParameters);
    void cameraParameters(/* OUT */ CameraParameters * * Return);
    static void tryCastFromFrameStreamer(FrameStreamer * v, /* OUT */ CameraFrameStreamer * * Return);
};

class ExternalFrameStreamer : public FrameStreamer
{
protected:
    easyar_ExternalFrameStreamer * cdata_ ;
    void init_cdata(easyar_ExternalFrameStreamer * cdata);
    virtual ExternalFrameStreamer & operator=(const ExternalFrameStreamer & data) { return *this; } //deleted
public:
    ExternalFrameStreamer(easyar_ExternalFrameStreamer * cdata);
    virtual ~ExternalFrameStreamer();

    ExternalFrameStreamer(const ExternalFrameStreamer & data);
    const easyar_ExternalFrameStreamer * get_cdata() const;
    easyar_ExternalFrameStreamer * get_cdata();

    ExternalFrameStreamer();
    bool input(Image * image);
    void peek(/* OUT */ Frame * * Return);
    bool start();
    bool stop();
    void setCameraParameters(CameraParameters * cameraParameters);
    void cameraParameters(/* OUT */ CameraParameters * * Return);
    static void tryCastFromFrameStreamer(FrameStreamer * v, /* OUT */ ExternalFrameStreamer * * Return);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_FRAMESTREAMER_HXX__
#define __IMPLEMENTATION_EASYAR_FRAMESTREAMER_HXX__

#include "easyar/framestreamer.h"
#include "easyar/frame.hxx"
#include "easyar/camera.hxx"
#include "easyar/image.hxx"

namespace easyar {

inline FrameStreamer::FrameStreamer(easyar_FrameStreamer * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline FrameStreamer::~FrameStreamer()
{
    if (cdata_) {
        easyar_FrameStreamer__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline FrameStreamer::FrameStreamer(const FrameStreamer & data)
    :
    cdata_(NULL)
{
    easyar_FrameStreamer * cdata = NULL;
    easyar_FrameStreamer__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_FrameStreamer * FrameStreamer::get_cdata() const
{
    return cdata_;
}
inline easyar_FrameStreamer * FrameStreamer::get_cdata()
{
    return cdata_;
}
inline void FrameStreamer::init_cdata(easyar_FrameStreamer * cdata)
{
    cdata_ = cdata;
}
inline void FrameStreamer::peek(/* OUT */ Frame * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_Frame * _return_value_ = NULL;
    easyar_FrameStreamer_peek(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new Frame(_return_value_));
}
inline bool FrameStreamer::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_FrameStreamer_start(cdata_);
    return _return_value_;
}
inline bool FrameStreamer::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_FrameStreamer_stop(cdata_);
    return _return_value_;
}
inline void FrameStreamer::setCameraParameters(CameraParameters * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_FrameStreamer_setCameraParameters(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
}
inline void FrameStreamer::cameraParameters(/* OUT */ CameraParameters * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_CameraParameters * _return_value_ = NULL;
    easyar_FrameStreamer_cameraParameters(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new CameraParameters(_return_value_));
}

inline CameraFrameStreamer::CameraFrameStreamer(easyar_CameraFrameStreamer * cdata)
    :
    FrameStreamer(static_cast<easyar_FrameStreamer *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline CameraFrameStreamer::~CameraFrameStreamer()
{
    if (cdata_) {
        easyar_CameraFrameStreamer__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline CameraFrameStreamer::CameraFrameStreamer(const CameraFrameStreamer & data)
    :
    FrameStreamer(static_cast<easyar_FrameStreamer *>(NULL)),
    cdata_(NULL)
{
    easyar_CameraFrameStreamer * cdata = NULL;
    easyar_CameraFrameStreamer__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_CameraFrameStreamer * CameraFrameStreamer::get_cdata() const
{
    return cdata_;
}
inline easyar_CameraFrameStreamer * CameraFrameStreamer::get_cdata()
{
    return cdata_;
}
inline void CameraFrameStreamer::init_cdata(easyar_CameraFrameStreamer * cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameStreamer * cdata_inner = NULL;
        easyar_castCameraFrameStreamerToFrameStreamer(cdata, &cdata_inner);
        FrameStreamer::init_cdata(cdata_inner);
    }
}
inline CameraFrameStreamer::CameraFrameStreamer()
    :
    FrameStreamer(static_cast<easyar_FrameStreamer *>(NULL)),
    cdata_(NULL)
{
    easyar_CameraFrameStreamer * _return_value_ = NULL;
    easyar_CameraFrameStreamer__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline bool CameraFrameStreamer::attachCamera(CameraDevice * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraFrameStreamer_attachCamera(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline void CameraFrameStreamer::peek(/* OUT */ Frame * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_Frame * _return_value_ = NULL;
    easyar_CameraFrameStreamer_peek(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new Frame(_return_value_));
}
inline bool CameraFrameStreamer::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraFrameStreamer_start(cdata_);
    return _return_value_;
}
inline bool CameraFrameStreamer::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraFrameStreamer_stop(cdata_);
    return _return_value_;
}
inline void CameraFrameStreamer::setCameraParameters(CameraParameters * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_CameraFrameStreamer_setCameraParameters(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
}
inline void CameraFrameStreamer::cameraParameters(/* OUT */ CameraParameters * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_CameraParameters * _return_value_ = NULL;
    easyar_CameraFrameStreamer_cameraParameters(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new CameraParameters(_return_value_));
}
inline void CameraFrameStreamer::tryCastFromFrameStreamer(FrameStreamer * v, /* OUT */ CameraFrameStreamer * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_CameraFrameStreamer * cdata = NULL;
    easyar_tryCastFrameStreamerToCameraFrameStreamer(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new CameraFrameStreamer(cdata);
}

inline ExternalFrameStreamer::ExternalFrameStreamer(easyar_ExternalFrameStreamer * cdata)
    :
    FrameStreamer(static_cast<easyar_FrameStreamer *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline ExternalFrameStreamer::~ExternalFrameStreamer()
{
    if (cdata_) {
        easyar_ExternalFrameStreamer__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ExternalFrameStreamer::ExternalFrameStreamer(const ExternalFrameStreamer & data)
    :
    FrameStreamer(static_cast<easyar_FrameStreamer *>(NULL)),
    cdata_(NULL)
{
    easyar_ExternalFrameStreamer * cdata = NULL;
    easyar_ExternalFrameStreamer__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_ExternalFrameStreamer * ExternalFrameStreamer::get_cdata() const
{
    return cdata_;
}
inline easyar_ExternalFrameStreamer * ExternalFrameStreamer::get_cdata()
{
    return cdata_;
}
inline void ExternalFrameStreamer::init_cdata(easyar_ExternalFrameStreamer * cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameStreamer * cdata_inner = NULL;
        easyar_castExternalFrameStreamerToFrameStreamer(cdata, &cdata_inner);
        FrameStreamer::init_cdata(cdata_inner);
    }
}
inline ExternalFrameStreamer::ExternalFrameStreamer()
    :
    FrameStreamer(static_cast<easyar_FrameStreamer *>(NULL)),
    cdata_(NULL)
{
    easyar_ExternalFrameStreamer * _return_value_ = NULL;
    easyar_ExternalFrameStreamer__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline bool ExternalFrameStreamer::input(Image * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ExternalFrameStreamer_input(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline void ExternalFrameStreamer::peek(/* OUT */ Frame * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_Frame * _return_value_ = NULL;
    easyar_ExternalFrameStreamer_peek(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new Frame(_return_value_));
}
inline bool ExternalFrameStreamer::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ExternalFrameStreamer_start(cdata_);
    return _return_value_;
}
inline bool ExternalFrameStreamer::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ExternalFrameStreamer_stop(cdata_);
    return _return_value_;
}
inline void ExternalFrameStreamer::setCameraParameters(CameraParameters * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_ExternalFrameStreamer_setCameraParameters(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
}
inline void ExternalFrameStreamer::cameraParameters(/* OUT */ CameraParameters * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_CameraParameters * _return_value_ = NULL;
    easyar_ExternalFrameStreamer_cameraParameters(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new CameraParameters(_return_value_));
}
inline void ExternalFrameStreamer::tryCastFromFrameStreamer(FrameStreamer * v, /* OUT */ ExternalFrameStreamer * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ExternalFrameStreamer * cdata = NULL;
    easyar_tryCastFrameStreamerToExternalFrameStreamer(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new ExternalFrameStreamer(cdata);
}

}

#endif
