//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_SURFACETRACKER_HXX__
#define __EASYAR_SURFACETRACKER_HXX__

#include "easyar/types.hxx"
#include "easyar/framefilter.hxx"

namespace easyar {

class SurfaceTrackerResult
{
protected:
    easyar_SurfaceTrackerResult * cdata_ ;
    void init_cdata(easyar_SurfaceTrackerResult * cdata);
    virtual SurfaceTrackerResult & operator=(const SurfaceTrackerResult & data) { return *this; } //deleted
public:
    SurfaceTrackerResult(easyar_SurfaceTrackerResult * cdata);
    virtual ~SurfaceTrackerResult();

    SurfaceTrackerResult(const SurfaceTrackerResult & data);
    const easyar_SurfaceTrackerResult * get_cdata() const;
    easyar_SurfaceTrackerResult * get_cdata();

    Matrix44F transform();
    TargetStatus status();
};

class SurfaceTracker : public FrameFilter
{
protected:
    easyar_SurfaceTracker * cdata_ ;
    void init_cdata(easyar_SurfaceTracker * cdata);
    virtual SurfaceTracker & operator=(const SurfaceTracker & data) { return *this; } //deleted
public:
    SurfaceTracker(easyar_SurfaceTracker * cdata);
    virtual ~SurfaceTracker();

    SurfaceTracker(const SurfaceTracker & data);
    const easyar_SurfaceTracker * get_cdata() const;
    easyar_SurfaceTracker * get_cdata();

    SurfaceTracker();
    static bool isAvailable();
    void alignTargetToCameraImagePoint(Vec2F cameraImagePoint);
    void getResult(Frame * frame, /* OUT */ SurfaceTrackerResult * * Return);
    bool attachStreamer(FrameStreamer * obj);
    bool start();
    bool stop();
    static void tryCastFromFrameFilter(FrameFilter * v, /* OUT */ SurfaceTracker * * Return);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_SURFACETRACKER_HXX__
#define __IMPLEMENTATION_EASYAR_SURFACETRACKER_HXX__

#include "easyar/surfacetracker.h"
#include "easyar/matrix.hxx"
#include "easyar/framefilter.hxx"
#include "easyar/vector.hxx"
#include "easyar/frame.hxx"
#include "easyar/framestreamer.hxx"

namespace easyar {

inline SurfaceTrackerResult::SurfaceTrackerResult(easyar_SurfaceTrackerResult * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline SurfaceTrackerResult::~SurfaceTrackerResult()
{
    if (cdata_) {
        easyar_SurfaceTrackerResult__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline SurfaceTrackerResult::SurfaceTrackerResult(const SurfaceTrackerResult & data)
    :
    cdata_(NULL)
{
    easyar_SurfaceTrackerResult * cdata = NULL;
    easyar_SurfaceTrackerResult__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_SurfaceTrackerResult * SurfaceTrackerResult::get_cdata() const
{
    return cdata_;
}
inline easyar_SurfaceTrackerResult * SurfaceTrackerResult::get_cdata()
{
    return cdata_;
}
inline void SurfaceTrackerResult::init_cdata(easyar_SurfaceTrackerResult * cdata)
{
    cdata_ = cdata;
}
inline Matrix44F SurfaceTrackerResult::transform()
{
    if (cdata_ == NULL) {
        return Matrix44F();
    }
    easyar_Matrix44F _return_value_ = easyar_SurfaceTrackerResult_transform(cdata_);
    return Matrix44F(_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11], _return_value_.data[12], _return_value_.data[13], _return_value_.data[14], _return_value_.data[15]);
}
inline TargetStatus SurfaceTrackerResult::status()
{
    if (cdata_ == NULL) {
        return TargetStatus();
    }
    easyar_TargetStatus _return_value_ = easyar_SurfaceTrackerResult_status(cdata_);
    return static_cast<TargetStatus>(_return_value_);
}

inline SurfaceTracker::SurfaceTracker(easyar_SurfaceTracker * cdata)
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline SurfaceTracker::~SurfaceTracker()
{
    if (cdata_) {
        easyar_SurfaceTracker__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline SurfaceTracker::SurfaceTracker(const SurfaceTracker & data)
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    easyar_SurfaceTracker * cdata = NULL;
    easyar_SurfaceTracker__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_SurfaceTracker * SurfaceTracker::get_cdata() const
{
    return cdata_;
}
inline easyar_SurfaceTracker * SurfaceTracker::get_cdata()
{
    return cdata_;
}
inline void SurfaceTracker::init_cdata(easyar_SurfaceTracker * cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameFilter * cdata_inner = NULL;
        easyar_castSurfaceTrackerToFrameFilter(cdata, &cdata_inner);
        FrameFilter::init_cdata(cdata_inner);
    }
}
inline SurfaceTracker::SurfaceTracker()
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    easyar_SurfaceTracker * _return_value_ = NULL;
    easyar_SurfaceTracker__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline bool SurfaceTracker::isAvailable()
{
    bool _return_value_ = easyar_SurfaceTracker_isAvailable();
    return _return_value_;
}
inline void SurfaceTracker::alignTargetToCameraImagePoint(Vec2F arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_SurfaceTracker_alignTargetToCameraImagePoint(cdata_, arg0.get_cdata());
}
inline void SurfaceTracker::getResult(Frame * arg0, /* OUT */ SurfaceTrackerResult * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_SurfaceTrackerResult * _return_value_ = NULL;
    easyar_SurfaceTracker_getResult(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()), &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new SurfaceTrackerResult(_return_value_));
}
inline bool SurfaceTracker::attachStreamer(FrameStreamer * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_SurfaceTracker_attachStreamer(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline bool SurfaceTracker::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_SurfaceTracker_start(cdata_);
    return _return_value_;
}
inline bool SurfaceTracker::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_SurfaceTracker_stop(cdata_);
    return _return_value_;
}
inline void SurfaceTracker::tryCastFromFrameFilter(FrameFilter * v, /* OUT */ SurfaceTracker * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_SurfaceTracker * cdata = NULL;
    easyar_tryCastFrameFilterToSurfaceTracker(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new SurfaceTracker(cdata);
}

}

#endif
