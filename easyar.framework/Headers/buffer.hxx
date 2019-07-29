//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_BUFFER_HXX__
#define __EASYAR_BUFFER_HXX__

#include "easyar/types.hxx"

namespace easyar {

class Buffer
{
protected:
    easyar_Buffer * cdata_ ;
    void init_cdata(easyar_Buffer * cdata);
    virtual Buffer & operator=(const Buffer & data) { return *this; } //deleted
public:
    Buffer(easyar_Buffer * cdata);
    virtual ~Buffer();

    Buffer(const Buffer & data);
    const easyar_Buffer * get_cdata() const;
    easyar_Buffer * get_cdata();

    static void create(int size, /* OUT */ Buffer * * Return);
    void * data();
    int size();
    bool copyFrom(void * src, int srcPos, int destPos, int length);
};

class BufferDictionary
{
protected:
    easyar_BufferDictionary * cdata_ ;
    void init_cdata(easyar_BufferDictionary * cdata);
    virtual BufferDictionary & operator=(const BufferDictionary & data) { return *this; } //deleted
public:
    BufferDictionary(easyar_BufferDictionary * cdata);
    virtual ~BufferDictionary();

    BufferDictionary(const BufferDictionary & data);
    const easyar_BufferDictionary * get_cdata() const;
    easyar_BufferDictionary * get_cdata();

    BufferDictionary();
    int count();
    bool contains(String * path);
    void tryGet(String * path, /* OUT */ Buffer * * Return);
    void set(String * path, Buffer * buffer);
    bool remove(String * path);
    void clear();
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_BUFFER_HXX__
#define __IMPLEMENTATION_EASYAR_BUFFER_HXX__

#include "easyar/buffer.h"

namespace easyar {

inline Buffer::Buffer(easyar_Buffer * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline Buffer::~Buffer()
{
    if (cdata_) {
        easyar_Buffer__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline Buffer::Buffer(const Buffer & data)
    :
    cdata_(NULL)
{
    easyar_Buffer * cdata = NULL;
    easyar_Buffer__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_Buffer * Buffer::get_cdata() const
{
    return cdata_;
}
inline easyar_Buffer * Buffer::get_cdata()
{
    return cdata_;
}
inline void Buffer::init_cdata(easyar_Buffer * cdata)
{
    cdata_ = cdata;
}
inline void Buffer::create(int arg0, /* OUT */ Buffer * * Return)
{
    easyar_Buffer * _return_value_ = NULL;
    easyar_Buffer_create(arg0, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new Buffer(_return_value_));
}
inline void * Buffer::data()
{
    if (cdata_ == NULL) {
        return NULL;
    }
    void * _return_value_ = easyar_Buffer_data(cdata_);
    return _return_value_;
}
inline int Buffer::size()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_Buffer_size(cdata_);
    return _return_value_;
}
inline bool Buffer::copyFrom(void * arg0, int arg1, int arg2, int arg3)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Buffer_copyFrom(cdata_, arg0, arg1, arg2, arg3);
    return _return_value_;
}

inline BufferDictionary::BufferDictionary(easyar_BufferDictionary * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline BufferDictionary::~BufferDictionary()
{
    if (cdata_) {
        easyar_BufferDictionary__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline BufferDictionary::BufferDictionary(const BufferDictionary & data)
    :
    cdata_(NULL)
{
    easyar_BufferDictionary * cdata = NULL;
    easyar_BufferDictionary__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_BufferDictionary * BufferDictionary::get_cdata() const
{
    return cdata_;
}
inline easyar_BufferDictionary * BufferDictionary::get_cdata()
{
    return cdata_;
}
inline void BufferDictionary::init_cdata(easyar_BufferDictionary * cdata)
{
    cdata_ = cdata;
}
inline BufferDictionary::BufferDictionary()
    :
    cdata_(NULL)
{
    easyar_BufferDictionary * _return_value_ = NULL;
    easyar_BufferDictionary__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline int BufferDictionary::count()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_BufferDictionary_count(cdata_);
    return _return_value_;
}
inline bool BufferDictionary::contains(String * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_BufferDictionary_contains(cdata_, arg0->get_cdata());
    return _return_value_;
}
inline void BufferDictionary::tryGet(String * arg0, /* OUT */ Buffer * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_Buffer * _return_value_ = NULL;
    easyar_BufferDictionary_tryGet(cdata_, arg0->get_cdata(), &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new Buffer(_return_value_));
}
inline void BufferDictionary::set(String * arg0, Buffer * arg1)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_BufferDictionary_set(cdata_, arg0->get_cdata(), (arg1 == NULL ? NULL : arg1->get_cdata()));
}
inline bool BufferDictionary::remove(String * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_BufferDictionary_remove(cdata_, arg0->get_cdata());
    return _return_value_;
}
inline void BufferDictionary::clear()
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_BufferDictionary_clear(cdata_);
}

}

#endif
