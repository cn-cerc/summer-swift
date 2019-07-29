//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_FRAMESTREAMER_HPP__
#define __EASYAR_FRAMESTREAMER_HPP__

#include "easyar/types.hpp"

namespace easyar {

class FrameStreamer
{
protected:
    std::shared_ptr<easyar_FrameStreamer> cdata_;
    void init_cdata(std::shared_ptr<easyar_FrameStreamer> cdata);
    FrameStreamer & operator=(const FrameStreamer & data) = delete;
public:
    FrameStreamer(std::shared_ptr<easyar_FrameStreamer> cdata);
    virtual ~FrameStreamer();

    std::shared_ptr<easyar_FrameStreamer> get_cdata();

    std::shared_ptr<Frame> peek();
    bool start();
    bool stop();
    void setCameraParameters(std::shared_ptr<CameraParameters> cameraParameters);
    std::shared_ptr<CameraParameters> cameraParameters();
};

class CameraFrameStreamer : public FrameStreamer
{
protected:
    std::shared_ptr<easyar_CameraFrameStreamer> cdata_;
    void init_cdata(std::shared_ptr<easyar_CameraFrameStreamer> cdata);
    CameraFrameStreamer & operator=(const CameraFrameStreamer & data) = delete;
public:
    CameraFrameStreamer(std::shared_ptr<easyar_CameraFrameStreamer> cdata);
    virtual ~CameraFrameStreamer();

    std::shared_ptr<easyar_CameraFrameStreamer> get_cdata();

    CameraFrameStreamer();
    bool attachCamera(std::shared_ptr<CameraDevice> obj);
    std::shared_ptr<Frame> peek();
    bool start();
    bool stop();
    void setCameraParameters(std::shared_ptr<CameraParameters> cameraParameters);
    std::shared_ptr<CameraParameters> cameraParameters();
    static std::shared_ptr<CameraFrameStreamer> tryCastFromFrameStreamer(std::shared_ptr<FrameStreamer> v);
};

class ExternalFrameStreamer : public FrameStreamer
{
protected:
    std::shared_ptr<easyar_ExternalFrameStreamer> cdata_;
    void init_cdata(std::shared_ptr<easyar_ExternalFrameStreamer> cdata);
    ExternalFrameStreamer & operator=(const ExternalFrameStreamer & data) = delete;
public:
    ExternalFrameStreamer(std::shared_ptr<easyar_ExternalFrameStreamer> cdata);
    virtual ~ExternalFrameStreamer();

    std::shared_ptr<easyar_ExternalFrameStreamer> get_cdata();

    ExternalFrameStreamer();
    bool input(std::shared_ptr<Image> image);
    std::shared_ptr<Frame> peek();
    bool start();
    bool stop();
    void setCameraParameters(std::shared_ptr<CameraParameters> cameraParameters);
    std::shared_ptr<CameraParameters> cameraParameters();
    static std::shared_ptr<ExternalFrameStreamer> tryCastFromFrameStreamer(std::shared_ptr<FrameStreamer> v);
};

}

