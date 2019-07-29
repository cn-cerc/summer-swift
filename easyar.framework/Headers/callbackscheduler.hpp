//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_CALLBACKSCHEDULER_HPP__
#define __EASYAR_CALLBACKSCHEDULER_HPP__

#include "easyar/types.hpp"

namespace easyar {

class CallbackScheduler
{
protected:
    std::shared_ptr<easyar_CallbackScheduler> cdata_;
    void init_cdata(std::shared_ptr<easyar_CallbackScheduler> cdata);
    CallbackScheduler & operator=(const CallbackScheduler & data) = delete;
public:
    CallbackScheduler(std::shared_ptr<easyar_CallbackScheduler> cdata);
    virtual ~CallbackScheduler();

    std::shared_ptr<easyar_CallbackScheduler> get_cdata();

};

class DelayedCallbackScheduler : public CallbackScheduler
{
protected:
    std::shared_ptr<easyar_DelayedCallbackScheduler> cdata_;
    void init_cdata(std::shared_ptr<easyar_DelayedCallbackScheduler> cdata);
    DelayedCallbackScheduler & operator=(const DelayedCallbackScheduler & data) = delete;
public:
    DelayedCallbackScheduler(std::shared_ptr<easyar_DelayedCallbackScheduler> cdata);
    virtual ~DelayedCallbackScheduler();

    std::shared_ptr<easyar_DelayedCallbackScheduler> get_cdata();

    DelayedCallbackScheduler();
    bool runOne();
    static std::shared_ptr<DelayedCallbackScheduler> tryCastFromCallbackScheduler(std::shared_ptr<CallbackScheduler> v);
};

class ImmediateCallbackScheduler : public CallbackScheduler
{
protected:
    std::shared_ptr<easyar_ImmediateCallbackScheduler> cdata_;
    void init_cdata(std::shared_ptr<easyar_ImmediateCallbackScheduler> cdata);
    ImmediateCallbackScheduler & operator=(const ImmediateCallbackScheduler & data) = delete;
public:
    ImmediateCallbackScheduler(std::shared_ptr<easyar_ImmediateCallbackScheduler> cdata);
    virtual ~ImmediateCallbackScheduler();

    std::shared_ptr<easyar_ImmediateCallbackScheduler> get_cdata();

    static std::shared_ptr<ImmediateCallbackScheduler> getDefault();
    static std::shared_ptr<ImmediateCallbackScheduler> tryCastFromCallbackScheduler(std::shared_ptr<CallbackScheduler> v);
};

}

