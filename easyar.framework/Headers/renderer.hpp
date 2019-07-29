//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_RENDERER_HPP__
#define __EASYAR_RENDERER_HPP__

#include "easyar/types.hpp"

namespace easyar {

class TextureId
{
protected:
    std::shared_ptr<easyar_TextureId> cdata_;
    void init_cdata(std::shared_ptr<easyar_TextureId> cdata);
    TextureId & operator=(const TextureId & data) = delete;
public:
    TextureId(std::shared_ptr<easyar_TextureId> cdata);
    virtual ~TextureId();

    std::shared_ptr<easyar_TextureId> get_cdata();

    int getInt();
    void * getPointer();
    static std::shared_ptr<TextureId> fromInt(int _value);
    static std::shared_ptr<TextureId> fromPointer(void * ptr);
};

class Renderer
{
protected:
    std::shared_ptr<easyar_Renderer> cdata_;
    void init_cdata(std::shared_ptr<easyar_Renderer> cdata);
    Renderer & operator=(const Renderer & data) = delete;
public:
    Renderer(std::shared_ptr<easyar_Renderer> cdata);
    virtual ~Renderer();

    std::shared_ptr<easyar_Renderer> get_cdata();

    Renderer();
    void chooseAPI(RendererAPI api);
    void setDevice(void * device);
    bool render(std::shared_ptr<Drawable> frame, float viewPortAspectRatio, int screenRotation);
    bool renderToTexture(std::shared_ptr<Drawable> frame, std::shared_ptr<TextureId> texture);
    bool renderErrorMessage(float viewPortAspectRatio, int screenRotation);
    bool renderErrorMessageToTexture(std::shared_ptr<TextureId> texture);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_RENDERER_HPP__
#define __IMPLEMENTATION_EASYAR_RENDERER_HPP__

#include "easyar/renderer.h"
#include "easyar/drawable.hpp"

namespace easyar {

inline TextureId::TextureId(std::shared_ptr<easyar_TextureId> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline TextureId::~TextureId()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_TextureId> TextureId::get_cdata()
{
    return cdata_;
}
inline void TextureId::init_cdata(std::shared_ptr<easyar_TextureId> cdata)
{
    cdata_ = cdata;
}
inline int TextureId::getInt()
{
    auto _return_value_ = easyar_TextureId_getInt(cdata_.get());
    return _return_value_;
}
inline void * TextureId::getPointer()
{
    auto _return_value_ = easyar_TextureId_getPointer(cdata_.get());
    return _return_value_;
}
inline std::shared_ptr<TextureId> TextureId::fromInt(int arg0)
{
    easyar_TextureId * _return_value_;
    easyar_TextureId_fromInt(arg0, &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<TextureId>(std::shared_ptr<easyar_TextureId>(_return_value_, [](easyar_TextureId * ptr) { easyar_TextureId__dtor(ptr); })));
}
inline std::shared_ptr<TextureId> TextureId::fromPointer(void * arg0)
{
    easyar_TextureId * _return_value_;
    easyar_TextureId_fromPointer(arg0, &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<TextureId>(std::shared_ptr<easyar_TextureId>(_return_value_, [](easyar_TextureId * ptr) { easyar_TextureId__dtor(ptr); })));
}

inline Renderer::Renderer(std::shared_ptr<easyar_Renderer> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline Renderer::~Renderer()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_Renderer> Renderer::get_cdata()
{
    return cdata_;
}
inline void Renderer::init_cdata(std::shared_ptr<easyar_Renderer> cdata)
{
    cdata_ = cdata;
}
inline Renderer::Renderer()
    :
    cdata_(nullptr)
{
    easyar_Renderer * _return_value_;
    easyar_Renderer__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_Renderer>(_return_value_, [](easyar_Renderer * ptr) { easyar_Renderer__dtor(ptr); }));
}
inline void Renderer::chooseAPI(RendererAPI arg0)
{
    easyar_Renderer_chooseAPI(cdata_.get(), static_cast<easyar_RendererAPI>(arg0));
}
inline void Renderer::setDevice(void * arg0)
{
    easyar_Renderer_setDevice(cdata_.get(), arg0);
}
inline bool Renderer::render(std::shared_ptr<Drawable> arg0, float arg1, int arg2)
{
    auto _return_value_ = easyar_Renderer_render(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), arg1, arg2);
    return _return_value_;
}
inline bool Renderer::renderToTexture(std::shared_ptr<Drawable> arg0, std::shared_ptr<TextureId> arg1)
{
    auto _return_value_ = easyar_Renderer_renderToTexture(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), (arg1 == nullptr ? nullptr : arg1->get_cdata().get()));
    return _return_value_;
}
inline bool Renderer::renderErrorMessage(float arg0, int arg1)
{
    auto _return_value_ = easyar_Renderer_renderErrorMessage(cdata_.get(), arg0, arg1);
    return _return_value_;
}
inline bool Renderer::renderErrorMessageToTexture(std::shared_ptr<TextureId> arg0)
{
    auto _return_value_ = easyar_Renderer_renderErrorMessageToTexture(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}

}

#endif