namespace std {

template<>
inline shared_ptr<easyar::CameraFrameStreamer> dynamic_pointer_cast<easyar::CameraFrameStreamer, easyar::FrameStreamer>(const shared_ptr<easyar::FrameStreamer> & r) noexcept
{
    return easyar::CameraFrameStreamer::tryCastFromFrameStreamer(r);
}

template<>
inline shared_ptr<easyar::ExternalFrameStreamer> dynamic_pointer_cast<easyar::ExternalFrameStreamer, easyar::FrameStreamer>(const shared_ptr<easyar::FrameStreamer> & r) noexcept
{
    return easyar::ExternalFrameStreamer::tryCastFromFrameStreamer(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_FRAMESTREAMER_HPP__
#define __IMPLEMENTATION_EASYAR_FRAMESTREAMER_HPP__

#include "easyar/framestreamer.h"
#include "easyar/frame.hpp"
#include "easyar/camera.hpp"
#include "easyar/image.hpp"

namespace easyar {

inline FrameStreamer::FrameStreamer(std::shared_ptr<easyar_FrameStreamer> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline FrameStreamer::~FrameStreamer()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_FrameStreamer> FrameStreamer::get_cdata()
{
    return cdata_;
}
inline void FrameStreamer::init_cdata(std::shared_ptr<easyar_FrameStreamer> cdata)
{
    cdata_ = cdata;
}
inline std::shared_ptr<Frame> FrameStreamer::peek()
{
    easyar_Frame * _return_value_;
    easyar_FrameStreamer_peek(cdata_.get(), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<Frame>(std::shared_ptr<easyar_Frame>(_return_value_, [](easyar_Frame * ptr) { easyar_Frame__dtor(ptr); })));
}
inline bool FrameStreamer::start()
{
    auto _return_value_ = easyar_FrameStreamer_start(cdata_.get());
    return _return_value_;
}
inline bool FrameStreamer::stop()
{
    auto _return_value_ = easyar_FrameStreamer_stop(cdata_.get());
    return _return_value_;
}
inline void FrameStreamer::setCameraParameters(std::shared_ptr<CameraParameters> arg0)
{
    easyar_FrameStreamer_setCameraParameters(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
}
inline std::shared_ptr<CameraParameters> FrameStreamer::cameraParameters()
{
    easyar_CameraParameters * _return_value_;
    easyar_FrameStreamer_cameraParameters(cdata_.get(), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<CameraParameters>(std::shared_ptr<easyar_CameraParameters>(_return_value_, [](easyar_CameraParameters * ptr) { easyar_CameraParameters__dtor(ptr); })));
}

inline CameraFrameStreamer::CameraFrameStreamer(std::shared_ptr<easyar_CameraFrameStreamer> cdata)
    :
    FrameStreamer(std::shared_ptr<easyar_FrameStreamer>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline CameraFrameStreamer::~CameraFrameStreamer()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_CameraFrameStreamer> CameraFrameStreamer::get_cdata()
{
    return cdata_;
}
inline void CameraFrameStreamer::init_cdata(std::shared_ptr<easyar_CameraFrameStreamer> cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameStreamer * ptr = nullptr;
        easyar_castCameraFrameStreamerToFrameStreamer(cdata_.get(), &ptr);
        FrameStreamer::init_cdata(std::shared_ptr<easyar_FrameStreamer>(ptr, [](easyar_FrameStreamer * ptr) { easyar_FrameStreamer__dtor(ptr); }));
    }
}
inline CameraFrameStreamer::CameraFrameStreamer()
    :
    FrameStreamer(std::shared_ptr<easyar_FrameStreamer>(nullptr)),
    cdata_(nullptr)
{
    easyar_CameraFrameStreamer * _return_value_;
    easyar_CameraFrameStreamer__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_CameraFrameStreamer>(_return_value_, [](easyar_CameraFrameStreamer * ptr) { easyar_CameraFrameStreamer__dtor(ptr); }));
}
inline bool CameraFrameStreamer::attachCamera(std::shared_ptr<CameraDevice> arg0)
{
    auto _return_value_ = easyar_CameraFrameStreamer_attachCamera(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline std::shared_ptr<Frame> CameraFrameStreamer::peek()
{
    easyar_Frame * _return_value_;
    easyar_CameraFrameStreamer_peek(cdata_.get(), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<Frame>(std::shared_ptr<easyar_Frame>(_return_value_, [](easyar_Frame * ptr) { easyar_Frame__dtor(ptr); })));
}
inline bool CameraFrameStreamer::start()
{
    auto _return_value_ = easyar_CameraFrameStreamer_start(cdata_.get());
    return _return_value_;
}
inline bool CameraFrameStreamer::stop()
{
    auto _return_value_ = easyar_CameraFrameStreamer_stop(cdata_.get());
    return _return_value_;
}
inline void CameraFrameStreamer::setCameraParameters(std::shared_ptr<CameraParameters> arg0)
{
    easyar_CameraFrameStreamer_setCameraParameters(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
}
inline std::shared_ptr<CameraParameters> CameraFrameStreamer::cameraParameters()
{
    easyar_CameraParameters * _return_value_;
    easyar_CameraFrameStreamer_cameraParameters(cdata_.get(), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<CameraParameters>(std::shared_ptr<easyar_CameraParameters>(_return_value_, [](easyar_CameraParameters * ptr) { easyar_CameraParameters__dtor(ptr); })));
}
inline std::shared_ptr<CameraFrameStreamer> CameraFrameStreamer::tryCastFromFrameStreamer(std::shared_ptr<FrameStreamer> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_CameraFrameStreamer * cdata;
    easyar_tryCastFrameStreamerToCameraFrameStreamer(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<CameraFrameStreamer>(std::shared_ptr<easyar_CameraFrameStreamer>(cdata, [](easyar_CameraFrameStreamer * ptr) { easyar_CameraFrameStreamer__dtor(ptr); }));
}

inline ExternalFrameStreamer::ExternalFrameStreamer(std::shared_ptr<easyar_ExternalFrameStreamer> cdata)
    :
    FrameStreamer(std::shared_ptr<easyar_FrameStreamer>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline ExternalFrameStreamer::~ExternalFrameStreamer()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_ExternalFrameStreamer> ExternalFrameStreamer::get_cdata()
{
    return cdata_;
}
inline void ExternalFrameStreamer::init_cdata(std::shared_ptr<easyar_ExternalFrameStreamer> cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameStreamer * ptr = nullptr;
        easyar_castExternalFrameStreamerToFrameStreamer(cdata_.get(), &ptr);
        FrameStreamer::init_cdata(std::shared_ptr<easyar_FrameStreamer>(ptr, [](easyar_FrameStreamer * ptr) { easyar_FrameStreamer__dtor(ptr); }));
    }
}
inline ExternalFrameStreamer::ExternalFrameStreamer()
    :
    FrameStreamer(std::shared_ptr<easyar_FrameStreamer>(nullptr)),
    cdata_(nullptr)
{
    easyar_ExternalFrameStreamer * _return_value_;
    easyar_ExternalFrameStreamer__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_ExternalFrameStreamer>(_return_value_, [](easyar_ExternalFrameStreamer * ptr) { easyar_ExternalFrameStreamer__dtor(ptr); }));
}
inline bool ExternalFrameStreamer::input(std::shared_ptr<Image> arg0)
{
    auto _return_value_ = easyar_ExternalFrameStreamer_input(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline std::shared_ptr<Frame> ExternalFrameStreamer::peek()
{
    easyar_Frame * _return_value_;
    easyar_ExternalFrameStreamer_peek(cdata_.get(), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<Frame>(std::shared_ptr<easyar_Frame>(_return_value_, [](easyar_Frame * ptr) { easyar_Frame__dtor(ptr); })));
}
inline bool ExternalFrameStreamer::start()
{
    auto _return_value_ = easyar_ExternalFrameStreamer_start(cdata_.get());
    return _return_value_;
}
inline bool ExternalFrameStreamer::stop()
{
    auto _return_value_ = easyar_ExternalFrameStreamer_stop(cdata_.get());
    return _return_value_;
}
inline void ExternalFrameStreamer::setCameraParameters(std::shared_ptr<CameraParameters> arg0)
{
    easyar_ExternalFrameStreamer_setCameraParameters(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
}
inline std::shared_ptr<CameraParameters> ExternalFrameStreamer::cameraParameters()
{
    easyar_CameraParameters * _return_value_;
    easyar_ExternalFrameStreamer_cameraParameters(cdata_.get(), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<CameraParameters>(std::shared_ptr<easyar_CameraParameters>(_return_value_, [](easyar_CameraParameters * ptr) { easyar_CameraParameters__dtor(ptr); })));
}
inline std::shared_ptr<ExternalFrameStreamer> ExternalFrameStreamer::tryCastFromFrameStreamer(std::shared_ptr<FrameStreamer> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_ExternalFrameStreamer * cdata;
    easyar_tryCastFrameStreamerToExternalFrameStreamer(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<ExternalFrameStreamer>(std::shared_ptr<easyar_ExternalFrameStreamer>(cdata, [](easyar_ExternalFrameStreamer * ptr) { easyar_ExternalFrameStreamer__dtor(ptr); }));
}

}

#endif
