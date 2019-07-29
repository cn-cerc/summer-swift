//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_CAMERA_HPP__
#define __EASYAR_CAMERA_HPP__

#include "easyar/types.hpp"

namespace easyar {

class CameraParameters
{
protected:
    std::shared_ptr<easyar_CameraParameters> cdata_;
    void init_cdata(std::shared_ptr<easyar_CameraParameters> cdata);
    CameraParameters & operator=(const CameraParameters & data) = delete;
public:
    CameraParameters(std::shared_ptr<easyar_CameraParameters> cdata);
    virtual ~CameraParameters();

    std::shared_ptr<easyar_CameraParameters> get_cdata();

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
    bool equalsTo(std::shared_ptr<CameraParameters> other);
};

class CameraDevice
{
protected:
    std::shared_ptr<easyar_CameraDevice> cdata_;
    void init_cdata(std::shared_ptr<easyar_CameraDevice> cdata);
    CameraDevice & operator=(const CameraDevice & data) = delete;
public:
    CameraDevice(std::shared_ptr<easyar_CameraDevice> cdata);
    virtual ~CameraDevice();

    std::shared_ptr<easyar_CameraDevice> get_cdata();

    CameraDevice();
    bool start();
    bool stop();
    void setAndroidCameraApiType(AndroidCameraApiType type);
    static void requestPermissions(std::shared_ptr<CallbackScheduler> callbackScheduler, std::function<void(PermissionStatus, std::string)> permissionCallback);
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
    void setStateChangedCallback(std::shared_ptr<CallbackScheduler> callbackScheduler, std::function<void(CameraState)> stateChangedCallback);
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
#define __EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus, easyar_String *);
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(std::function<void(PermissionStatus, std::string)> f);
#endif

#ifndef __EASYAR_FUNCTOROFVOIDFROMCAMERASTATE__
#define __EASYAR_FUNCTOROFVOIDFROMCAMERASTATE__
static void FunctorOfVoidFromCameraState_func(void * _state, easyar_CameraState);
static void FunctorOfVoidFromCameraState_destroy(void * _state);
static inline easyar_FunctorOfVoidFromCameraState FunctorOfVoidFromCameraState_to_c(std::function<void(CameraState)> f);
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_CAMERA_HPP__
#define __IMPLEMENTATION_EASYAR_CAMERA_HPP__

#include "easyar/camera.h"
#include "easyar/vector.hpp"
#include "easyar/matrix.hpp"
#include "easyar/callbackscheduler.hpp"

namespace easyar {

inline CameraParameters::CameraParameters(std::shared_ptr<easyar_CameraParameters> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline CameraParameters::~CameraParameters()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_CameraParameters> CameraParameters::get_cdata()
{
    return cdata_;
}
inline void CameraParameters::init_cdata(std::shared_ptr<easyar_CameraParameters> cdata)
{
    cdata_ = cdata;
}
inline CameraParameters::CameraParameters()
    :
    cdata_(nullptr)
{
    easyar_CameraParameters * _return_value_;
    easyar_CameraParameters__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_CameraParameters>(_return_value_, [](easyar_CameraParameters * ptr) { easyar_CameraParameters__dtor(ptr); }));
}
inline Vec2I CameraParameters::size()
{
    auto _return_value_ = easyar_CameraParameters_size(cdata_.get());
    return Vec2I{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline Vec2F CameraParameters::focalLength()
{
    auto _return_value_ = easyar_CameraParameters_focalLength(cdata_.get());
    return Vec2F{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline Vec2F CameraParameters::principalPoint()
{
    auto _return_value_ = easyar_CameraParameters_principalPoint(cdata_.get());
    return Vec2F{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline Vec4F CameraParameters::distortionParameters()
{
    auto _return_value_ = easyar_CameraParameters_distortionParameters(cdata_.get());
    return Vec4F{{{_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3]}}};
}
inline int CameraParameters::cameraOrientation()
{
    auto _return_value_ = easyar_CameraParameters_cameraOrientation(cdata_.get());
    return _return_value_;
}
inline CameraDeviceType CameraParameters::getCameraType()
{
    auto _return_value_ = easyar_CameraParameters_getCameraType(cdata_.get());
    return static_cast<CameraDeviceType>(_return_value_);
}
inline void CameraParameters::setCameraType(CameraDeviceType arg0)
{
    easyar_CameraParameters_setCameraType(cdata_.get(), static_cast<easyar_CameraDeviceType>(arg0));
}
inline bool CameraParameters::getHorizontalFlip()
{
    auto _return_value_ = easyar_CameraParameters_getHorizontalFlip(cdata_.get());
    return _return_value_;
}
inline void CameraParameters::setHorizontalFlip(bool arg0)
{
    easyar_CameraParameters_setHorizontalFlip(cdata_.get(), arg0);
}
inline void CameraParameters::setSize(Vec2I arg0)
{
    easyar_CameraParameters_setSize(cdata_.get(), easyar_Vec2I{{arg0.data[0], arg0.data[1]}});
}
inline void CameraParameters::setCalibration(Vec2I arg0, Vec2F arg1, Vec2F arg2, float arg3, float arg4, float arg5, float arg6)
{
    easyar_CameraParameters_setCalibration(cdata_.get(), easyar_Vec2I{{arg0.data[0], arg0.data[1]}}, easyar_Vec2F{{arg1.data[0], arg1.data[1]}}, easyar_Vec2F{{arg2.data[0], arg2.data[1]}}, arg3, arg4, arg5, arg6);
}
inline void CameraParameters::setCameraOrientation(int arg0)
{
    easyar_CameraParameters_setCameraOrientation(cdata_.get(), arg0);
}
inline int CameraParameters::imageOrientation(int arg0)
{
    auto _return_value_ = easyar_CameraParameters_imageOrientation(cdata_.get(), arg0);
    return _return_value_;
}
inline bool CameraParameters::imageHorizontalFlip()
{
    auto _return_value_ = easyar_CameraParameters_imageHorizontalFlip(cdata_.get());
    return _return_value_;
}
inline Matrix44F CameraParameters::projection(float arg0, float arg1, float arg2, int arg3, bool arg4)
{
    auto _return_value_ = easyar_CameraParameters_projection(cdata_.get(), arg0, arg1, arg2, arg3, arg4);
    return Matrix44F{{{_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11], _return_value_.data[12], _return_value_.data[13], _return_value_.data[14], _return_value_.data[15]}}};
}
inline Matrix44F CameraParameters::imageProjection(float arg0, int arg1, bool arg2)
{
    auto _return_value_ = easyar_CameraParameters_imageProjection(cdata_.get(), arg0, arg1, arg2);
    return Matrix44F{{{_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11], _return_value_.data[12], _return_value_.data[13], _return_value_.data[14], _return_value_.data[15]}}};
}
inline Vec2F CameraParameters::screenCoordinatesFromImageCoordinates(float arg0, int arg1, bool arg2, Vec2F arg3)
{
    auto _return_value_ = easyar_CameraParameters_screenCoordinatesFromImageCoordinates(cdata_.get(), arg0, arg1, arg2, easyar_Vec2F{{arg3.data[0], arg3.data[1]}});
    return Vec2F{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline Vec2F CameraParameters::imageCoordinatesFromScreenCoordinates(float arg0, int arg1, bool arg2, Vec2F arg3)
{
    auto _return_value_ = easyar_CameraParameters_imageCoordinatesFromScreenCoordinates(cdata_.get(), arg0, arg1, arg2, easyar_Vec2F{{arg3.data[0], arg3.data[1]}});
    return Vec2F{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline bool CameraParameters::equalsTo(std::shared_ptr<CameraParameters> arg0)
{
    auto _return_value_ = easyar_CameraParameters_equalsTo(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}

inline CameraDevice::CameraDevice(std::shared_ptr<easyar_CameraDevice> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline CameraDevice::~CameraDevice()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_CameraDevice> CameraDevice::get_cdata()
{
    return cdata_;
}
inline void CameraDevice::init_cdata(std::shared_ptr<easyar_CameraDevice> cdata)
{
    cdata_ = cdata;
}
inline CameraDevice::CameraDevice()
    :
    cdata_(nullptr)
{
    easyar_CameraDevice * _return_value_;
    easyar_CameraDevice__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_CameraDevice>(_return_value_, [](easyar_CameraDevice * ptr) { easyar_CameraDevice__dtor(ptr); }));
}
inline bool CameraDevice::start()
{
    auto _return_value_ = easyar_CameraDevice_start(cdata_.get());
    return _return_value_;
}
inline bool CameraDevice::stop()
{
    auto _return_value_ = easyar_CameraDevice_stop(cdata_.get());
    return _return_value_;
}
inline void CameraDevice::setAndroidCameraApiType(AndroidCameraApiType arg0)
{
    easyar_CameraDevice_setAndroidCameraApiType(cdata_.get(), static_cast<easyar_AndroidCameraApiType>(arg0));
}
inline void CameraDevice::requestPermissions(std::shared_ptr<CallbackScheduler> arg0, std::function<void(PermissionStatus, std::string)> arg1)
{
    easyar_CameraDevice_requestPermissions((arg0 == nullptr ? nullptr : arg0->get_cdata().get()), FunctorOfVoidFromPermissionStatusAndString_to_c(arg1));
}
inline bool CameraDevice::openWithIndex(int arg0)
{
    auto _return_value_ = easyar_CameraDevice_openWithIndex(cdata_.get(), arg0);
    return _return_value_;
}
inline bool CameraDevice::openWithType(CameraDeviceType arg0)
{
    auto _return_value_ = easyar_CameraDevice_openWithType(cdata_.get(), static_cast<easyar_CameraDeviceType>(arg0));
    return _return_value_;
}
inline bool CameraDevice::close()
{
    auto _return_value_ = easyar_CameraDevice_close(cdata_.get());
    return _return_value_;
}
inline bool CameraDevice::isOpened()
{
    auto _return_value_ = easyar_CameraDevice_isOpened(cdata_.get());
    return _return_value_;
}
inline Vec2I CameraDevice::size()
{
    auto _return_value_ = easyar_CameraDevice_size(cdata_.get());
    return Vec2I{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline int CameraDevice::supportedSizeCount()
{
    auto _return_value_ = easyar_CameraDevice_supportedSizeCount(cdata_.get());
    return _return_value_;
}
inline Vec2I CameraDevice::supportedSize(int arg0)
{
    auto _return_value_ = easyar_CameraDevice_supportedSize(cdata_.get(), arg0);
    return Vec2I{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline bool CameraDevice::setSize(Vec2I arg0)
{
    auto _return_value_ = easyar_CameraDevice_setSize(cdata_.get(), easyar_Vec2I{{arg0.data[0], arg0.data[1]}});
    return _return_value_;
}
inline float CameraDevice::zoomScale()
{
    auto _return_value_ = easyar_CameraDevice_zoomScale(cdata_.get());
    return _return_value_;
}
inline bool CameraDevice::setZoomScale(float arg0)
{
    auto _return_value_ = easyar_CameraDevice_setZoomScale(cdata_.get(), arg0);
    return _return_value_;
}
inline float CameraDevice::minZoomScale()
{
    auto _return_value_ = easyar_CameraDevice_minZoomScale(cdata_.get());
    return _return_value_;
}
inline float CameraDevice::maxZoomScale()
{
    auto _return_value_ = easyar_CameraDevice_maxZoomScale(cdata_.get());
    return _return_value_;
}
inline int CameraDevice::supportedFrameRateRangeCount()
{
    auto _return_value_ = easyar_CameraDevice_supportedFrameRateRangeCount(cdata_.get());
    return _return_value_;
}
inline float CameraDevice::supportedFrameRateRangeLower(int arg0)
{
    auto _return_value_ = easyar_CameraDevice_supportedFrameRateRangeLower(cdata_.get(), arg0);
    return _return_value_;
}
inline float CameraDevice::supportedFrameRateRangeUpper(int arg0)
{
    auto _return_value_ = easyar_CameraDevice_supportedFrameRateRangeUpper(cdata_.get(), arg0);
    return _return_value_;
}
inline int CameraDevice::frameRateRange()
{
    auto _return_value_ = easyar_CameraDevice_frameRateRange(cdata_.get());
    return _return_value_;
}
inline bool CameraDevice::setFrameRateRange(int arg0)
{
    auto _return_value_ = easyar_CameraDevice_setFrameRateRange(cdata_.get(), arg0);
    return _return_value_;
}
inline bool CameraDevice::setFlashTorchMode(bool arg0)
{
    auto _return_value_ = easyar_CameraDevice_setFlashTorchMode(cdata_.get(), arg0);
    return _return_value_;
}
inline bool CameraDevice::setFocusMode(CameraDeviceFocusMode arg0)
{
    auto _return_value_ = easyar_CameraDevice_setFocusMode(cdata_.get(), static_cast<easyar_CameraDeviceFocusMode>(arg0));
    return _return_value_;
}
inline bool CameraDevice::autoFocus()
{
    auto _return_value_ = easyar_CameraDevice_autoFocus(cdata_.get());
    return _return_value_;
}
inline bool CameraDevice::setPresentProfile(CameraDevicePresetProfile arg0)
{
    auto _return_value_ = easyar_CameraDevice_setPresentProfile(cdata_.get(), static_cast<easyar_CameraDevicePresetProfile>(arg0));
    return _return_value_;
}
inline void CameraDevice::setStateChangedCallback(std::shared_ptr<CallbackScheduler> arg0, std::function<void(CameraState)> arg1)
{
    easyar_CameraDevice_setStateChangedCallback(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), FunctorOfVoidFromCameraState_to_c(arg1));
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus arg0, easyar_String * arg1)
{
    PermissionStatus cpparg0 = static_cast<PermissionStatus>(arg0);
    easyar_String_copy(arg1, &arg1);
    std::string cpparg1 = std_string_from_easyar_String(std::shared_ptr<easyar_String>(arg1, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
    auto f = reinterpret_cast<std::function<void(PermissionStatus, std::string)> *>(_state);
    (*f)(cpparg0, cpparg1);
}
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state)
{
    auto f = reinterpret_cast<std::function<void(PermissionStatus, std::string)> *>(_state);
    delete f;
}
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(std::function<void(PermissionStatus, std::string)> f)
{
    if (f == nullptr) { return easyar_FunctorOfVoidFromPermissionStatusAndString{nullptr, nullptr, nullptr}; }
    return easyar_FunctorOfVoidFromPermissionStatusAndString{new std::function<void(PermissionStatus, std::string)>(f), FunctorOfVoidFromPermissionStatusAndString_func, FunctorOfVoidFromPermissionStatusAndString_destroy};
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMCAMERASTATE__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMCAMERASTATE__
static void FunctorOfVoidFromCameraState_func(void * _state, easyar_CameraState arg0)
{
    CameraState cpparg0 = static_cast<CameraState>(arg0);
    auto f = reinterpret_cast<std::function<void(CameraState)> *>(_state);
    (*f)(cpparg0);
}
static void FunctorOfVoidFromCameraState_destroy(void * _state)
{
    auto f = reinterpret_cast<std::function<void(CameraState)> *>(_state);
    delete f;
}
static inline easyar_FunctorOfVoidFromCameraState FunctorOfVoidFromCameraState_to_c(std::function<void(CameraState)> f)
{
    if (f == nullptr) { return easyar_FunctorOfVoidFromCameraState{nullptr, nullptr, nullptr}; }
    return easyar_FunctorOfVoidFromCameraState{new std::function<void(CameraState)>(f), FunctorOfVoidFromCameraState_func, FunctorOfVoidFromCameraState_destroy};
}
#endif

}

#endif
