//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_OBJECTTARGET_HXX__
#define __EASYAR_OBJECTTARGET_HXX__

#include "easyar/types.hxx"
#include "easyar/target.hxx"

namespace easyar {

class ObjectTargetParameters
{
protected:
    easyar_ObjectTargetParameters * cdata_ ;
    void init_cdata(easyar_ObjectTargetParameters * cdata);
    virtual ObjectTargetParameters & operator=(const ObjectTargetParameters & data) { return *this; } //deleted
public:
    ObjectTargetParameters(easyar_ObjectTargetParameters * cdata);
    virtual ~ObjectTargetParameters();

    ObjectTargetParameters(const ObjectTargetParameters & data);
    const easyar_ObjectTargetParameters * get_cdata() const;
    easyar_ObjectTargetParameters * get_cdata();

    ObjectTargetParameters();
    void bufferDictionary(/* OUT */ BufferDictionary * * Return);
    void setBufferDictionary(BufferDictionary * bufferDictionary);
    void objPath(/* OUT */ String * * Return);
    void setObjPath(String * objPath);
    void name(/* OUT */ String * * Return);
    void setName(String * name);
    void uid(/* OUT */ String * * Return);
    void setUid(String * uid);
    void meta(/* OUT */ String * * Return);
    void setMeta(String * meta);
    float scale();
    void setScale(float size);
};

class ObjectTarget : public Target
{
protected:
    easyar_ObjectTarget * cdata_ ;
    void init_cdata(easyar_ObjectTarget * cdata);
    virtual ObjectTarget & operator=(const ObjectTarget & data) { return *this; } //deleted
public:
    ObjectTarget(easyar_ObjectTarget * cdata);
    virtual ~ObjectTarget();

    ObjectTarget(const ObjectTarget & data);
    const easyar_ObjectTarget * get_cdata() const;
    easyar_ObjectTarget * get_cdata();

    ObjectTarget();
    static void createFromParameters(ObjectTargetParameters * parameters, /* OUT */ ObjectTarget * * Return);
    bool setup(String * path, int storageType, String * name);
    static void setupAll(String * path, int storageType, /* OUT */ ListOfPointerOfObjectTarget * * Return);
    float scale();
    void boundingBox(/* OUT */ ListOfVec3F * * Return);
    bool setScale(float scale);
    int runtimeID();
    void uid(/* OUT */ String * * Return);
    void name(/* OUT */ String * * Return);
    void meta(/* OUT */ String * * Return);
    void setMeta(String * data);
    static void tryCastFromTarget(Target * v, /* OUT */ ObjectTarget * * Return);
};

#ifndef __EASYAR_LISTOFPOINTEROFOBJECTTARGET__
#define __EASYAR_LISTOFPOINTEROFOBJECTTARGET__
class ListOfPointerOfObjectTarget
{
private:
    easyar_ListOfPointerOfObjectTarget * cdata_;
    virtual ListOfPointerOfObjectTarget & operator=(const ListOfPointerOfObjectTarget & data) { return *this; } //deleted
public:
    ListOfPointerOfObjectTarget(easyar_ListOfPointerOfObjectTarget * cdata);
    virtual ~ListOfPointerOfObjectTarget();

    ListOfPointerOfObjectTarget(const ListOfPointerOfObjectTarget & data);
    const easyar_ListOfPointerOfObjectTarget * get_cdata() const;
    easyar_ListOfPointerOfObjectTarget * get_cdata();

    ListOfPointerOfObjectTarget(easyar_ObjectTarget * * begin, easyar_ObjectTarget * * end);
    int size() const;
    ObjectTarget * at(int index) const;
};
#endif

#ifndef __EASYAR_LISTOFVEC_F__
#define __EASYAR_LISTOFVEC_F__
class ListOfVec3F
{
private:
    easyar_ListOfVec3F * cdata_;
    virtual ListOfVec3F & operator=(const ListOfVec3F & data) { return *this; } //deleted
public:
    ListOfVec3F(easyar_ListOfVec3F * cdata);
    virtual ~ListOfVec3F();

    ListOfVec3F(const ListOfVec3F & data);
    const easyar_ListOfVec3F * get_cdata() const;
    easyar_ListOfVec3F * get_cdata();

