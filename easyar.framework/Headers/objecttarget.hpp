//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_OBJECTTARGET_HPP__
#define __EASYAR_OBJECTTARGET_HPP__

#include "easyar/types.hpp"
#include "easyar/target.hpp"

namespace easyar {

class ObjectTargetParameters
{
protected:
    std::shared_ptr<easyar_ObjectTargetParameters> cdata_;
    void init_cdata(std::shared_ptr<easyar_ObjectTargetParameters> cdata);
    ObjectTargetParameters & operator=(const ObjectTargetParameters & data) = delete;
public:
    ObjectTargetParameters(std::shared_ptr<easyar_ObjectTargetParameters> cdata);
    virtual ~ObjectTargetParameters();

    std::shared_ptr<easyar_ObjectTargetParameters> get_cdata();

    ObjectTargetParameters();
    std::shared_ptr<BufferDictionary> bufferDictionary();
    void setBufferDictionary(std::shared_ptr<BufferDictionary> bufferDictionary);
    std::string objPath();
    void setObjPath(std::string objPath);
    std::string name();
    void setName(std::string name);
    std::string uid();
    void setUid(std::string uid);
    std::string meta();
    void setMeta(std::string meta);
    float scale();
    void setScale(float size);
};

class ObjectTarget : public Target
{
protected:
    std::shared_ptr<easyar_ObjectTarget> cdata_;
    void init_cdata(std::shared_ptr<easyar_ObjectTarget> cdata);
    ObjectTarget & operator=(const ObjectTarget & data) = delete;
public:
    ObjectTarget(std::shared_ptr<easyar_ObjectTarget> cdata);
    virtual ~ObjectTarget();

    std::shared_ptr<easyar_ObjectTarget> get_cdata();

    ObjectTarget();
    static std::shared_ptr<ObjectTarget> createFromParameters(std::shared_ptr<ObjectTargetParameters> parameters);
    bool setup(std::string path, int storageType, std::string name);
    static std::vector<std::shared_ptr<ObjectTarget>> setupAll(std::string path, int storageType);
    float scale();
    std::vector<Vec3F> boundingBox();
    bool setScale(float scale);
    int runtimeID();
    std::string uid();
    std::string name();
    std::string meta();
    void setMeta(std::string data);
    static std::shared_ptr<ObjectTarget> tryCastFromTarget(std::shared_ptr<Target> v);
};

#ifndef __EASYAR_LISTOFPOINTEROFOBJECTTARGET__
#define __EASYAR_LISTOFPOINTEROFOBJECTTARGET__
static inline std::shared_ptr<easyar_ListOfPointerOfObjectTarget> std_vector_to_easyar_ListOfPointerOfObjectTarget(std::vector<std::shared_ptr<ObjectTarget>> l);
static inline std::vector<std::shared_ptr<ObjectTarget>> std_vector_from_easyar_ListOfPointerOfObjectTarget(std::shared_ptr<easyar_ListOfPointerOfObjectTarget> pl);
#endif

#ifndef __EASYAR_LISTOFVEC_F__
#define __EASYAR_LISTOFVEC_F__
static inline std::shared_ptr<easyar_ListOfVec3F> std_vector_to_easyar_ListOfVec3F(std::vector<Vec3F> l);
static inline std::vector<Vec3F> std_vector_from_easyar_ListOfVec3F(std::shared_ptr<easyar_ListOfVec3F> pl);
#endif

}

