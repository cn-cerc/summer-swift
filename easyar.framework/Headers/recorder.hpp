//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_RECORDER_HPP__
#define __EASYAR_RECORDER_HPP__

#include "easyar/types.hpp"

namespace easyar {

class Recorder
{
protected:
    std::shared_ptr<easyar_Recorder> cdata_;
    void init_cdata(std::shared_ptr<easyar_Recorder> cdata);
    Recorder & operator=(const Recorder & data) = delete;
public:
    Recorder(std::shared_ptr<easyar_Recorder> cdata);
    virtual ~Recorder();

    std::shared_ptr<easyar_Recorder> get_cdata();

    static bool isAvailable();
    static void requestPermissions(std::shared_ptr<CallbackScheduler> callbackScheduler, std::function<void(PermissionStatus, std::string)> permissionCallback);
    static std::shared_ptr<Recorder> create(std::shared_ptr<RecorderConfiguration> config, std::shared_ptr<CallbackScheduler> callbackScheduler, std::function<void(RecordStatus, std::string)> statusCallback);
    void start();
    void updateFrame(std::shared_ptr<TextureId> texture, int width, int height);
    void stop();
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
#define __EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus, easyar_String *);
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(std::function<void(PermissionStatus, std::string)> f);
#endif

#ifndef __EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
#define __EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
static void FunctorOfVoidFromRecordStatusAndString_func(void * _state, easyar_RecordStatus, easyar_String *);
static void FunctorOfVoidFromRecordStatusAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromRecordStatusAndString FunctorOfVoidFromRecordStatusAndString_to_c(std::function<void(RecordStatus, std::string)> f);
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_RECORDER_HPP__
#define __IMPLEMENTATION_EASYAR_RECORDER_HPP__

#include "easyar/recorder.h"
#include "easyar/callbackscheduler.hpp"
#include "easyar/recorder_configuration.hpp"
#include "easyar/renderer.hpp"

namespace easyar {

inline Recorder::Recorder(std::shared_ptr<easyar_Recorder> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline Recorder::~Recorder()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_Recorder> Recorder::get_cdata()
{
    return cdata_;
}
inline void Recorder::init_cdata(std::shared_ptr<easyar_Recorder> cdata)
{
    cdata_ = cdata;
}
inline bool Recorder::isAvailable()
{
    auto _return_value_ = easyar_Recorder_isAvailable();
    return _return_value_;
}
inline void Recorder::requestPermissions(std::shared_ptr<CallbackScheduler> arg0, std::function<void(PermissionStatus, std::string)> arg1)
{
    easyar_Recorder_requestPermissions((arg0 == nullptr ? nullptr : arg0->get_cdata().get()), FunctorOfVoidFromPermissionStatusAndString_to_c(arg1));
}
inline std::shared_ptr<Recorder> Recorder::create(std::shared_ptr<RecorderConfiguration> arg0, std::shared_ptr<CallbackScheduler> arg1, std::function<void(RecordStatus, std::string)> arg2)
{
    easyar_Recorder * _return_value_;
    easyar_Recorder_create((arg0 == nullptr ? nullptr : arg0->get_cdata().get()), (arg1 == nullptr ? nullptr : arg1->get_cdata().get()), FunctorOfVoidFromRecordStatusAndString_to_c(arg2), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<Recorder>(std::shared_ptr<easyar_Recorder>(_return_value_, [](easyar_Recorder * ptr) { easyar_Recorder__dtor(ptr); })));
}
inline void Recorder::start()
{
    easyar_Recorder_start(cdata_.get());
}
inline void Recorder::updateFrame(std::shared_ptr<TextureId> arg0, int arg1, int arg2)
{
    easyar_Recorder_updateFrame(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), arg1, arg2);
}
inline void Recorder::stop()
{
    easyar_Recorder_stop(cdata_.get());
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus arg0, easyar_String * arg1)
{
    PermissionStatus cpparg0 = static_cast<PermissionStatus>(arg0);
    easyar_String_copy(arg1, &arg1);
    std::string cpparg1 = std_string_from_easyar_String(std::shared_ptr<easyar_String>(arg1, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
    auto f = reinterpret_cast<std::function<void(PermissionStatus, std::string)> *>(_state);
    (*f)(cpparg0, cpparg1);
}
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state)
{
    auto f = reinterpret_cast<std::function<void(PermissionStatus, std::string)> *>(_state);
    delete f;
}
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(std::function<void(PermissionStatus, std::string)> f)
{
    if (f == nullptr) { return easyar_FunctorOfVoidFromPermissionStatusAndString{nullptr, nullptr, nullptr}; }
    return easyar_FunctorOfVoidFromPermissionStatusAndString{new std::function<void(PermissionStatus, std::string)>(f), FunctorOfVoidFromPermissionStatusAndString_func, FunctorOfVoidFromPermissionStatusAndString_destroy};
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
static void FunctorOfVoidFromRecordStatusAndString_func(void * _state, easyar_RecordStatus arg0, easyar_String * arg1)
{
    RecordStatus cpparg0 = static_cast<RecordStatus>(arg0);
    easyar_String_copy(arg1, &arg1);
    std::string cpparg1 = std_string_from_easyar_String(std::shared_ptr<easyar_String>(arg1, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
    auto f = reinterpret_cast<std::function<void(RecordStatus, std::string)> *>(_state);
    (*f)(cpparg0, cpparg1);
}
static void FunctorOfVoidFromRecordStatusAndString_destroy(void * _state)
{
    auto f = reinterpret_cast<std::function<void(RecordStatus, std::string)> *>(_state);
    delete f;
}
static inline easyar_FunctorOfVoidFromRecordStatusAndString FunctorOfVoidFromRecordStatusAndString_to_c(std::function<void(RecordStatus, std::string)> f)
{
    if (f == nullptr) { return easyar_FunctorOfVoidFromRecordStatusAndString{nullptr, nullptr, nullptr}; }
    return easyar_FunctorOfVoidFromRecordStatusAndString{new std::function<void(RecordStatus, std::string)>(f), FunctorOfVoidFromRecordStatusAndString_func, FunctorOfVoidFromRecordStatusAndString_destroy};
}
#endif

}

#endif
