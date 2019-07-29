//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_CAMERA_HXX__
#define __EASYAR_CAMERA_HXX__

#include "easyar/types.hxx"

namespace easyar {

class CameraParameters
{
protected:
    easyar_CameraParameters * cdata_ ;
    void init_cdata(easyar_CameraParameters * cdata);
    virtual CameraParameters & operator=(const CameraParameters & data) { return *this; } //deleted
public:
    CameraParameters(easyar_CameraParameters * cdata);
    virtual ~CameraParameters();

    CameraParameters(const CameraParameters & data);
    const easyar_CameraParameters * get_cdata() const;
    easyar_CameraParameters * get_cdata();

    CameraParameters();
    Vec2I size();
    Vec2F focalLength();
    Vec2F principalPoint();
    Vec4F distortionParameters();
    int cameraOrientation();
    CameraDeviceType getCameraType();
    void setCameraType(CameraDeviceType type);
    bool getHorizontalFlip();
    void setHorizontalFlip(bool flip);
    void setSize(Vec2I data);
    void setCalibration(Vec2I size, Vec2F focalLength, Vec2F principalPoint, float k1, float k2, float p1, float p2);
    void setCameraOrientation(int rotation);
    int imageOrientation(int screenRotation);
    bool imageHorizontalFlip();
    Matrix44F projection(float nearPlane, float farPlane, float viewportAspectRatio, int screenRotation, bool combiningFlip);
    Matrix44F imageProjection(float viewportAspectRatio, int screenRotation, bool combiningFlip);
    Vec2F screenCoordinatesFromImageCoordinates(float viewportAspectRatio, int screenRotation, bool combiningFlip, Vec2F imageCoordinates);
    Vec2F imageCoordinatesFromScreenCoordinates(float viewportAspectRatio, int screenRotation, bool combiningFlip, Vec2F screenCoordinates);
    bool equalsTo(CameraParameters * other);
};

class CameraDevice
{
protected:
    easyar_CameraDevice * cdata_ ;
    void init_cdata(easyar_CameraDevice * cdata);
    virtual CameraDevice & operator=(const CameraDevice & data) { return *this; } //deleted
public:
    CameraDevice(easyar_CameraDevice * cdata);
    virtual ~CameraDevice();

    CameraDevice(const CameraDevice & data);
    const easyar_CameraDevice * get_cdata() const;
    easyar_CameraDevice * get_cdata();