namespace std {

template<>
inline shared_ptr<easyar::ObjectTarget> dynamic_pointer_cast<easyar::ObjectTarget, easyar::Target>(const shared_ptr<easyar::Target> & r) noexcept
{
    return easyar::ObjectTarget::tryCastFromTarget(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_OBJECTTARGET_HPP__
#define __IMPLEMENTATION_EASYAR_OBJECTTARGET_HPP__

#include "easyar/objecttarget.h"
#include "easyar/buffer.hpp"
#include "easyar/target.hpp"
#include "easyar/vector.hpp"

namespace easyar {

inline ObjectTargetParameters::ObjectTargetParameters(std::shared_ptr<easyar_ObjectTargetParameters> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline ObjectTargetParameters::~ObjectTargetParameters()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_ObjectTargetParameters> ObjectTargetParameters::get_cdata()
{
    return cdata_;
}
inline void ObjectTargetParameters::init_cdata(std::shared_ptr<easyar_ObjectTargetParameters> cdata)
{
    cdata_ = cdata;
}
inline ObjectTargetParameters::ObjectTargetParameters()
    :
    cdata_(nullptr)
{
    easyar_ObjectTargetParameters * _return_value_;
    easyar_ObjectTargetParameters__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_ObjectTargetParameters>(_return_value_, [](easyar_ObjectTargetParameters * ptr) { easyar_ObjectTargetParameters__dtor(ptr); }));
}
inline std::shared_ptr<BufferDictionary> ObjectTargetParameters::bufferDictionary()
{
    easyar_BufferDictionary * _return_value_;
    easyar_ObjectTargetParameters_bufferDictionary(cdata_.get(), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<BufferDictionary>(std::shared_ptr<easyar_BufferDictionary>(_return_value_, [](easyar_BufferDictionary * ptr) { easyar_BufferDictionary__dtor(ptr); })));
}
inline void ObjectTargetParameters::setBufferDictionary(std::shared_ptr<BufferDictionary> arg0)
{
    easyar_ObjectTargetParameters_setBufferDictionary(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
}
inline std::string ObjectTargetParameters::objPath()
{
    easyar_String * _return_value_;
    easyar_ObjectTargetParameters_objPath(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline void ObjectTargetParameters::setObjPath(std::string arg0)
{
    easyar_ObjectTargetParameters_setObjPath(cdata_.get(), std_string_to_easyar_String(arg0).get());
}
inline std::string ObjectTargetParameters::name()
{
    easyar_String * _return_value_;
    easyar_ObjectTargetParameters_name(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline void ObjectTargetParameters::setName(std::string arg0)
{
    easyar_ObjectTargetParameters_setName(cdata_.get(), std_string_to_easyar_String(arg0).get());
}
inline std::string ObjectTargetParameters::uid()
{
    easyar_String * _return_value_;
    easyar_ObjectTargetParameters_uid(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline void ObjectTargetParameters::setUid(std::string arg0)
{
    easyar_ObjectTargetParameters_setUid(cdata_.get(), std_string_to_easyar_String(arg0).get());
}
inline std::string ObjectTargetParameters::meta()
{
    easyar_String * _return_value_;
    easyar_ObjectTargetParameters_meta(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline void ObjectTargetParameters::setMeta(std::string arg0)
{
    easyar_ObjectTargetParameters_setMeta(cdata_.get(), std_string_to_easyar_String(arg0).get());
}
inline float ObjectTargetParameters::scale()
{
    auto _return_value_ = easyar_ObjectTargetParameters_scale(cdata_.get());
    return _return_value_;
}
inline void ObjectTargetParameters::setScale(float arg0)
{
    easyar_ObjectTargetParameters_setScale(cdata_.get(), arg0);
}

inline ObjectTarget::ObjectTarget(std::shared_ptr<easyar_ObjectTarget> cdata)
    :
    Target(std::shared_ptr<easyar_Target>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline ObjectTarget::~ObjectTarget()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_ObjectTarget> ObjectTarget::get_cdata()
{
    return cdata_;
}
inline void ObjectTarget::init_cdata(std::shared_ptr<easyar_ObjectTarget> cdata)
{
    cdata_ = cdata;
    {
        easyar_Target * ptr = nullptr;
        easyar_castObjectTargetToTarget(cdata_.get(), &ptr);
        Target::init_cdata(std::shared_ptr<easyar_Target>(ptr, [](easyar_Target * ptr) { easyar_Target__dtor(ptr); }));
    }
}
inline ObjectTarget::ObjectTarget()
    :
    Target(std::shared_ptr<easyar_Target>(nullptr)),
    cdata_(nullptr)
{
    easyar_ObjectTarget * _return_value_;
    easyar_ObjectTarget__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_ObjectTarget>(_return_value_, [](easyar_ObjectTarget * ptr) { easyar_ObjectTarget__dtor(ptr); }));
}
inline std::shared_ptr<ObjectTarget> ObjectTarget::createFromParameters(std::shared_ptr<ObjectTargetParameters> arg0)
{
    easyar_ObjectTarget * _return_value_;
    easyar_ObjectTarget_createFromParameters((arg0 == nullptr ? nullptr : arg0->get_cdata().get()), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<ObjectTarget>(std::shared_ptr<easyar_ObjectTarget>(_return_value_, [](easyar_ObjectTarget * ptr) { easyar_ObjectTarget__dtor(ptr); })));
}
inline bool ObjectTarget::setup(std::string arg0, int arg1, std::string arg2)
{
    auto _return_value_ = easyar_ObjectTarget_setup(cdata_.get(), std_string_to_easyar_String(arg0).get(), arg1, std_string_to_easyar_String(arg2).get());
    return _return_value_;
}
inline std::vector<std::shared_ptr<ObjectTarget>> ObjectTarget::setupAll(std::string arg0, int arg1)
{
    easyar_ListOfPointerOfObjectTarget * _return_value_;
    easyar_ObjectTarget_setupAll(std_string_to_easyar_String(arg0).get(), arg1, &_return_value_);
    return std_vector_from_easyar_ListOfPointerOfObjectTarget(std::shared_ptr<easyar_ListOfPointerOfObjectTarget>(_return_value_, [](easyar_ListOfPointerOfObjectTarget * ptr) { easyar_ListOfPointerOfObjectTarget__dtor(ptr); }));
}
inline float ObjectTarget::scale()
{
    auto _return_value_ = easyar_ObjectTarget_scale(cdata_.get());
    return _return_value_;
}
inline std::vector<Vec3F> ObjectTarget::boundingBox()
{
    easyar_ListOfVec3F * _return_value_;
    easyar_ObjectTarget_boundingBox(cdata_.get(), &_return_value_);
    return std_vector_from_easyar_ListOfVec3F(std::shared_ptr<easyar_ListOfVec3F>(_return_value_, [](easyar_ListOfVec3F * ptr) { easyar_ListOfVec3F__dtor(ptr); }));
}
inline bool ObjectTarget::setScale(float arg0)
{
    auto _return_value_ = easyar_ObjectTarget_setScale(cdata_.get(), arg0);
    return _return_value_;
}
inline int ObjectTarget::runtimeID()
{
    auto _return_value_ = easyar_ObjectTarget_runtimeID(cdata_.get());
    return _return_value_;
}
inline std::string ObjectTarget::uid()
{
    easyar_String * _return_value_;
    easyar_ObjectTarget_uid(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string ObjectTarget::name()
{
    easyar_String * _return_value_;
    easyar_ObjectTarget_name(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string ObjectTarget::meta()
{
    easyar_String * _return_value_;
    easyar_ObjectTarget_meta(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline void ObjectTarget::setMeta(std::string arg0)
{
    easyar_ObjectTarget_setMeta(cdata_.get(), std_string_to_easyar_String(arg0).get());
}
inline std::shared_ptr<ObjectTarget> ObjectTarget::tryCastFromTarget(std::shared_ptr<Target> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_ObjectTarget * cdata;
    easyar_tryCastTargetToObjectTarget(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<ObjectTarget>(std::shared_ptr<easyar_ObjectTarget>(cdata, [](easyar_ObjectTarget * ptr) { easyar_ObjectTarget__dtor(ptr); }));
}

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFOBJECTTARGET__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFOBJECTTARGET__
static inline std::shared_ptr<easyar_ListOfPointerOfObjectTarget> std_vector_to_easyar_ListOfPointerOfObjectTarget(std::vector<std::shared_ptr<ObjectTarget>> l)
{
    std::vector<easyar_ObjectTarget *> values;
    values.reserve(l.size());
    for (auto v : l) {
        auto cv = (v == nullptr ? nullptr : v->get_cdata().get());
        easyar_ObjectTarget__retain(cv, &cv);
        values.push_back(cv);
    }
    easyar_ListOfPointerOfObjectTarget * ptr;
    easyar_ListOfPointerOfObjectTarget__ctor(values.data(), values.data() + values.size(), &ptr);
    return std::shared_ptr<easyar_ListOfPointerOfObjectTarget>(ptr, [](easyar_ListOfPointerOfObjectTarget * ptr) { easyar_ListOfPointerOfObjectTarget__dtor(ptr); });
}
static inline std::vector<std::shared_ptr<ObjectTarget>> std_vector_from_easyar_ListOfPointerOfObjectTarget(std::shared_ptr<easyar_ListOfPointerOfObjectTarget> pl)
{
    auto size = easyar_ListOfPointerOfObjectTarget_size(pl.get());
    std::vector<std::shared_ptr<ObjectTarget>> values;
    values.reserve(size);
    for (int k = 0; k < size; k += 1) {
        auto v = easyar_ListOfPointerOfObjectTarget_at(pl.get(), k);
        easyar_ObjectTarget__retain(v, &v);
        values.push_back((v == nullptr ? nullptr : std::make_shared<ObjectTarget>(std::shared_ptr<easyar_ObjectTarget>(v, [](easyar_ObjectTarget * ptr) { easyar_ObjectTarget__dtor(ptr); }))));
    }
    return values;
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_LISTOFVEC_F__
#define __IMPLEMENTATION_EASYAR_LISTOFVEC_F__
static inline std::shared_ptr<easyar_ListOfVec3F> std_vector_to_easyar_ListOfVec3F(std::vector<Vec3F> l)
{
    std::vector<easyar_Vec3F> values;
    values.reserve(l.size());
    for (auto v : l) {
        auto cv = easyar_Vec3F{{v.data[0], v.data[1], v.data[2]}};
        values.push_back(cv);
    }
    easyar_ListOfVec3F * ptr;
    easyar_ListOfVec3F__ctor(values.data(), values.data() + values.size(), &ptr);
    return std::shared_ptr<easyar_ListOfVec3F>(ptr, [](easyar_ListOfVec3F * ptr) { easyar_ListOfVec3F__dtor(ptr); });
}
static inline std::vector<Vec3F> std_vector_from_easyar_ListOfVec3F(std::shared_ptr<easyar_ListOfVec3F> pl)
{
    auto size = easyar_ListOfVec3F_size(pl.get());
    std::vector<Vec3F> values;
    values.reserve(size);
    for (int k = 0; k < size; k += 1) {
        auto v = easyar_ListOfVec3F_at(pl.get(), k);
        values.push_back(Vec3F{{{v.data[0], v.data[1], v.data[2]}}});
    }
    return values;
}
#endif

}

#endif
