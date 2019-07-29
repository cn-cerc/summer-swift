//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_OBJECTTRACKER_HXX__
#define __EASYAR_OBJECTTRACKER_HXX__

#include "easyar/types.hxx"
#include "easyar/targettracker.hxx"

namespace easyar {

class ObjectTrackerResult : public TargetTrackerResult
{
protected:
    easyar_ObjectTrackerResult * cdata_ ;
    void init_cdata(easyar_ObjectTrackerResult * cdata);
    virtual ObjectTrackerResult & operator=(const ObjectTrackerResult & data) { return *this; } //deleted
public:
    ObjectTrackerResult(easyar_ObjectTrackerResult * cdata);
    virtual ~ObjectTrackerResult();

    ObjectTrackerResult(const ObjectTrackerResult & data);
    const easyar_ObjectTrackerResult * get_cdata() const;
    easyar_ObjectTrackerResult * get_cdata();

    void targetInstances(/* OUT */ ListOfPointerOfTargetInstance * * Return);
    static void tryCastFromTargetTrackerResult(TargetTrackerResult * v, /* OUT */ ObjectTrackerResult * * Return);
};

class ObjectTracker : public TargetTracker
{
protected:
    easyar_ObjectTracker * cdata_ ;
    void init_cdata(easyar_ObjectTracker * cdata);
    virtual ObjectTracker & operator=(const ObjectTracker & data) { return *this; } //deleted
public:
    ObjectTracker(easyar_ObjectTracker * cdata);
    virtual ~ObjectTracker();

    ObjectTracker(const ObjectTracker & data);
    const easyar_ObjectTracker * get_cdata() const;
    easyar_ObjectTracker * get_cdata();

    ObjectTracker();
    static bool isAvailable();
    void getResult(Frame * frame, /* OUT */ ObjectTrackerResult * * Return);
    void loadTarget(Target * target, CallbackScheduler * callbackScheduler, FunctorOfVoidFromPointerOfTargetAndBool callback);
    void unloadTarget(Target * target, CallbackScheduler * callbackScheduler, FunctorOfVoidFromPointerOfTargetAndBool callback);
    bool loadTargetBlocked(Target * target);
    bool unloadTargetBlocked(Target * target);
    void targets(/* OUT */ ListOfPointerOfTarget * * Return);
    bool setSimultaneousNum(int num);
    int simultaneousNum();
    bool attachStreamer(FrameStreamer * obj);
    bool start();
    bool stop();
    static void tryCastFromFrameFilter(FrameFilter * v, /* OUT */ ObjectTracker * * Return);
    static void tryCastFromTargetTracker(TargetTracker * v, /* OUT */ ObjectTracker * * Return);
};

#ifndef __EASYAR_LISTOFPOINTEROFTARGETINSTANCE__
#define __EASYAR_LISTOFPOINTEROFTARGETINSTANCE__
class ListOfPointerOfTargetInstance
{
private:
    easyar_ListOfPointerOfTargetInstance * cdata_;
    virtual ListOfPointerOfTargetInstance & operator=(const ListOfPointerOfTargetInstance & data) { return *this; } //deleted
public:
    ListOfPointerOfTargetInstance(easyar_ListOfPointerOfTargetInstance * cdata);
    virtual ~ListOfPointerOfTargetInstance();

    ListOfPointerOfTargetInstance(const ListOfPointerOfTargetInstance & data);
    const easyar_ListOfPointerOfTargetInstance * get_cdata() const;
    easyar_ListOfPointerOfTargetInstance * get_cdata();

    ListOfPointerOfTargetInstance(easyar_TargetInstance * * begin, easyar_TargetInstance * * end);
    int size() const;
    TargetInstance * at(int index) const;
};
#endif

#ifndef __EASYAR_FUNCTOROFVOIDFROMPOINTEROFTARGETANDBOOL__
#define __EASYAR_FUNCTOROFVOIDFROMPOINTEROFTARGETANDBOOL__
struct FunctorOfVoidFromPointerOfTargetAndBool
{
    void * _state;
    void (* func)(void * _state, Target *, bool);
    void (* destroy)(void * _state);
    FunctorOfVoidFromPointerOfTargetAndBool(void * _state, void (* func)(void * _state, Target *, bool), void (* destroy)(void * _state));
};

static void FunctorOfVoidFromPointerOfTargetAndBool_func(void * _state, easyar_Target *, bool);
static void FunctorOfVoidFromPointerOfTargetAndBool_destroy(void * _state);
static inline easyar_FunctorOfVoidFromPointerOfTargetAndBool FunctorOfVoidFromPointerOfTargetAndBool_to_c(FunctorOfVoidFromPointerOfTargetAndBool f);
#endif

#ifndef __EASYAR_LISTOFPOINTEROFTARGET__
#define __EASYAR_LISTOFPOINTEROFTARGET__
class ListOfPointerOfTarget
{
private:
    easyar_ListOfPointerOfTarget * cdata_;
    virtual ListOfPointerOfTarget & operator=(const ListOfPointerOfTarget & data) { return *this; } //deleted
public:
    ListOfPointerOfTarget(easyar_ListOfPointerOfTarget * cdata);
    virtual ~ListOfPointerOfTarget();