    ListOfVec3F(easyar_Vec3F * begin, easyar_Vec3F * end);
    int size() const;
    Vec3F at(int index) const;
};
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_OBJECTTARGET_HXX__
#define __IMPLEMENTATION_EASYAR_OBJECTTARGET_HXX__

#include "easyar/objecttarget.h"
#include "easyar/buffer.hxx"
#include "easyar/target.hxx"
#include "easyar/vector.hxx"

namespace easyar {

inline ObjectTargetParameters::ObjectTargetParameters(easyar_ObjectTargetParameters * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline ObjectTargetParameters::~ObjectTargetParameters()
{
    if (cdata_) {
        easyar_ObjectTargetParameters__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ObjectTargetParameters::ObjectTargetParameters(const ObjectTargetParameters & data)
    :
    cdata_(NULL)
{
    easyar_ObjectTargetParameters * cdata = NULL;
    easyar_ObjectTargetParameters__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_ObjectTargetParameters * ObjectTargetParameters::get_cdata() const
{
    return cdata_;
}
inline easyar_ObjectTargetParameters * ObjectTargetParameters::get_cdata()
{
    return cdata_;
}
inline void ObjectTargetParameters::init_cdata(easyar_ObjectTargetParameters * cdata)
{
    cdata_ = cdata;
}
inline ObjectTargetParameters::ObjectTargetParameters()
    :
    cdata_(NULL)
{
    easyar_ObjectTargetParameters * _return_value_ = NULL;
    easyar_ObjectTargetParameters__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline void ObjectTargetParameters::bufferDictionary(/* OUT */ BufferDictionary * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_BufferDictionary * _return_value_ = NULL;
    easyar_ObjectTargetParameters_bufferDictionary(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new BufferDictionary(_return_value_));
}
inline void ObjectTargetParameters::setBufferDictionary(BufferDictionary * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_ObjectTargetParameters_setBufferDictionary(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
}
inline void ObjectTargetParameters::objPath(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ObjectTargetParameters_objPath(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ObjectTargetParameters::setObjPath(String * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_ObjectTargetParameters_setObjPath(cdata_, arg0->get_cdata());
}
inline void ObjectTargetParameters::name(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ObjectTargetParameters_name(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ObjectTargetParameters::setName(String * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_ObjectTargetParameters_setName(cdata_, arg0->get_cdata());
}
inline void ObjectTargetParameters::uid(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ObjectTargetParameters_uid(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ObjectTargetParameters::setUid(String * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_ObjectTargetParameters_setUid(cdata_, arg0->get_cdata());
}
inline void ObjectTargetParameters::meta(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ObjectTargetParameters_meta(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ObjectTargetParameters::setMeta(String * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_ObjectTargetParameters_setMeta(cdata_, arg0->get_cdata());
}
inline float ObjectTargetParameters::scale()
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_ObjectTargetParameters_scale(cdata_);
    return _return_value_;
}
inline void ObjectTargetParameters::setScale(float arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_ObjectTargetParameters_setScale(cdata_, arg0);
}

inline ObjectTarget::ObjectTarget(easyar_ObjectTarget * cdata)
    :
    Target(static_cast<easyar_Target *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline ObjectTarget::~ObjectTarget()
{
    if (cdata_) {
        easyar_ObjectTarget__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ObjectTarget::ObjectTarget(const ObjectTarget & data)
    :
    Target(static_cast<easyar_Target *>(NULL)),
    cdata_(NULL)
{
    easyar_ObjectTarget * cdata = NULL;
    easyar_ObjectTarget__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_ObjectTarget * ObjectTarget::get_cdata() const
{
    return cdata_;
}
inline easyar_ObjectTarget * ObjectTarget::get_cdata()
{
    return cdata_;
}
inline void ObjectTarget::init_cdata(easyar_ObjectTarget * cdata)
{
    cdata_ = cdata;
    {
        easyar_Target * cdata_inner = NULL;
        easyar_castObjectTargetToTarget(cdata, &cdata_inner);
        Target::init_cdata(cdata_inner);
    }
}
inline ObjectTarget::ObjectTarget()
    :
    Target(static_cast<easyar_Target *>(NULL)),
    cdata_(NULL)
{
    easyar_ObjectTarget * _return_value_ = NULL;
    easyar_ObjectTarget__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline void ObjectTarget::createFromParameters(ObjectTargetParameters * arg0, /* OUT */ ObjectTarget * * Return)
{
    easyar_ObjectTarget * _return_value_ = NULL;
    easyar_ObjectTarget_createFromParameters((arg0 == NULL ? NULL : arg0->get_cdata()), &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new ObjectTarget(_return_value_));
}
inline bool ObjectTarget::setup(String * arg0, int arg1, String * arg2)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ObjectTarget_setup(cdata_, arg0->get_cdata(), arg1, arg2->get_cdata());
    return _return_value_;
}
inline void ObjectTarget::setupAll(String * arg0, int arg1, /* OUT */ ListOfPointerOfObjectTarget * * Return)
{
    easyar_ListOfPointerOfObjectTarget * _return_value_ = NULL;
    easyar_ObjectTarget_setupAll(arg0->get_cdata(), arg1, &_return_value_);
    *Return = new ListOfPointerOfObjectTarget(_return_value_);
}
inline float ObjectTarget::scale()
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_ObjectTarget_scale(cdata_);
    return _return_value_;
}
inline void ObjectTarget::boundingBox(/* OUT */ ListOfVec3F * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ListOfVec3F * _return_value_ = NULL;
    easyar_ObjectTarget_boundingBox(cdata_, &_return_value_);
    *Return = new ListOfVec3F(_return_value_);
}
inline bool ObjectTarget::setScale(float arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ObjectTarget_setScale(cdata_, arg0);
    return _return_value_;
}
inline int ObjectTarget::runtimeID()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_ObjectTarget_runtimeID(cdata_);
    return _return_value_;
}
inline void ObjectTarget::uid(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ObjectTarget_uid(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ObjectTarget::name(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ObjectTarget_name(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ObjectTarget::meta(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ObjectTarget_meta(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ObjectTarget::setMeta(String * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_ObjectTarget_setMeta(cdata_, arg0->get_cdata());
}
inline void ObjectTarget::tryCastFromTarget(Target * v, /* OUT */ ObjectTarget * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ObjectTarget * cdata = NULL;
    easyar_tryCastTargetToObjectTarget(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new ObjectTarget(cdata);
}

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFOBJECTTARGET__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFOBJECTTARGET__
inline ListOfPointerOfObjectTarget::ListOfPointerOfObjectTarget(easyar_ListOfPointerOfObjectTarget * cdata)
    : cdata_(cdata)
{
}
inline ListOfPointerOfObjectTarget::~ListOfPointerOfObjectTarget()
{
    if (cdata_) {
        easyar_ListOfPointerOfObjectTarget__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ListOfPointerOfObjectTarget::ListOfPointerOfObjectTarget(const ListOfPointerOfObjectTarget & data)
    : cdata_(static_cast<easyar_ListOfPointerOfObjectTarget *>(NULL))
{
    easyar_ListOfPointerOfObjectTarget_copy(data.cdata_, &cdata_);
}
inline const easyar_ListOfPointerOfObjectTarget * ListOfPointerOfObjectTarget::get_cdata() const
{
    return cdata_;
}
inline easyar_ListOfPointerOfObjectTarget * ListOfPointerOfObjectTarget::get_cdata()
{
    return cdata_;
}

inline ListOfPointerOfObjectTarget::ListOfPointerOfObjectTarget(easyar_ObjectTarget * * begin, easyar_ObjectTarget * * end)
    : cdata_(static_cast<easyar_ListOfPointerOfObjectTarget *>(NULL))
{
    easyar_ListOfPointerOfObjectTarget__ctor(begin, end, &cdata_);
}
inline int ListOfPointerOfObjectTarget::size() const
{
    return easyar_ListOfPointerOfObjectTarget_size(cdata_);
}
inline ObjectTarget * ListOfPointerOfObjectTarget::at(int index) const
{
    easyar_ObjectTarget * _return_value_ = easyar_ListOfPointerOfObjectTarget_at(cdata_, index);
    easyar_ObjectTarget__retain(_return_value_, &_return_value_);
    return (_return_value_ == NULL ? NULL : new ObjectTarget(_return_value_));
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_LISTOFVEC_F__
#define __IMPLEMENTATION_EASYAR_LISTOFVEC_F__
inline ListOfVec3F::ListOfVec3F(easyar_ListOfVec3F * cdata)
    : cdata_(cdata)
{
}
inline ListOfVec3F::~ListOfVec3F()
{
    if (cdata_) {
        easyar_ListOfVec3F__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ListOfVec3F::ListOfVec3F(const ListOfVec3F & data)
    : cdata_(static_cast<easyar_ListOfVec3F *>(NULL))
{
    easyar_ListOfVec3F_copy(data.cdata_, &cdata_);
}
inline const easyar_ListOfVec3F * ListOfVec3F::get_cdata() const
{
    return cdata_;
}
inline easyar_ListOfVec3F * ListOfVec3F::get_cdata()
{
    return cdata_;
}

inline ListOfVec3F::ListOfVec3F(easyar_Vec3F * begin, easyar_Vec3F * end)
    : cdata_(static_cast<easyar_ListOfVec3F *>(NULL))
{
    easyar_ListOfVec3F__ctor(begin, end, &cdata_);
}
inline int ListOfVec3F::size() const
{
    return easyar_ListOfVec3F_size(cdata_);
}
inline Vec3F ListOfVec3F::at(int index) const
{
    easyar_Vec3F _return_value_ = easyar_ListOfVec3F_at(cdata_, index);
    return Vec3F(_return_value_.data[0], _return_value_.data[1], _return_value_.data[2]);
}
#endif

}

#endif
