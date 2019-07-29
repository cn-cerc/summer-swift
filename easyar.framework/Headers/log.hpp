//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_LOG_HPP__
#define __EASYAR_LOG_HPP__

#include "easyar/types.hpp"

namespace easyar {

class Log
{
public:
    static void setLogFunc(std::function<void(LogLevel, std::string)> func);
    static void resetLogFunc();
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMLOGLEVELANDSTRING__
#define __EASYAR_FUNCTOROFVOIDFROMLOGLEVELANDSTRING__
static void FunctorOfVoidFromLogLevelAndString_func(void * _state, easyar_LogLevel, easyar_String *);
static void FunctorOfVoidFromLogLevelAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromLogLevelAndString FunctorOfVoidFromLogLevelAndString_to_c(std::function<void(LogLevel, std::string)> f);
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_LOG_HPP__
#define __IMPLEMENTATION_EASYAR_LOG_HPP__

#include "easyar/log.h"

namespace easyar {

inline void Log::setLogFunc(std::function<void(LogLevel, std::string)> arg0)
{
    easyar_Log_setLogFunc(FunctorOfVoidFromLogLevelAndString_to_c(arg0));
}
inline void Log::resetLogFunc()
{
    easyar_Log_resetLogFunc();
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMLOGLEVELANDSTRING__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMLOGLEVELANDSTRING__
static void FunctorOfVoidFromLogLevelAndString_func(void * _state, easyar_LogLevel arg0, easyar_String * arg1)
{
    LogLevel cpparg0 = static_cast<LogLevel>(arg0);
    easyar_String_copy(arg1, &arg1);
    std::string cpparg1 = std_string_from_easyar_String(std::shared_ptr<easyar_String>(arg1, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
    auto f = reinterpret_cast<std::function<void(LogLevel, std::string)> *>(_state);
    (*f)(cpparg0, cpparg1);
}
static void FunctorOfVoidFromLogLevelAndString_destroy(void * _state)
{
    auto f = reinterpret_cast<std::function<void(LogLevel, std::string)> *>(_state);
    delete f;
}
static inline easyar_FunctorOfVoidFromLogLevelAndString FunctorOfVoidFromLogLevelAndString_to_c(std::function<void(LogLevel, std::string)> f)
{
    if (f == nullptr) { return easyar_FunctorOfVoidFromLogLevelAndString{nullptr, nullptr, nullptr}; }
    return easyar_FunctorOfVoidFromLogLevelAndString{new std::function<void(LogLevel, std::string)>(f), FunctorOfVoidFromLogLevelAndString_func, FunctorOfVoidFromLogLevelAndString_destroy};
}
#endif

}

#endif