namespace std {

template<>
inline shared_ptr<easyar::DelayedCallbackScheduler> dynamic_pointer_cast<easyar::DelayedCallbackScheduler, easyar::CallbackScheduler>(const shared_ptr<easyar::CallbackScheduler> & r) noexcept
{
    return easyar::DelayedCallbackScheduler::tryCastFromCallbackScheduler(r);
}

template<>
inline shared_ptr<easyar::ImmediateCallbackScheduler> dynamic_pointer_cast<easyar::ImmediateCallbackScheduler, easyar::CallbackScheduler>(const shared_ptr<easyar::CallbackScheduler> & r) noexcept
{
    return easyar::ImmediateCallbackScheduler::tryCastFromCallbackScheduler(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_CALLBACKSCHEDULER_HPP__
#define __IMPLEMENTATION_EASYAR_CALLBACKSCHEDULER_HPP__

#include "easyar/callbackscheduler.h"

namespace easyar {

inline CallbackScheduler::CallbackScheduler(std::shared_ptr<easyar_CallbackScheduler> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline CallbackScheduler::~CallbackScheduler()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_CallbackScheduler> CallbackScheduler::get_cdata()
{
    return cdata_;
}
inline void CallbackScheduler::init_cdata(std::shared_ptr<easyar_CallbackScheduler> cdata)
{
    cdata_ = cdata;
}

inline DelayedCallbackScheduler::DelayedCallbackScheduler(std::shared_ptr<easyar_DelayedCallbackScheduler> cdata)
    :
    CallbackScheduler(std::shared_ptr<easyar_CallbackScheduler>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline DelayedCallbackScheduler::~DelayedCallbackScheduler()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_DelayedCallbackScheduler> DelayedCallbackScheduler::get_cdata()
{
    return cdata_;
}
inline void DelayedCallbackScheduler::init_cdata(std::shared_ptr<easyar_DelayedCallbackScheduler> cdata)
{
    cdata_ = cdata;
    {
        easyar_CallbackScheduler * ptr = nullptr;
        easyar_castDelayedCallbackSchedulerToCallbackScheduler(cdata_.get(), &ptr);
        CallbackScheduler::init_cdata(std::shared_ptr<easyar_CallbackScheduler>(ptr, [](easyar_CallbackScheduler * ptr) { easyar_CallbackScheduler__dtor(ptr); }));
    }
}
inline DelayedCallbackScheduler::DelayedCallbackScheduler()
    :
    CallbackScheduler(std::shared_ptr<easyar_CallbackScheduler>(nullptr)),
    cdata_(nullptr)
{
    easyar_DelayedCallbackScheduler * _return_value_;
    easyar_DelayedCallbackScheduler__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_DelayedCallbackScheduler>(_return_value_, [](easyar_DelayedCallbackScheduler * ptr) { easyar_DelayedCallbackScheduler__dtor(ptr); }));
}
inline bool DelayedCallbackScheduler::runOne()
{
    auto _return_value_ = easyar_DelayedCallbackScheduler_runOne(cdata_.get());
    return _return_value_;
}
inline std::shared_ptr<DelayedCallbackScheduler> DelayedCallbackScheduler::tryCastFromCallbackScheduler(std::shared_ptr<CallbackScheduler> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_DelayedCallbackScheduler * cdata;
    easyar_tryCastCallbackSchedulerToDelayedCallbackScheduler(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<DelayedCallbackScheduler>(std::shared_ptr<easyar_DelayedCallbackScheduler>(cdata, [](easyar_DelayedCallbackScheduler * ptr) { easyar_DelayedCallbackScheduler__dtor(ptr); }));
}

inline ImmediateCallbackScheduler::ImmediateCallbackScheduler(std::shared_ptr<easyar_ImmediateCallbackScheduler> cdata)
    :
    CallbackScheduler(std::shared_ptr<easyar_CallbackScheduler>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline ImmediateCallbackScheduler::~ImmediateCallbackScheduler()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_ImmediateCallbackScheduler> ImmediateCallbackScheduler::get_cdata()
{
    return cdata_;
}
inline void ImmediateCallbackScheduler::init_cdata(std::shared_ptr<easyar_ImmediateCallbackScheduler> cdata)
{
    cdata_ = cdata;
    {
        easyar_CallbackScheduler * ptr = nullptr;
        easyar_castImmediateCallbackSchedulerToCallbackScheduler(cdata_.get(), &ptr);
        CallbackScheduler::init_cdata(std::shared_ptr<easyar_CallbackScheduler>(ptr, [](easyar_CallbackScheduler * ptr) { easyar_CallbackScheduler__dtor(ptr); }));
    }
}
inline std::shared_ptr<ImmediateCallbackScheduler> ImmediateCallbackScheduler::getDefault()
{
    easyar_ImmediateCallbackScheduler * _return_value_;
    easyar_ImmediateCallbackScheduler_getDefault(&_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<ImmediateCallbackScheduler>(std::shared_ptr<easyar_ImmediateCallbackScheduler>(_return_value_, [](easyar_ImmediateCallbackScheduler * ptr) { easyar_ImmediateCallbackScheduler__dtor(ptr); })));
}
inline std::shared_ptr<ImmediateCallbackScheduler> ImmediateCallbackScheduler::tryCastFromCallbackScheduler(std::shared_ptr<CallbackScheduler> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_ImmediateCallbackScheduler * cdata;
    easyar_tryCastCallbackSchedulerToImmediateCallbackScheduler(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<ImmediateCallbackScheduler>(std::shared_ptr<easyar_ImmediateCallbackScheduler>(cdata, [](easyar_ImmediateCallbackScheduler * ptr) { easyar_ImmediateCallbackScheduler__dtor(ptr); }));
}

}

#endif
