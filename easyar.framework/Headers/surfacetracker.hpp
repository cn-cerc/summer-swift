//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_SURFACETRACKER_HPP__
#define __EASYAR_SURFACETRACKER_HPP__

#include "easyar/types.hpp"
#include "easyar/framefilter.hpp"

namespace easyar {

class SurfaceTrackerResult
{
protected:
    std::shared_ptr<easyar_SurfaceTrackerResult> cdata_;
    void init_cdata(std::shared_ptr<easyar_SurfaceTrackerResult> cdata);
    SurfaceTrackerResult & operator=(const SurfaceTrackerResult & data) = delete;
public:
    SurfaceTrackerResult(std::shared_ptr<easyar_SurfaceTrackerResult> cdata);
    virtual ~SurfaceTrackerResult();

    std::shared_ptr<easyar_SurfaceTrackerResult> get_cdata();

    Matrix44F transform();
    TargetStatus status();
};

class SurfaceTracker : public FrameFilter
{
protected:
    std::shared_ptr<easyar_SurfaceTracker> cdata_;
    void init_cdata(std::shared_ptr<easyar_SurfaceTracker> cdata);
    SurfaceTracker & operator=(const SurfaceTracker & data) = delete;
public:
    SurfaceTracker(std::shared_ptr<easyar_SurfaceTracker> cdata);
    virtual ~SurfaceTracker();

    std::shared_ptr<easyar_SurfaceTracker> get_cdata();

    SurfaceTracker();
    static bool isAvailable();
    void alignTargetToCameraImagePoint(Vec2F cameraImagePoint);
    std::shared_ptr<SurfaceTrackerResult> getResult(std::shared_ptr<Frame> frame);
    bool attachStreamer(std::shared_ptr<FrameStreamer> obj);
    bool start();
    bool stop();
    static std::shared_ptr<SurfaceTracker> tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v);
};

}

namespace std {

template<>
inline shared_ptr<easyar::SurfaceTracker> dynamic_pointer_cast<easyar::SurfaceTracker, easyar::FrameFilter>(const shared_ptr<easyar::FrameFilter> & r) noexcept
{
    return easyar::SurfaceTracker::tryCastFromFrameFilter(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_SURFACETRACKER_HPP__
#define __IMPLEMENTATION_EASYAR_SURFACETRACKER_HPP__

#include "easyar/surfacetracker.h"
#include "easyar/matrix.hpp"
#include "easyar/framefilter.hpp"
#include "easyar/vector.hpp"
#include "easyar/frame.hpp"
#include "easyar/framestreamer.hpp"

namespace easyar {

inline SurfaceTrackerResult::SurfaceTrackerResult(std::shared_ptr<easyar_SurfaceTrackerResult> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline SurfaceTrackerResult::~SurfaceTrackerResult()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_SurfaceTrackerResult> SurfaceTrackerResult::get_cdata()
{
    return cdata_;
}
inline void SurfaceTrackerResult::init_cdata(std::shared_ptr<easyar_SurfaceTrackerResult> cdata)
{
    cdata_ = cdata;
}
inline Matrix44F SurfaceTrackerResult::transform()
{
    auto _return_value_ = easyar_SurfaceTrackerResult_transform(cdata_.get());
    return Matrix44F{{{_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11], _return_value_.data[12], _return_value_.data[13], _return_value_.data[14], _return_value_.data[15]}}};
}
inline TargetStatus SurfaceTrackerResult::status()
{
    auto _return_value_ = easyar_SurfaceTrackerResult_status(cdata_.get());
    return static_cast<TargetStatus>(_return_value_);
}

inline SurfaceTracker::SurfaceTracker(std::shared_ptr<easyar_SurfaceTracker> cdata)
    :
    FrameFilter(std::shared_ptr<easyar_FrameFilter>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline SurfaceTracker::~SurfaceTracker()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_SurfaceTracker> SurfaceTracker::get_cdata()
{
    return cdata_;
}
inline void SurfaceTracker::init_cdata(std::shared_ptr<easyar_SurfaceTracker> cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameFilter * ptr = nullptr;
        easyar_castSurfaceTrackerToFrameFilter(cdata_.get(), &ptr);
        FrameFilter::init_cdata(std::shared_ptr<easyar_FrameFilter>(ptr, [](easyar_FrameFilter * ptr) { easyar_FrameFilter__dtor(ptr); }));
    }
}
inline SurfaceTracker::SurfaceTracker()
    :
    FrameFilter(std::shared_ptr<easyar_FrameFilter>(nullptr)),
    cdata_(nullptr)
{
    easyar_SurfaceTracker * _return_value_;
    easyar_SurfaceTracker__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_SurfaceTracker>(_return_value_, [](easyar_SurfaceTracker * ptr) { easyar_SurfaceTracker__dtor(ptr); }));
}
inline bool SurfaceTracker::isAvailable()
{
    auto _return_value_ = easyar_SurfaceTracker_isAvailable();
    return _return_value_;
}
inline void SurfaceTracker::alignTargetToCameraImagePoint(Vec2F arg0)
{
    easyar_SurfaceTracker_alignTargetToCameraImagePoint(cdata_.get(), easyar_Vec2F{{arg0.data[0], arg0.data[1]}});
}
inline std::shared_ptr<SurfaceTrackerResult> SurfaceTracker::getResult(std::shared_ptr<Frame> arg0)
{
    easyar_SurfaceTrackerResult * _return_value_;
    easyar_SurfaceTracker_getResult(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<SurfaceTrackerResult>(std::shared_ptr<easyar_SurfaceTrackerResult>(_return_value_, [](easyar_SurfaceTrackerResult * ptr) { easyar_SurfaceTrackerResult__dtor(ptr); })));
}
inline bool SurfaceTracker::attachStreamer(std::shared_ptr<FrameStreamer> arg0)
{
    auto _return_value_ = easyar_SurfaceTracker_attachStreamer(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline bool SurfaceTracker::start()
{
    auto _return_value_ = easyar_SurfaceTracker_start(cdata_.get());
    return _return_value_;
}
inline bool SurfaceTracker::stop()
{
    auto _return_value_ = easyar_SurfaceTracker_stop(cdata_.get());
    return _return_value_;
}
inline std::shared_ptr<SurfaceTracker> SurfaceTracker::tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_SurfaceTracker * cdata;
    easyar_tryCastFrameFilterToSurfaceTracker(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<SurfaceTracker>(std::shared_ptr<easyar_SurfaceTracker>(cdata, [](easyar_SurfaceTracker * ptr) { easyar_SurfaceTracker__dtor(ptr); }));
}

}

#endif
