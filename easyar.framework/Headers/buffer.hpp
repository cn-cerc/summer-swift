//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_BUFFER_HPP__
#define __EASYAR_BUFFER_HPP__

#include "easyar/types.hpp"

namespace easyar {

class Buffer
{
protected:
    std::shared_ptr<easyar_Buffer> cdata_;
    void init_cdata(std::shared_ptr<easyar_Buffer> cdata);
    Buffer & operator=(const Buffer & data) = delete;
public:
    Buffer(std::shared_ptr<easyar_Buffer> cdata);
    virtual ~Buffer();

    std::shared_ptr<easyar_Buffer> get_cdata();

    static std::shared_ptr<Buffer> create(int size);
    void * data();
    int size();
    bool copyFrom(void * src, int srcPos, int destPos, int length);
};

class BufferDictionary
{
protected:
    std::shared_ptr<easyar_BufferDictionary> cdata_;
    void init_cdata(std::shared_ptr<easyar_BufferDictionary> cdata);
    BufferDictionary & operator=(const BufferDictionary & data) = delete;
public:
    BufferDictionary(std::shared_ptr<easyar_BufferDictionary> cdata);
    virtual ~BufferDictionary();

    std::shared_ptr<easyar_BufferDictionary> get_cdata();

    BufferDictionary();
    int count();
    bool contains(std::string path);
    std::shared_ptr<Buffer> tryGet(std::string path);
    void set(std::string path, std::shared_ptr<Buffer> buffer);
    bool remove(std::string path);
    void clear();
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_BUFFER_HPP__
#define __IMPLEMENTATION_EASYAR_BUFFER_HPP__

#include "easyar/buffer.h"

namespace easyar {

inline Buffer::Buffer(std::shared_ptr<easyar_Buffer> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline Buffer::~Buffer()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_Buffer> Buffer::get_cdata()
{
    return cdata_;
}
inline void Buffer::init_cdata(std::shared_ptr<easyar_Buffer> cdata)
{
    cdata_ = cdata;
}
inline std::shared_ptr<Buffer> Buffer::create(int arg0)
{
    easyar_Buffer * _return_value_;
    easyar_Buffer_create(arg0, &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<Buffer>(std::shared_ptr<easyar_Buffer>(_return_value_, [](easyar_Buffer * ptr) { easyar_Buffer__dtor(ptr); })));
}
inline void * Buffer::data()
{
    auto _return_value_ = easyar_Buffer_data(cdata_.get());
    return _return_value_;
}
inline int Buffer::size()
{
    auto _return_value_ = easyar_Buffer_size(cdata_.get());
    return _return_value_;
}
inline bool Buffer::copyFrom(void * arg0, int arg1, int arg2, int arg3)
{
    auto _return_value_ = easyar_Buffer_copyFrom(cdata_.get(), arg0, arg1, arg2, arg3);
    return _return_value_;
}

inline BufferDictionary::BufferDictionary(std::shared_ptr<easyar_BufferDictionary> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline BufferDictionary::~BufferDictionary()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_BufferDictionary> BufferDictionary::get_cdata()
{
    return cdata_;
}
inline void BufferDictionary::init_cdata(std::shared_ptr<easyar_BufferDictionary> cdata)
{
    cdata_ = cdata;
}
inline BufferDictionary::BufferDictionary()
    :
    cdata_(nullptr)
{
    easyar_BufferDictionary * _return_value_;
    easyar_BufferDictionary__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_BufferDictionary>(_return_value_, [](easyar_BufferDictionary * ptr) { easyar_BufferDictionary__dtor(ptr); }));
}
inline int BufferDictionary::count()
{
    auto _return_value_ = easyar_BufferDictionary_count(cdata_.get());
    return _return_value_;
}
inline bool BufferDictionary::contains(std::string arg0)
{
    auto _return_value_ = easyar_BufferDictionary_contains(cdata_.get(), std_string_to_easyar_String(arg0).get());
    return _return_value_;
}
inline std::shared_ptr<Buffer> BufferDictionary::tryGet(std::string arg0)
{
    easyar_Buffer * _return_value_;
    easyar_BufferDictionary_tryGet(cdata_.get(), std_string_to_easyar_String(arg0).get(), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<Buffer>(std::shared_ptr<easyar_Buffer>(_return_value_, [](easyar_Buffer * ptr) { easyar_Buffer__dtor(ptr); })));
}
inline void BufferDictionary::set(std::string arg0, std::shared_ptr<Buffer> arg1)
{
    easyar_BufferDictionary_set(cdata_.get(), std_string_to_easyar_String(arg0).get(), (arg1 == nullptr ? nullptr : arg1->get_cdata().get()));
}
inline bool BufferDictionary::remove(std::string arg0)
{
    auto _return_value_ = easyar_BufferDictionary_remove(cdata_.get(), std_string_to_easyar_String(arg0).get());
    return _return_value_;
}
inline void BufferDictionary::clear()
{
    easyar_BufferDictionary_clear(cdata_.get());
}

}

#endif
