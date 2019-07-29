//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_RENDERER_HXX__
#define __EASYAR_RENDERER_HXX__

#include "easyar/types.hxx"

namespace easyar {

class TextureId
{
protected:
    easyar_TextureId * cdata_ ;
    void init_cdata(easyar_TextureId * cdata);
    virtual TextureId & operator=(const TextureId & data) { return *this; } //deleted
public:
    TextureId(easyar_TextureId * cdata);
    virtual ~TextureId();

    TextureId(const TextureId & data);
    const easyar_TextureId * get_cdata() const;
    easyar_TextureId * get_cdata();

    int getInt();
    void * getPointer();
    static void fromInt(int _value, /* OUT */ TextureId * * Return);
    static void fromPointer(void * ptr, /* OUT */ TextureId * * Return);
};

class Renderer
{
protected:
    easyar_Renderer * cdata_ ;
    void init_cdata(easyar_Renderer * cdata);
    virtual Renderer & operator=(const Renderer & data) { return *this; } //deleted
public:
    Renderer(easyar_Renderer * cdata);
    virtual ~Renderer();

    Renderer(const Renderer & data);
    const easyar_Renderer * get_cdata() const;
    easyar_Renderer * get_cdata();

    Renderer();
    void chooseAPI(RendererAPI api);
    void setDevice(void * device);
    bool render(Drawable * frame, float viewPortAspectRatio, int screenRotation);
    bool renderToTexture(Drawable * frame, TextureId * texture);
    bool renderErrorMessage(float viewPortAspectRatio, int screenRotation);
    bool renderErrorMessageToTexture(TextureId * texture);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_RENDERER_HXX__
#define __IMPLEMENTATION_EASYAR_RENDERER_HXX__

#include "easyar/renderer.h"
#include "easyar/drawable.hxx"

namespace easyar {

inline TextureId::TextureId(easyar_TextureId * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline TextureId::~TextureId()
{
    if (cdata_) {
        easyar_TextureId__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline TextureId::TextureId(const TextureId & data)
    :
    cdata_(NULL)
{
    easyar_TextureId * cdata = NULL;
    easyar_TextureId__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_TextureId * TextureId::get_cdata() const
{
    return cdata_;
}
inline easyar_TextureId * TextureId::get_cdata()
{
    return cdata_;
}
inline void TextureId::init_cdata(easyar_TextureId * cdata)
{
    cdata_ = cdata;
}
inline int TextureId::getInt()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_TextureId_getInt(cdata_);
    return _return_value_;
}
inline void * TextureId::getPointer()
{
    if (cdata_ == NULL) {
        return NULL;
    }
    void * _return_value_ = easyar_TextureId_getPointer(cdata_);
    return _return_value_;
}
inline void TextureId::fromInt(int arg0, /* OUT */ TextureId * * Return)
{
    easyar_TextureId * _return_value_ = NULL;
    easyar_TextureId_fromInt(arg0, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new TextureId(_return_value_));
}
inline void TextureId::fromPointer(void * arg0, /* OUT */ TextureId * * Return)
{
    easyar_TextureId * _return_value_ = NULL;
    easyar_TextureId_fromPointer(arg0, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new TextureId(_return_value_));
}

inline Renderer::Renderer(easyar_Renderer * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline Renderer::~Renderer()
{
    if (cdata_) {
        easyar_Renderer__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline Renderer::Renderer(const Renderer & data)
    :
    cdata_(NULL)
{
    easyar_Renderer * cdata = NULL;
    easyar_Renderer__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_Renderer * Renderer::get_cdata() const
{
    return cdata_;
}
inline easyar_Renderer * Renderer::get_cdata()
{
    return cdata_;
}
inline void Renderer::init_cdata(easyar_Renderer * cdata)
{
    cdata_ = cdata;
}
inline Renderer::Renderer()
    :
    cdata_(NULL)
{
    easyar_Renderer * _return_value_ = NULL;
    easyar_Renderer__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline void Renderer::chooseAPI(RendererAPI arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Renderer_chooseAPI(cdata_, static_cast<easyar_RendererAPI>(arg0));
}
inline void Renderer::setDevice(void * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Renderer_setDevice(cdata_, arg0);
}
inline bool Renderer::render(Drawable * arg0, float arg1, int arg2)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Renderer_render(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()), arg1, arg2);
    return _return_value_;
}
inline bool Renderer::renderToTexture(Drawable * arg0, TextureId * arg1)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Renderer_renderToTexture(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()), (arg1 == NULL ? NULL : arg1->get_cdata()));
    return _return_value_;
}
inline bool Renderer::renderErrorMessage(float arg0, int arg1)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Renderer_renderErrorMessage(cdata_, arg0, arg1);
    return _return_value_;
}
inline bool Renderer::renderErrorMessageToTexture(TextureId * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Renderer_renderErrorMessageToTexture(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}

}

#endif
