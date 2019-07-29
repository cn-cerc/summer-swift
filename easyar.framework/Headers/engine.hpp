//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_ENGINE_HPP__
#define __EASYAR_ENGINE_HPP__

#include "easyar/types.hpp"

namespace easyar {

class Engine
{
public:
    static int schemaHash();
    static bool initialize(std::string key);
    static void onPause();
    static void onResume();
    static std::string errorMessage();
    static std::string versionString();
    static std::string name();
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_ENGINE_HPP__
#define __IMPLEMENTATION_EASYAR_ENGINE_HPP__

#include "easyar/engine.h"

namespace easyar {

inline int Engine::schemaHash()
{
    auto _return_value_ = easyar_Engine_schemaHash();
    return _return_value_;
}
inline bool Engine::initialize(std::string arg0)
{
    if (easyar_Engine_schemaHash() != 1802288139) {
        throw std::runtime_error("SchemaHashNotMatched");
    }
    auto _return_value_ = easyar_Engine_initialize(std_string_to_easyar_String(arg0).get());
    return _return_value_;
}
inline void Engine::onPause()
{
    easyar_Engine_onPause();
}
inline void Engine::onResume()
{
    easyar_Engine_onResume();
}
inline std::string Engine::errorMessage()
{
    easyar_String * _return_value_;
    easyar_Engine_errorMessage(&_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string Engine::versionString()
{
    easyar_String * _return_value_;
    easyar_Engine_versionString(&_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string Engine::name()
{
    easyar_String * _return_value_;
    easyar_Engine_name(&_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}

}

#endif