    ListOfPointerOfTarget(const ListOfPointerOfTarget & data);
    const easyar_ListOfPointerOfTarget * get_cdata() const;
    easyar_ListOfPointerOfTarget * get_cdata();

    ListOfPointerOfTarget(easyar_Target * * begin, easyar_Target * * end);
    int size() const;
    Target * at(int index) const;
};
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_OBJECTTRACKER_HXX__
#define __IMPLEMENTATION_EASYAR_OBJECTTRACKER_HXX__

#include "easyar/objecttracker.h"
#include "easyar/targettracker.hxx"
#include "easyar/target.hxx"
#include "easyar/frame.hxx"
#include "easyar/callbackscheduler.hxx"
#include "easyar/framestreamer.hxx"

namespace easyar {

inline ObjectTrackerResult::ObjectTrackerResult(easyar_ObjectTrackerResult * cdata)
    :
    TargetTrackerResult(static_cast<easyar_TargetTrackerResult *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline ObjectTrackerResult::~ObjectTrackerResult()
{
    if (cdata_) {
        easyar_ObjectTrackerResult__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ObjectTrackerResult::ObjectTrackerResult(const ObjectTrackerResult & data)
    :
    TargetTrackerResult(static_cast<easyar_TargetTrackerResult *>(NULL)),
    cdata_(NULL)
{
    easyar_ObjectTrackerResult * cdata = NULL;
    easyar_ObjectTrackerResult__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_ObjectTrackerResult * ObjectTrackerResult::get_cdata() const
{
    return cdata_;
}
inline easyar_ObjectTrackerResult * ObjectTrackerResult::get_cdata()
{
    return cdata_;
}
inline void ObjectTrackerResult::init_cdata(easyar_ObjectTrackerResult * cdata)
{
    cdata_ = cdata;
    {
        easyar_TargetTrackerResult * cdata_inner = NULL;
        easyar_castObjectTrackerResultToTargetTrackerResult(cdata, &cdata_inner);
        TargetTrackerResult::init_cdata(cdata_inner);
    }
}
inline void ObjectTrackerResult::targetInstances(/* OUT */ ListOfPointerOfTargetInstance * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ListOfPointerOfTargetInstance * _return_value_ = NULL;
    easyar_ObjectTrackerResult_targetInstances(cdata_, &_return_value_);
    *Return = new ListOfPointerOfTargetInstance(_return_value_);
}
inline void ObjectTrackerResult::tryCastFromTargetTrackerResult(TargetTrackerResult * v, /* OUT */ ObjectTrackerResult * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ObjectTrackerResult * cdata = NULL;
    easyar_tryCastTargetTrackerResultToObjectTrackerResult(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new ObjectTrackerResult(cdata);
}

inline ObjectTracker::ObjectTracker(easyar_ObjectTracker * cdata)
    :
    TargetTracker(static_cast<easyar_TargetTracker *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline ObjectTracker::~ObjectTracker()
{
    if (cdata_) {
        easyar_ObjectTracker__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ObjectTracker::ObjectTracker(const ObjectTracker & data)
    :
    TargetTracker(static_cast<easyar_TargetTracker *>(NULL)),
    cdata_(NULL)
{
    easyar_ObjectTracker * cdata = NULL;
    easyar_ObjectTracker__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_ObjectTracker * ObjectTracker::get_cdata() const
{
    return cdata_;
}
inline easyar_ObjectTracker * ObjectTracker::get_cdata()
{
    return cdata_;
}
inline void ObjectTracker::init_cdata(easyar_ObjectTracker * cdata)
{
    cdata_ = cdata;
    {
        easyar_TargetTracker * cdata_inner = NULL;
        easyar_castObjectTrackerToTargetTracker(cdata, &cdata_inner);
        TargetTracker::init_cdata(cdata_inner);
    }
}
inline ObjectTracker::ObjectTracker()
    :
    TargetTracker(static_cast<easyar_TargetTracker *>(NULL)),
    cdata_(NULL)
{
    easyar_ObjectTracker * _return_value_ = NULL;
    easyar_ObjectTracker__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline bool ObjectTracker::isAvailable()
{
    bool _return_value_ = easyar_ObjectTracker_isAvailable();
    return _return_value_;
}
inline void ObjectTracker::getResult(Frame * arg0, /* OUT */ ObjectTrackerResult * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ObjectTrackerResult * _return_value_ = NULL;
    easyar_ObjectTracker_getResult(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()), &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new ObjectTrackerResult(_return_value_));
}
inline void ObjectTracker::loadTarget(Target * arg0, CallbackScheduler * arg1, FunctorOfVoidFromPointerOfTargetAndBool arg2)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_ObjectTracker_loadTarget(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()), (arg1 == NULL ? NULL : arg1->get_cdata()), FunctorOfVoidFromPointerOfTargetAndBool_to_c(arg2));
}
inline void ObjectTracker::unloadTarget(Target * arg0, CallbackScheduler * arg1, FunctorOfVoidFromPointerOfTargetAndBool arg2)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_ObjectTracker_unloadTarget(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()), (arg1 == NULL ? NULL : arg1->get_cdata()), FunctorOfVoidFromPointerOfTargetAndBool_to_c(arg2));
}
inline bool ObjectTracker::loadTargetBlocked(Target * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ObjectTracker_loadTargetBlocked(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline bool ObjectTracker::unloadTargetBlocked(Target * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ObjectTracker_unloadTargetBlocked(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline void ObjectTracker::targets(/* OUT */ ListOfPointerOfTarget * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ListOfPointerOfTarget * _return_value_ = NULL;
    easyar_ObjectTracker_targets(cdata_, &_return_value_);
    *Return = new ListOfPointerOfTarget(_return_value_);
}
inline bool ObjectTracker::setSimultaneousNum(int arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ObjectTracker_setSimultaneousNum(cdata_, arg0);
    return _return_value_;
}
inline int ObjectTracker::simultaneousNum()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_ObjectTracker_simultaneousNum(cdata_);
    return _return_value_;
}
inline bool ObjectTracker::attachStreamer(FrameStreamer * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ObjectTracker_attachStreamer(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline bool ObjectTracker::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ObjectTracker_start(cdata_);
    return _return_value_;
}
inline bool ObjectTracker::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ObjectTracker_stop(cdata_);
    return _return_value_;
}
inline void ObjectTracker::tryCastFromFrameFilter(FrameFilter * v, /* OUT */ ObjectTracker * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ObjectTracker * cdata = NULL;
    easyar_tryCastFrameFilterToObjectTracker(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new ObjectTracker(cdata);
}
inline void ObjectTracker::tryCastFromTargetTracker(TargetTracker * v, /* OUT */ ObjectTracker * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ObjectTracker * cdata = NULL;
    easyar_tryCastTargetTrackerToObjectTracker(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new ObjectTracker(cdata);
}

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFTARGETINSTANCE__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFTARGETINSTANCE__
inline ListOfPointerOfTargetInstance::ListOfPointerOfTargetInstance(easyar_ListOfPointerOfTargetInstance * cdata)
    : cdata_(cdata)
{
}
inline ListOfPointerOfTargetInstance::~ListOfPointerOfTargetInstance()
{
    if (cdata_) {
        easyar_ListOfPointerOfTargetInstance__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ListOfPointerOfTargetInstance::ListOfPointerOfTargetInstance(const ListOfPointerOfTargetInstance & data)
    : cdata_(static_cast<easyar_ListOfPointerOfTargetInstance *>(NULL))
{
    easyar_ListOfPointerOfTargetInstance_copy(data.cdata_, &cdata_);
}
inline const easyar_ListOfPointerOfTargetInstance * ListOfPointerOfTargetInstance::get_cdata() const
{
    return cdata_;
}
inline easyar_ListOfPointerOfTargetInstance * ListOfPointerOfTargetInstance::get_cdata()
{
    return cdata_;
}

inline ListOfPointerOfTargetInstance::ListOfPointerOfTargetInstance(easyar_TargetInstance * * begin, easyar_TargetInstance * * end)
    : cdata_(static_cast<easyar_ListOfPointerOfTargetInstance *>(NULL))
{
    easyar_ListOfPointerOfTargetInstance__ctor(begin, end, &cdata_);
}
inline int ListOfPointerOfTargetInstance::size() const
{
    return easyar_ListOfPointerOfTargetInstance_size(cdata_);
}
inline TargetInstance * ListOfPointerOfTargetInstance::at(int index) const
{
    easyar_TargetInstance * _return_value_ = easyar_ListOfPointerOfTargetInstance_at(cdata_, index);
    easyar_TargetInstance__retain(_return_value_, &_return_value_);
    return (_return_value_ == NULL ? NULL : new TargetInstance(_return_value_));
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPOINTEROFTARGETANDBOOL__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPOINTEROFTARGETANDBOOL__
inline FunctorOfVoidFromPointerOfTargetAndBool::FunctorOfVoidFromPointerOfTargetAndBool(void * _state, void (* func)(void * _state, Target *, bool), void (* destroy)(void * _state))
{
    this->_state = _state;
    this->func = func;
    this->destroy = destroy;
}
static void FunctorOfVoidFromPointerOfTargetAndBool_func(void * _state, easyar_Target * arg0, bool arg1)
{
    easyar_Target__retain(arg0, &arg0);
    Target * cpparg0 = (arg0 == NULL ? NULL : new Target(arg0));
    bool cpparg1 = arg1;
    FunctorOfVoidFromPointerOfTargetAndBool * f = reinterpret_cast<FunctorOfVoidFromPointerOfTargetAndBool *>(_state);
    f->func(f->_state, cpparg0, cpparg1);
    delete cpparg0;
}
static void FunctorOfVoidFromPointerOfTargetAndBool_destroy(void * _state)
{
    FunctorOfVoidFromPointerOfTargetAndBool * f = reinterpret_cast<FunctorOfVoidFromPointerOfTargetAndBool *>(_state);
    if (f->destroy) {
        f->destroy(f->_state);
    }
    delete f;
}
static inline easyar_FunctorOfVoidFromPointerOfTargetAndBool FunctorOfVoidFromPointerOfTargetAndBool_to_c(FunctorOfVoidFromPointerOfTargetAndBool f)
{
    easyar_FunctorOfVoidFromPointerOfTargetAndBool _return_value_ = {NULL, NULL, NULL};
    if ((f.func == NULL) && (f.destroy == NULL)) { return _return_value_; }
    _return_value_._state = new FunctorOfVoidFromPointerOfTargetAndBool(f._state, f.func, f.destroy);
    _return_value_.func = FunctorOfVoidFromPointerOfTargetAndBool_func;
    _return_value_.destroy = FunctorOfVoidFromPointerOfTargetAndBool_destroy;
    return _return_value_;
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFTARGET__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFTARGET__
inline ListOfPointerOfTarget::ListOfPointerOfTarget(easyar_ListOfPointerOfTarget * cdata)
    : cdata_(cdata)
{
}
inline ListOfPointerOfTarget::~ListOfPointerOfTarget()
{
    if (cdata_) {
        easyar_ListOfPointerOfTarget__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ListOfPointerOfTarget::ListOfPointerOfTarget(const ListOfPointerOfTarget & data)
    : cdata_(static_cast<easyar_ListOfPointerOfTarget *>(NULL))
{
    easyar_ListOfPointerOfTarget_copy(data.cdata_, &cdata_);
}
inline const easyar_ListOfPointerOfTarget * ListOfPointerOfTarget::get_cdata() const
{
    return cdata_;
}
inline easyar_ListOfPointerOfTarget * ListOfPointerOfTarget::get_cdata()
{
    return cdata_;
}

inline ListOfPointerOfTarget::ListOfPointerOfTarget(easyar_Target * * begin, easyar_Target * * end)
    : cdata_(static_cast<easyar_ListOfPointerOfTarget *>(NULL))
{
    easyar_ListOfPointerOfTarget__ctor(begin, end, &cdata_);
}
inline int ListOfPointerOfTarget::size() const
{
    return easyar_ListOfPointerOfTarget_size(cdata_);
}
inline Target * ListOfPointerOfTarget::at(int index) const
{
    easyar_Target * _return_value_ = easyar_ListOfPointerOfTarget_at(cdata_, index);
    easyar_Target__retain(_return_value_, &_return_value_);
    return (_return_value_ == NULL ? NULL : new Target(_return_value_));
}
#endif

}

#endif
