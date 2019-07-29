//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_LOG_HXX__
#define __EASYAR_LOG_HXX__

#include "easyar/types.hxx"

namespace easyar {

class Log
{
public:
    static void setLogFunc(FunctorOfVoidFromLogLevelAndString func);
    static void resetLogFunc();
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMLOGLEVELANDSTRING__
#define __EASYAR_FUNCTOROFVOIDFROMLOGLEVELANDSTRING__
struct FunctorOfVoidFromLogLevelAndString
{
    void * _state;
    void (* func)(void * _state, LogLevel, String *);
    void (* destroy)(void * _state);
    FunctorOfVoidFromLogLevelAndString(void * _state, void (* func)(void * _state, LogLevel, String *), void (* destroy)(void * _state));
};

static void FunctorOfVoidFromLogLevelAndString_func(void * _state, easyar_LogLevel, easyar_String *);
static void FunctorOfVoidFromLogLevelAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromLogLevelAndString FunctorOfVoidFromLogLevelAndString_to_c(FunctorOfVoidFromLogLevelAndString f);
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_LOG_HXX__
#define __IMPLEMENTATION_EASYAR_LOG_HXX__

#include "easyar/log.h"

namespace easyar {

inline void Log::setLogFunc(FunctorOfVoidFromLogLevelAndString arg0)
{
    easyar_Log_setLogFunc(FunctorOfVoidFromLogLevelAndString_to_c(arg0));
}
inline void Log::resetLogFunc()
{
    easyar_Log_resetLogFunc();
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMLOGLEVELANDSTRING__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMLOGLEVELANDSTRING__
inline FunctorOfVoidFromLogLevelAndString::FunctorOfVoidFromLogLevelAndString(void * _state, void (* func)(void * _state, LogLevel, String *), void (* destroy)(void * _state))
{
    this->_state = _state;
    this->func = func;
    this->destroy = destroy;
}
static void FunctorOfVoidFromLogLevelAndString_func(void * _state, easyar_LogLevel arg0, easyar_String * arg1)
{
    LogLevel cpparg0 = static_cast<LogLevel>(arg0);
    easyar_String_copy(arg1, &arg1);
    String * cpparg1 = (arg1) == NULL ? NULL : new String(arg1);
    FunctorOfVoidFromLogLevelAndString * f = reinterpret_cast<FunctorOfVoidFromLogLevelAndString *>(_state);
    f->func(f->_state, cpparg0, cpparg1);
    delete cpparg1;
}
static void FunctorOfVoidFromLogLevelAndString_destroy(void * _state)
{
    FunctorOfVoidFromLogLevelAndString * f = reinterpret_cast<FunctorOfVoidFromLogLevelAndString *>(_state);
    if (f->destroy) {
        f->destroy(f->_state);
    }
    delete f;
}
static inline easyar_FunctorOfVoidFromLogLevelAndString FunctorOfVoidFromLogLevelAndString_to_c(FunctorOfVoidFromLogLevelAndString f)
{
    easyar_FunctorOfVoidFromLogLevelAndString _return_value_ = {NULL, NULL, NULL};
    if ((f.func == NULL) && (f.destroy == NULL)) { return _return_value_; }
    _return_value_._state = new FunctorOfVoidFromLogLevelAndString(f._state, f.func, f.destroy);
    _return_value_.func = FunctorOfVoidFromLogLevelAndString_func;
    _return_value_.destroy = FunctorOfVoidFromLogLevelAndString_destroy;
    return _return_value_;
}
#endif

}

#endif
