//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_RECORDER_HXX__
#define __EASYAR_RECORDER_HXX__

#include "easyar/types.hxx"

namespace easyar {

class Recorder
{
protected:
    easyar_Recorder * cdata_ ;
    void init_cdata(easyar_Recorder * cdata);
    virtual Recorder & operator=(const Recorder & data) { return *this; } //deleted
public:
    Recorder(easyar_Recorder * cdata);
    virtual ~Recorder();

    Recorder(const Recorder & data);
    const easyar_Recorder * get_cdata() const;
    easyar_Recorder * get_cdata();

    static bool isAvailable();
    static void requestPermissions(CallbackScheduler * callbackScheduler, FunctorOfVoidFromPermissionStatusAndString permissionCallback);
    static void create(RecorderConfiguration * config, CallbackScheduler * callbackScheduler, FunctorOfVoidFromRecordStatusAndString statusCallback, /* OUT */ Recorder * * Return);
    void start();
    void updateFrame(TextureId * texture, int width, int height);
    void stop();
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
#define __EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
struct FunctorOfVoidFromPermissionStatusAndString
{
    void * _state;
    void (* func)(void * _state, PermissionStatus, String *);
    void (* destroy)(void * _state);
    FunctorOfVoidFromPermissionStatusAndString(void * _state, void (* func)(void * _state, PermissionStatus, String *), void (* destroy)(void * _state));
};

static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus, easyar_String *);
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(FunctorOfVoidFromPermissionStatusAndString f);
#endif

#ifndef __EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
#define __EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
struct FunctorOfVoidFromRecordStatusAndString
{
    void * _state;
    void (* func)(void * _state, RecordStatus, String *);
    void (* destroy)(void * _state);
    FunctorOfVoidFromRecordStatusAndString(void * _state, void (* func)(void * _state, RecordStatus, String *), void (* destroy)(void * _state));
};

static void FunctorOfVoidFromRecordStatusAndString_func(void * _state, easyar_RecordStatus, easyar_String *);
static void FunctorOfVoidFromRecordStatusAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromRecordStatusAndString FunctorOfVoidFromRecordStatusAndString_to_c(FunctorOfVoidFromRecordStatusAndString f);
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_RECORDER_HXX__
#define __IMPLEMENTATION_EASYAR_RECORDER_HXX__

#include "easyar/recorder.h"
#include "easyar/callbackscheduler.hxx"
#include "easyar/recorder_configuration.hxx"
#include "easyar/renderer.hxx"

namespace easyar {

inline Recorder::Recorder(easyar_Recorder * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline Recorder::~Recorder()
{
    if (cdata_) {
        easyar_Recorder__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline Recorder::Recorder(const Recorder & data)
    :
    cdata_(NULL)
{
    easyar_Recorder * cdata = NULL;
    easyar_Recorder__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_Recorder * Recorder::get_cdata() const
{
    return cdata_;
}
inline easyar_Recorder * Recorder::get_cdata()
{
    return cdata_;
}
inline void Recorder::init_cdata(easyar_Recorder * cdata)
{
    cdata_ = cdata;
}
inline bool Recorder::isAvailable()
{
    bool _return_value_ = easyar_Recorder_isAvailable();
    return _return_value_;
}
inline void Recorder::requestPermissions(CallbackScheduler * arg0, FunctorOfVoidFromPermissionStatusAndString arg1)
{
    easyar_Recorder_requestPermissions((arg0 == NULL ? NULL : arg0->get_cdata()), FunctorOfVoidFromPermissionStatusAndString_to_c(arg1));
}
inline void Recorder::create(RecorderConfiguration * arg0, CallbackScheduler * arg1, FunctorOfVoidFromRecordStatusAndString arg2, /* OUT */ Recorder * * Return)
{
    easyar_Recorder * _return_value_ = NULL;
    easyar_Recorder_create((arg0 == NULL ? NULL : arg0->get_cdata()), (arg1 == NULL ? NULL : arg1->get_cdata()), FunctorOfVoidFromRecordStatusAndString_to_c(arg2), &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new Recorder(_return_value_));
}
inline void Recorder::start()
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_start(cdata_);
}
inline void Recorder::updateFrame(TextureId * arg0, int arg1, int arg2)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_updateFrame(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()), arg1, arg2);
}
inline void Recorder::stop()
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_stop(cdata_);
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
inline FunctorOfVoidFromPermissionStatusAndString::FunctorOfVoidFromPermissionStatusAndString(void * _state, void (* func)(void * _state, PermissionStatus, String *), void (* destroy)(void * _state))
{
    this->_state = _state;
    this->func = func;
    this->destroy = destroy;
}
static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus arg0, easyar_String * arg1)
{
    PermissionStatus cpparg0 = static_cast<PermissionStatus>(arg0);
    easyar_String_copy(arg1, &arg1);
    String * cpparg1 = (arg1) == NULL ? NULL : new String(arg1);
    FunctorOfVoidFromPermissionStatusAndString * f = reinterpret_cast<FunctorOfVoidFromPermissionStatusAndString *>(_state);
    f->func(f->_state, cpparg0, cpparg1);
    delete cpparg1;
}
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state)
{
    FunctorOfVoidFromPermissionStatusAndString * f = reinterpret_cast<FunctorOfVoidFromPermissionStatusAndString *>(_state);
    if (f->destroy) {
        f->destroy(f->_state);
    }
    delete f;
}
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(FunctorOfVoidFromPermissionStatusAndString f)
{
    easyar_FunctorOfVoidFromPermissionStatusAndString _return_value_ = {NULL, NULL, NULL};
    if ((f.func == NULL) && (f.destroy == NULL)) { return _return_value_; }
    _return_value_._state = new FunctorOfVoidFromPermissionStatusAndString(f._state, f.func, f.destroy);
    _return_value_.func = FunctorOfVoidFromPermissionStatusAndString_func;
    _return_value_.destroy = FunctorOfVoidFromPermissionStatusAndString_destroy;
    return _return_value_;
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
inline FunctorOfVoidFromRecordStatusAndString::FunctorOfVoidFromRecordStatusAndString(void * _state, void (* func)(void * _state, RecordStatus, String *), void (* destroy)(void * _state))
{
    this->_state = _state;
    this->func = func;
    this->destroy = destroy;
}
static void FunctorOfVoidFromRecordStatusAndString_func(void * _state, easyar_RecordStatus arg0, easyar_String * arg1)
{
    RecordStatus cpparg0 = static_cast<RecordStatus>(arg0);
    easyar_String_copy(arg1, &arg1);
    String * cpparg1 = (arg1) == NULL ? NULL : new String(arg1);
    FunctorOfVoidFromRecordStatusAndString * f = reinterpret_cast<FunctorOfVoidFromRecordStatusAndString *>(_state);
    f->func(f->_state, cpparg0, cpparg1);
    delete cpparg1;
}
static void FunctorOfVoidFromRecordStatusAndString_destroy(void * _state)
{
    FunctorOfVoidFromRecordStatusAndString * f = reinterpret_cast<FunctorOfVoidFromRecordStatusAndString *>(_state);
    if (f->destroy) {
        f->destroy(f->_state);
    }
    delete f;
}
static inline easyar_FunctorOfVoidFromRecordStatusAndString FunctorOfVoidFromRecordStatusAndString_to_c(FunctorOfVoidFromRecordStatusAndString f)
{
    easyar_FunctorOfVoidFromRecordStatusAndString _return_value_ = {NULL, NULL, NULL};
    if ((f.func == NULL) && (f.destroy == NULL)) { return _return_value_; }
    _return_value_._state = new FunctorOfVoidFromRecordStatusAndString(f._state, f.func, f.destroy);
    _return_value_.func = FunctorOfVoidFromRecordStatusAndString_func;
    _return_value_.destroy = FunctorOfVoidFromRecordStatusAndString_destroy;
    return _return_value_;
}
#endif

}

#endif
