﻿//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_TARGETTRACKER_HXX__
#define __EASYAR_TARGETTRACKER_HXX__

#include "easyar/types.hxx"
#include "easyar/framefilter.hxx"

namespace easyar {

class TargetTrackerResult
{
protected:
    easyar_TargetTrackerResult * cdata_ ;
    void init_cdata(easyar_TargetTrackerResult * cdata);
    virtual TargetTrackerResult & operator=(const TargetTrackerResult & data) { return *this; } //deleted
public:
    TargetTrackerResult(easyar_TargetTrackerResult * cdata);
    virtual ~TargetTrackerResult();

    TargetTrackerResult(const TargetTrackerResult & data);
    const easyar_TargetTrackerResult * get_cdata() const;
    easyar_TargetTrackerResult * get_cdata();

    void targetInstances(/* OUT */ ListOfPointerOfTargetInstance * * Return);
};

class TargetTracker : public FrameFilter
{
protected:
    easyar_TargetTracker * cdata_ ;
    void init_cdata(easyar_TargetTracker * cdata);
    virtual TargetTracker & operator=(const TargetTracker & data) { return *this; } //deleted
public:
    TargetTracker(easyar_TargetTracker * cdata);
    virtual ~TargetTracker();

    TargetTracker(const TargetTracker & data);
    const easyar_TargetTracker * get_cdata() const;
    easyar_TargetTracker * get_cdata();

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
    static void tryCastFromFrameFilter(FrameFilter * v, /* OUT */ TargetTracker * * Return);
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

#ifndef __IMPLEMENTATION_EASYAR_TARGETTRACKER_HXX__
#define __IMPLEMENTATION_EASYAR_TARGETTRACKER_HXX__

#include "easyar/targettracker.h"
#include "easyar/target.hxx"
#include "easyar/framefilter.hxx"
#include "easyar/callbackscheduler.hxx"
#include "easyar/framestreamer.hxx"

namespace easyar {

inline TargetTrackerResult::TargetTrackerResult(easyar_TargetTrackerResult * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline TargetTrackerResult::~TargetTrackerResult()
{
    if (cdata_) {
        easyar_TargetTrackerResult__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline TargetTrackerResult::TargetTrackerResult(const TargetTrackerResult & data)
    :
    cdata_(NULL)
{
    easyar_TargetTrackerResult * cdata = NULL;
    easyar_TargetTrackerResult__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_TargetTrackerResult * TargetTrackerResult::get_cdata() const
{
    return cdata_;
}
inline easyar_TargetTrackerResult * TargetTrackerResult::get_cdata()
{
    return cdata_;
}
inline void TargetTrackerResult::init_cdata(easyar_TargetTrackerResult * cdata)
{
    cdata_ = cdata;
}
inline void TargetTrackerResult::targetInstances(/* OUT */ ListOfPointerOfTargetInstance * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ListOfPointerOfTargetInstance * _return_value_ = NULL;
    easyar_TargetTrackerResult_targetInstances(cdata_, &_return_value_);
    *Return = new ListOfPointerOfTargetInstance(_return_value_);
}

inline TargetTracker::TargetTracker(easyar_TargetTracker * cdata)
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline TargetTracker::~TargetTracker()
{
    if (cdata_) {
        easyar_TargetTracker__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline TargetTracker::TargetTracker(const TargetTracker & data)
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    easyar_TargetTracker * cdata = NULL;
    easyar_TargetTracker__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_TargetTracker * TargetTracker::get_cdata() const
{
    return cdata_;
}
inline easyar_TargetTracker * TargetTracker::get_cdata()
{
    return cdata_;
}
inline void TargetTracker::init_cdata(easyar_TargetTracker * cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameFilter * cdata_inner = NULL;
        easyar_castTargetTrackerToFrameFilter(cdata, &cdata_inner);
        FrameFilter::init_cdata(cdata_inner);
    }
}
inline void TargetTracker::loadTarget(Target * arg0, CallbackScheduler * arg1, FunctorOfVoidFromPointerOfTargetAndBool arg2)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_TargetTracker_loadTarget(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()), (arg1 == NULL ? NULL : arg1->get_cdata()), FunctorOfVoidFromPointerOfTargetAndBool_to_c(arg2));
}
inline void TargetTracker::unloadTarget(Target * arg0, CallbackScheduler * arg1, FunctorOfVoidFromPointerOfTargetAndBool arg2)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_TargetTracker_unloadTarget(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()), (arg1 == NULL ? NULL : arg1->get_cdata()), FunctorOfVoidFromPointerOfTargetAndBool_to_c(arg2));
}
inline bool TargetTracker::loadTargetBlocked(Target * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_TargetTracker_loadTargetBlocked(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline bool TargetTracker::unloadTargetBlocked(Target * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_TargetTracker_unloadTargetBlocked(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline void TargetTracker::targets(/* OUT */ ListOfPointerOfTarget * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ListOfPointerOfTarget * _return_value_ = NULL;
    easyar_TargetTracker_targets(cdata_, &_return_value_);
    *Return = new ListOfPointerOfTarget(_return_value_);
}
inline bool TargetTracker::setSimultaneousNum(int arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_TargetTracker_setSimultaneousNum(cdata_, arg0);
    return _return_value_;
}
inline int TargetTracker::simultaneousNum()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_TargetTracker_simultaneousNum(cdata_);
    return _return_value_;
}
inline bool TargetTracker::attachStreamer(FrameStreamer * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_TargetTracker_attachStreamer(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline bool TargetTracker::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_TargetTracker_start(cdata_);
    return _return_value_;
}
inline bool TargetTracker::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_TargetTracker_stop(cdata_);
    return _return_value_;
}
inline void TargetTracker::tryCastFromFrameFilter(FrameFilter * v, /* OUT */ TargetTracker * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_TargetTracker * cdata = NULL;
    easyar_tryCastFrameFilterToTargetTracker(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new TargetTracker(cdata);
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