    CameraDevice();
    bool start();
    bool stop();
    void setAndroidCameraApiType(AndroidCameraApiType type);
    static void requestPermissions(CallbackScheduler * callbackScheduler, FunctorOfVoidFromPermissionStatusAndString permissionCallback);
    bool openWithIndex(int cameraIndex);
    bool openWithType(CameraDeviceType type);
    bool close();
    bool isOpened();
    Vec2I size();
    int supportedSizeCount();
    Vec2I supportedSize(int idx);
    bool setSize(Vec2I size);
    float zoomScale();
    bool setZoomScale(float scale);
    float minZoomScale();
    float maxZoomScale();
    int supportedFrameRateRangeCount();
    float supportedFrameRateRangeLower(int index);
    float supportedFrameRateRangeUpper(int index);
    int frameRateRange();
    bool setFrameRateRange(int index);
    bool setFlashTorchMode(bool on);
    bool setFocusMode(CameraDeviceFocusMode focusMode);
    bool autoFocus();
    bool setPresentProfile(CameraDevicePresetProfile profile);
    void setStateChangedCallback(CallbackScheduler * callbackScheduler, FunctorOfVoidFromCameraState stateChangedCallback);
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
#define __EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
struct FunctorOfVoidFromPermissionStatusAndString
{
    void * _state;
    void (* func)(void * _state, PermissionStatus, String *);
    void (* destroy)(void * _state);
    FunctorOfVoidFromPermissionStatusAndString(void * _state, void (* func)(void * _state, PermissionStatus, String *), void (* destroy)(void * _state));
};

static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus, easyar_String *);
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(FunctorOfVoidFromPermissionStatusAndString f);
#endif

#ifndef __EASYAR_FUNCTOROFVOIDFROMCAMERASTATE__
#define __EASYAR_FUNCTOROFVOIDFROMCAMERASTATE__
struct FunctorOfVoidFromCameraState
{
    void * _state;
    void (* func)(void * _state, CameraState);
    void (* destroy)(void * _state);
    FunctorOfVoidFromCameraState(void * _state, void (* func)(void * _state, CameraState), void (* destroy)(void * _state));
};

static void FunctorOfVoidFromCameraState_func(void * _state, easyar_CameraState);
static void FunctorOfVoidFromCameraState_destroy(void * _state);
static inline easyar_FunctorOfVoidFromCameraState FunctorOfVoidFromCameraState_to_c(FunctorOfVoidFromCameraState f);
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_CAMERA_HXX__
#define __IMPLEMENTATION_EASYAR_CAMERA_HXX__

#include "easyar/camera.h"
#include "easyar/vector.hxx"
#include "easyar/matrix.hxx"
#include "easyar/callbackscheduler.hxx"

namespace easyar {

inline CameraParameters::CameraParameters(easyar_CameraParameters * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline CameraParameters::~CameraParameters()
{
    if (cdata_) {
        easyar_CameraParameters__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline CameraParameters::CameraParameters(const CameraParameters & data)
    :
    cdata_(NULL)
{
    easyar_CameraParameters * cdata = NULL;
    easyar_CameraParameters__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_CameraParameters * CameraParameters::get_cdata() const
{
    return cdata_;
}
inline easyar_CameraParameters * CameraParameters::get_cdata()
{
    return cdata_;
}
inline void CameraParameters::init_cdata(easyar_CameraParameters * cdata)
{
    cdata_ = cdata;
}
inline CameraParameters::CameraParameters()
    :
    cdata_(NULL)
{
    easyar_CameraParameters * _return_value_ = NULL;
    easyar_CameraParameters__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline Vec2I CameraParameters::size()
{
    if (cdata_ == NULL) {
        return Vec2I();
    }
    easyar_Vec2I _return_value_ = easyar_CameraParameters_size(cdata_);
    return Vec2I(_return_value_.data[0], _return_value_.data[1]);
}
inline Vec2F CameraParameters::focalLength()
{
    if (cdata_ == NULL) {
        return Vec2F();
    }
    easyar_Vec2F _return_value_ = easyar_CameraParameters_focalLength(cdata_);
    return Vec2F(_return_value_.data[0], _return_value_.data[1]);
}
inline Vec2F CameraParameters::principalPoint()
{
    if (cdata_ == NULL) {
        return Vec2F();
    }
    easyar_Vec2F _return_value_ = easyar_CameraParameters_principalPoint(cdata_);
    return Vec2F(_return_value_.data[0], _return_value_.data[1]);
}
inline Vec4F CameraParameters::distortionParameters()
{
    if (cdata_ == NULL) {
        return Vec4F();
    }
    easyar_Vec4F _return_value_ = easyar_CameraParameters_distortionParameters(cdata_);
    return Vec4F(_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3]);
}
inline int CameraParameters::cameraOrientation()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_CameraParameters_cameraOrientation(cdata_);
    return _return_value_;
}
inline CameraDeviceType CameraParameters::getCameraType()
{
    if (cdata_ == NULL) {
        return CameraDeviceType();
    }
    easyar_CameraDeviceType _return_value_ = easyar_CameraParameters_getCameraType(cdata_);
    return static_cast<CameraDeviceType>(_return_value_);
}
inline void CameraParameters::setCameraType(CameraDeviceType arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_CameraParameters_setCameraType(cdata_, static_cast<easyar_CameraDeviceType>(arg0));
}
inline bool CameraParameters::getHorizontalFlip()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraParameters_getHorizontalFlip(cdata_);
    return _return_value_;
}
inline void CameraParameters::setHorizontalFlip(bool arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_CameraParameters_setHorizontalFlip(cdata_, arg0);
}
inline void CameraParameters::setSize(Vec2I arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_CameraParameters_setSize(cdata_, arg0.get_cdata());
}
inline void CameraParameters::setCalibration(Vec2I arg0, Vec2F arg1, Vec2F arg2, float arg3, float arg4, float arg5, float arg6)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_CameraParameters_setCalibration(cdata_, arg0.get_cdata(), arg1.get_cdata(), arg2.get_cdata(), arg3, arg4, arg5, arg6);
}
inline void CameraParameters::setCameraOrientation(int arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_CameraParameters_setCameraOrientation(cdata_, arg0);
}
inline int CameraParameters::imageOrientation(int arg0)
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_CameraParameters_imageOrientation(cdata_, arg0);
    return _return_value_;
}
inline bool CameraParameters::imageHorizontalFlip()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraParameters_imageHorizontalFlip(cdata_);
    return _return_value_;
}
inline Matrix44F CameraParameters::projection(float arg0, float arg1, float arg2, int arg3, bool arg4)
{
    if (cdata_ == NULL) {
        return Matrix44F();
    }
    easyar_Matrix44F _return_value_ = easyar_CameraParameters_projection(cdata_, arg0, arg1, arg2, arg3, arg4);
    return Matrix44F(_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11], _return_value_.data[12], _return_value_.data[13], _return_value_.data[14], _return_value_.data[15]);
}
inline Matrix44F CameraParameters::imageProjection(float arg0, int arg1, bool arg2)
{
    if (cdata_ == NULL) {
        return Matrix44F();
    }
    easyar_Matrix44F _return_value_ = easyar_CameraParameters_imageProjection(cdata_, arg0, arg1, arg2);
    return Matrix44F(_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11], _return_value_.data[12], _return_value_.data[13], _return_value_.data[14], _return_value_.data[15]);
}
inline Vec2F CameraParameters::screenCoordinatesFromImageCoordinates(float arg0, int arg1, bool arg2, Vec2F arg3)
{
    if (cdata_ == NULL) {
        return Vec2F();
    }
    easyar_Vec2F _return_value_ = easyar_CameraParameters_screenCoordinatesFromImageCoordinates(cdata_, arg0, arg1, arg2, arg3.get_cdata());
    return Vec2F(_return_value_.data[0], _return_value_.data[1]);
}
inline Vec2F CameraParameters::imageCoordinatesFromScreenCoordinates(float arg0, int arg1, bool arg2, Vec2F arg3)
{
    if (cdata_ == NULL) {
        return Vec2F();
    }
    easyar_Vec2F _return_value_ = easyar_CameraParameters_imageCoordinatesFromScreenCoordinates(cdata_, arg0, arg1, arg2, arg3.get_cdata());
    return Vec2F(_return_value_.data[0], _return_value_.data[1]);
}
inline bool CameraParameters::equalsTo(CameraParameters * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraParameters_equalsTo(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}

inline CameraDevice::CameraDevice(easyar_CameraDevice * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline CameraDevice::~CameraDevice()
{
    if (cdata_) {
        easyar_CameraDevice__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline CameraDevice::CameraDevice(const CameraDevice & data)
    :
    cdata_(NULL)
{
    easyar_CameraDevice * cdata = NULL;
    easyar_CameraDevice__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_CameraDevice * CameraDevice::get_cdata() const
{
    return cdata_;
}
inline easyar_CameraDevice * CameraDevice::get_cdata()
{
    return cdata_;
}
inline void CameraDevice::init_cdata(easyar_CameraDevice * cdata)
{
    cdata_ = cdata;
}
inline CameraDevice::CameraDevice()
    :
    cdata_(NULL)
{
    easyar_CameraDevice * _return_value_ = NULL;
    easyar_CameraDevice__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline bool CameraDevice::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_start(cdata_);
    return _return_value_;
}
inline bool CameraDevice::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_stop(cdata_);
    return _return_value_;
}
inline void CameraDevice::setAndroidCameraApiType(AndroidCameraApiType arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_CameraDevice_setAndroidCameraApiType(cdata_, static_cast<easyar_AndroidCameraApiType>(arg0));
}
inline void CameraDevice::requestPermissions(CallbackScheduler * arg0, FunctorOfVoidFromPermissionStatusAndString arg1)
{
    easyar_CameraDevice_requestPermissions((arg0 == NULL ? NULL : arg0->get_cdata()), FunctorOfVoidFromPermissionStatusAndString_to_c(arg1));
}
inline bool CameraDevice::openWithIndex(int arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_openWithIndex(cdata_, arg0);
    return _return_value_;
}
inline bool CameraDevice::openWithType(CameraDeviceType arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_openWithType(cdata_, static_cast<easyar_CameraDeviceType>(arg0));
    return _return_value_;
}
inline bool CameraDevice::close()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_close(cdata_);
    return _return_value_;
}
inline bool CameraDevice::isOpened()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_isOpened(cdata_);
    return _return_value_;
}
inline Vec2I CameraDevice::size()
{
    if (cdata_ == NULL) {
        return Vec2I();
    }
    easyar_Vec2I _return_value_ = easyar_CameraDevice_size(cdata_);
    return Vec2I(_return_value_.data[0], _return_value_.data[1]);
}
inline int CameraDevice::supportedSizeCount()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_CameraDevice_supportedSizeCount(cdata_);
    return _return_value_;
}
inline Vec2I CameraDevice::supportedSize(int arg0)
{
    if (cdata_ == NULL) {
        return Vec2I();
    }
    easyar_Vec2I _return_value_ = easyar_CameraDevice_supportedSize(cdata_, arg0);
    return Vec2I(_return_value_.data[0], _return_value_.data[1]);
}
inline bool CameraDevice::setSize(Vec2I arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_setSize(cdata_, arg0.get_cdata());
    return _return_value_;
}
inline float CameraDevice::zoomScale()
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_CameraDevice_zoomScale(cdata_);
    return _return_value_;
}
inline bool CameraDevice::setZoomScale(float arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_setZoomScale(cdata_, arg0);
    return _return_value_;
}
inline float CameraDevice::minZoomScale()
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_CameraDevice_minZoomScale(cdata_);
    return _return_value_;
}
inline float CameraDevice::maxZoomScale()
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_CameraDevice_maxZoomScale(cdata_);
    return _return_value_;
}
inline int CameraDevice::supportedFrameRateRangeCount()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_CameraDevice_supportedFrameRateRangeCount(cdata_);
    return _return_value_;
}
inline float CameraDevice::supportedFrameRateRangeLower(int arg0)
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_CameraDevice_supportedFrameRateRangeLower(cdata_, arg0);
    return _return_value_;
}
inline float CameraDevice::supportedFrameRateRangeUpper(int arg0)
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_CameraDevice_supportedFrameRateRangeUpper(cdata_, arg0);
    return _return_value_;
}
inline int CameraDevice::frameRateRange()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_CameraDevice_frameRateRange(cdata_);
    return _return_value_;
}
inline bool CameraDevice::setFrameRateRange(int arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_setFrameRateRange(cdata_, arg0);
    return _return_value_;
}
inline bool CameraDevice::setFlashTorchMode(bool arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_setFlashTorchMode(cdata_, arg0);
    return _return_value_;
}
inline bool CameraDevice::setFocusMode(CameraDeviceFocusMode arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_setFocusMode(cdata_, static_cast<easyar_CameraDeviceFocusMode>(arg0));
    return _return_value_;
}
inline bool CameraDevice::autoFocus()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_autoFocus(cdata_);
    return _return_value_;
}
inline bool CameraDevice::setPresentProfile(CameraDevicePresetProfile arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_setPresentProfile(cdata_, static_cast<easyar_CameraDevicePresetProfile>(arg0));
    return _return_value_;
}
inline void CameraDevice::setStateChangedCallback(CallbackScheduler * arg0, FunctorOfVoidFromCameraState arg1)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_CameraDevice_setStateChangedCallback(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()), FunctorOfVoidFromCameraState_to_c(arg1));
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
inline FunctorOfVoidFromPermissionStatusAndString::FunctorOfVoidFromPermissionStatusAndString(void * _state, void (* func)(void * _state, PermissionStatus, String *), void (* destroy)(void * _state))
{
    this->_state = _state;
    this->func = func;
    this->destroy = destroy;
}
static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus arg0, easyar_String * arg1)
{
    PermissionStatus cpparg0 = static_cast<PermissionStatus>(arg0);
    easyar_String_copy(arg1, &arg1);
    String * cpparg1 = (arg1) == NULL ? NULL : new String(arg1);
    FunctorOfVoidFromPermissionStatusAndString * f = reinterpret_cast<FunctorOfVoidFromPermissionStatusAndString *>(_state);
    f->func(f->_state, cpparg0, cpparg1);
    delete cpparg1;
}
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state)
{
    FunctorOfVoidFromPermissionStatusAndString * f = reinterpret_cast<FunctorOfVoidFromPermissionStatusAndString *>(_state);
    if (f->destroy) {
        f->destroy(f->_state);
    }
    delete f;
}
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(FunctorOfVoidFromPermissionStatusAndString f)
{
    easyar_FunctorOfVoidFromPermissionStatusAndString _return_value_ = {NULL, NULL, NULL};
    if ((f.func == NULL) && (f.destroy == NULL)) { return _return_value_; }
    _return_value_._state = new FunctorOfVoidFromPermissionStatusAndString(f._state, f.func, f.destroy);
    _return_value_.func = FunctorOfVoidFromPermissionStatusAndString_func;
    _return_value_.destroy = FunctorOfVoidFromPermissionStatusAndString_destroy;
    return _return_value_;
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMCAMERASTATE__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMCAMERASTATE__
inline FunctorOfVoidFromCameraState::FunctorOfVoidFromCameraState(void * _state, void (* func)(void * _state, CameraState), void (* destroy)(void * _state))
{
    this->_state = _state;
    this->func = func;
    this->destroy = destroy;
}
static void FunctorOfVoidFromCameraState_func(void * _state, easyar_CameraState arg0)
{
    CameraState cpparg0 = static_cast<CameraState>(arg0);
    FunctorOfVoidFromCameraState * f = reinterpret_cast<FunctorOfVoidFromCameraState *>(_state);
    f->func(f->_state, cpparg0);
}
static void FunctorOfVoidFromCameraState_destroy(void * _state)
{
    FunctorOfVoidFromCameraState * f = reinterpret_cast<FunctorOfVoidFromCameraState *>(_state);
    if (f->destroy) {
        f->destroy(f->_state);
    }
    delete f;
}
static inline easyar_FunctorOfVoidFromCameraState FunctorOfVoidFromCameraState_to_c(FunctorOfVoidFromCameraState f)
{
    easyar_FunctorOfVoidFromCameraState _return_value_ = {NULL, NULL, NULL};
    if ((f.func == NULL) && (f.destroy == NULL)) { return _return_value_; }
    _return_value_._state = new FunctorOfVoidFromCameraState(f._state, f.func, f.destroy);
    _return_value_.func = FunctorOfVoidFromCameraState_func;
    _return_value_.destroy = FunctorOfVoidFromCameraState_destroy;
    return _return_value_;
}
#endif

}

#endif
