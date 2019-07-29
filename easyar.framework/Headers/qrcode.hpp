//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_QRCODE_HPP__
#define __EASYAR_QRCODE_HPP__

#include "easyar/types.hpp"
#include "easyar/framefilter.hpp"

namespace easyar {

class QRCodeScannerResult
{
protected:
    std::shared_ptr<easyar_QRCodeScannerResult> cdata_;
    void init_cdata(std::shared_ptr<easyar_QRCodeScannerResult> cdata);
    QRCodeScannerResult & operator=(const QRCodeScannerResult & data) = delete;
public:
    QRCodeScannerResult(std::shared_ptr<easyar_QRCodeScannerResult> cdata);
    virtual ~QRCodeScannerResult();

    std::shared_ptr<easyar_QRCodeScannerResult> get_cdata();

    std::string text();
};

class QRCodeScanner : public FrameFilter
{
protected:
    std::shared_ptr<easyar_QRCodeScanner> cdata_;
    void init_cdata(std::shared_ptr<easyar_QRCodeScanner> cdata);
    QRCodeScanner & operator=(const QRCodeScanner & data) = delete;
public:
    QRCodeScanner(std::shared_ptr<easyar_QRCodeScanner> cdata);
    virtual ~QRCodeScanner();

    std::shared_ptr<easyar_QRCodeScanner> get_cdata();

    QRCodeScanner();
    static bool isAvailable();
    std::shared_ptr<QRCodeScannerResult> getResult(std::shared_ptr<Frame> frame);
    bool attachStreamer(std::shared_ptr<FrameStreamer> obj);
    bool start();
    bool stop();
    static std::shared_ptr<QRCodeScanner> tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v);
};

}

namespace std {

template<>
inline shared_ptr<easyar::QRCodeScanner> dynamic_pointer_cast<easyar::QRCodeScanner, easyar::FrameFilter>(const shared_ptr<easyar::FrameFilter> & r) noexcept
{
    return easyar::QRCodeScanner::tryCastFromFrameFilter(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_QRCODE_HPP__
#define __IMPLEMENTATION_EASYAR_QRCODE_HPP__

#include "easyar/qrcode.h"
#include "easyar/framefilter.hpp"
#include "easyar/frame.hpp"
#include "easyar/framestreamer.hpp"

namespace easyar {

inline QRCodeScannerResult::QRCodeScannerResult(std::shared_ptr<easyar_QRCodeScannerResult> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline QRCodeScannerResult::~QRCodeScannerResult()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_QRCodeScannerResult> QRCodeScannerResult::get_cdata()
{
    return cdata_;
}
inline void QRCodeScannerResult::init_cdata(std::shared_ptr<easyar_QRCodeScannerResult> cdata)
{
    cdata_ = cdata;
}
inline std::string QRCodeScannerResult::text()
{
    easyar_String * _return_value_;
    easyar_QRCodeScannerResult_text(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}

inline QRCodeScanner::QRCodeScanner(std::shared_ptr<easyar_QRCodeScanner> cdata)
    :
    FrameFilter(std::shared_ptr<easyar_FrameFilter>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline QRCodeScanner::~QRCodeScanner()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_QRCodeScanner> QRCodeScanner::get_cdata()
{
    return cdata_;
}
inline void QRCodeScanner::init_cdata(std::shared_ptr<easyar_QRCodeScanner> cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameFilter * ptr = nullptr;
        easyar_castQRCodeScannerToFrameFilter(cdata_.get(), &ptr);
        FrameFilter::init_cdata(std::shared_ptr<easyar_FrameFilter>(ptr, [](easyar_FrameFilter * ptr) { easyar_FrameFilter__dtor(ptr); }));
    }
}
inline QRCodeScanner::QRCodeScanner()
    :
    FrameFilter(std::shared_ptr<easyar_FrameFilter>(nullptr)),
    cdata_(nullptr)
{
    easyar_QRCodeScanner * _return_value_;
    easyar_QRCodeScanner__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_QRCodeScanner>(_return_value_, [](easyar_QRCodeScanner * ptr) { easyar_QRCodeScanner__dtor(ptr); }));
}
inline bool QRCodeScanner::isAvailable()
{
    auto _return_value_ = easyar_QRCodeScanner_isAvailable();
    return _return_value_;
}
inline std::shared_ptr<QRCodeScannerResult> QRCodeScanner::getResult(std::shared_ptr<Frame> arg0)
{
    easyar_QRCodeScannerResult * _return_value_;
    easyar_QRCodeScanner_getResult(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<QRCodeScannerResult>(std::shared_ptr<easyar_QRCodeScannerResult>(_return_value_, [](easyar_QRCodeScannerResult * ptr) { easyar_QRCodeScannerResult__dtor(ptr); })));
}
inline bool QRCodeScanner::attachStreamer(std::shared_ptr<FrameStreamer> arg0)
{
    auto _return_value_ = easyar_QRCodeScanner_attachStreamer(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline bool QRCodeScanner::start()
{
    auto _return_value_ = easyar_QRCodeScanner_start(cdata_.get());
    return _return_value_;
}
inline bool QRCodeScanner::stop()
{
    auto _return_value_ = easyar_QRCodeScanner_stop(cdata_.get());
    return _return_value_;
}
inline std::shared_ptr<QRCodeScanner> QRCodeScanner::tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_QRCodeScanner * cdata;
    easyar_tryCastFrameFilterToQRCodeScanner(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<QRCodeScanner>(std::shared_ptr<easyar_QRCodeScanner>(cdata, [](easyar_QRCodeScanner * ptr) { easyar_QRCodeScanner__dtor(ptr); }));
}

}

#endif
