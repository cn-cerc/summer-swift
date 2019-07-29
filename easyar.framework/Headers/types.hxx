//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_TYPES_HXX__
#define __EASYAR_TYPES_HXX__

#include "easyar/types.h"
#include <cstddef>

namespace easyar {

class String
{
private:
    easyar_String * cdata_;
    virtual String & operator=(const String & data) { return *this; } //deleted
public:
    String(easyar_String * cdata)
        : cdata_(cdata)
    {
    }
    virtual ~String()
    {
        if (cdata_) {
            easyar_String__dtor(cdata_);
            cdata_ = NULL;
        }
    }

    String(const String & data)
        : cdata_(static_cast<easyar_String *>(NULL))
    {
        easyar_String_copy(data.cdata_, &cdata_);
    }
    const easyar_String * get_cdata() const
    {
        return cdata_;
    }
    easyar_String * get_cdata()
    {
        return cdata_;
    }

    static void from_utf8(const char * begin, const char * end, /* OUT */ String * * Return)
    {
        easyar_String * _return_value_ = NULL;
        easyar_String_from_utf8(begin, end, &_return_value_);
        *Return = _return_value_ == NULL ? NULL : new String(_return_value_);
    }
    static void from_utf8_begin(const char * begin, /* OUT */ String * * Return)
    {
        easyar_String * _return_value_ = NULL;
        easyar_String_from_utf8_begin(begin, &_return_value_);
        *Return = _return_value_ == NULL ? NULL : new String(_return_value_);
    }
    const char * begin()
    {
        return easyar_String_begin(cdata_);
    }
    const char * end()
    {
        return easyar_String_end(cdata_);
    }
};

class ObjectTargetParameters;

class ObjectTarget;

enum ObjectTrackerMode
{
    ObjectTrackerMode_PreferConsistency = 0,
    ObjectTrackerMode_PreferSuccessrate = 1,
};

class ObjectTrackerResult;

class ObjectTracker;

enum CloudStatus
{
    CloudStatus_FoundTargets = 0,
    CloudStatus_TargetsNotFound = 1,
    CloudStatus_Reconnecting = 2,
    CloudStatus_ProtocolError = 3,
};

class CloudRecognizer;

class AndroidJniUtility;

class Buffer;

class BufferDictionary;

class CallbackScheduler;

class DelayedCallbackScheduler;

class ImmediateCallbackScheduler;

enum CameraDeviceFocusMode
{
    CameraDeviceFocusMode_Normal = 0,
    CameraDeviceFocusMode_Continousauto = 2,
    CameraDeviceFocusMode_Infinity = 3,
    CameraDeviceFocusMode_Macro = 4,
};

enum AndroidCameraApiType
{
    AndroidCameraApiType_Automatic = 0,
    AndroidCameraApiType_Camera1 = 1,
    AndroidCameraApiType_Camera2 = 2,
};

enum CameraDeviceType
{
    CameraDeviceType_Default = 0,
    CameraDeviceType_Back = 1,
    CameraDeviceType_Front = 2,
};

enum CameraDevicePresetProfile
{
    CameraDevicePresetProfile_Photo = 0,
    CameraDevicePresetProfile_High = 1,
    CameraDevicePresetProfile_Medium = 2,
    CameraDevicePresetProfile_Low = 3,
};

enum CameraState
{
    CameraState_Unknown = 0x00000000,
    CameraState_Disconnected = 0x00000001,
    CameraState_Preempted = 0x00000002,
};

class CameraParameters;

class CameraDevice;

class Drawable;

class Engine;

class Frame;

class FrameFilter;

class FrameStreamer;

class CameraFrameStreamer;

class ExternalFrameStreamer;

enum PixelFormat
{
    PixelFormat_Unknown = 0,
    PixelFormat_Gray = 1,
    PixelFormat_YUV_NV21 = 2,
    PixelFormat_YUV_NV12 = 3,
    PixelFormat_YUV_I420 = 4,
    PixelFormat_YUV_YV12 = 5,
    PixelFormat_RGB888 = 6,
    PixelFormat_BGR888 = 7,
    PixelFormat_RGBA8888 = 8,
    PixelFormat_BGRA8888 = 9,
};

class Image;

enum LogLevel
{
    LogLevel_Error = 0,
    LogLevel_Warning = 1,
    LogLevel_Info = 2,
};

class Log;

struct Matrix44F;

enum PermissionStatus
{
    PermissionStatus_Granted = 0x00000000,
    PermissionStatus_Denied = 0x00000001,
    PermissionStatus_Error = 0x00000002,
};

enum RendererAPI
{
    RendererAPI_Auto = 0,
    RendererAPI_None = 1,
    RendererAPI_GLES2 = 2,
    RendererAPI_GLES3 = 3,
    RendererAPI_GL = 4,
    RendererAPI_D3D9 = 5,
    RendererAPI_D3D11 = 6,
    RendererAPI_D3D12 = 7,
};

class TextureId;

class Renderer;

enum StorageType
{
    StorageType_App = 0,
    StorageType_Assets = 1,
    StorageType_Absolute = 2,
    StorageType_Json = 0x00000100,
};

class Target;

enum TargetStatus
{
    TargetStatus_Unknown = 0,
    TargetStatus_Undefined = 1,
    TargetStatus_Detected = 2,
    TargetStatus_Tracked = 3,
};

class TargetInstance;

class TargetTrackerResult;

class TargetTracker;

struct Vec4F;

struct Vec3F;

struct Vec2F;

struct Vec4I;

struct Vec2I;

enum VideoStatus
{
    VideoStatus_Error = -1,
    VideoStatus_Ready = 0,
    VideoStatus_Completed = 1,
};

enum VideoType
{
    VideoType_Normal = 0,
    VideoType_TransparentSideBySide = 1,
    VideoType_TransparentTopAndBottom = 2,
};

class VideoPlayer;

class ImageTargetParameters;

class ImageTarget;

enum ImageTrackerMode
{
    ImageTrackerMode_PreferQuality = 0,
    ImageTrackerMode_PreferPerformance = 1,
};

class ImageTrackerResult;

class ImageTracker;

class QRCodeScannerResult;

class QRCodeScanner;

class Recorder;

enum RecordProfile
{
    RecordProfile_Quality_1080P_Low = 0x00000001,
    RecordProfile_Quality_1080P_Middle = 0x00000002,
    RecordProfile_Quality_1080P_High = 0x00000004,
    RecordProfile_Quality_720P_Low = 0x00000008,
    RecordProfile_Quality_720P_Middle = 0x00000010,
    RecordProfile_Quality_720P_High = 0x00000020,
    RecordProfile_Quality_480P_Low = 0x00000040,
    RecordProfile_Quality_480P_Middle = 0x00000080,
    RecordProfile_Quality_480P_High = 0x00000100,
    RecordProfile_Quality_Default = 0x00000010,
};

enum RecordVideoSize
{
    RecordVideoSize_Vid1080p = 0x00000002,
    RecordVideoSize_Vid720p = 0x00000010,
    RecordVideoSize_Vid480p = 0x00000080,
};

enum RecordZoomMode
{
    RecordZoomMode_NoZoomAndClip = 0x00000000,
    RecordZoomMode_ZoomInWithAllContent = 0x00000001,
};

enum RecordVideoOrientation
{
    RecordVideoOrientation_Landscape = 0x00000000,
    RecordVideoOrientation_Portrait = 0x00000001,
};

enum RecordStatus
{
    RecordStatus_OnStarted = 0x00000002,
    RecordStatus_OnStopped = 0x00000004,
    RecordStatus_FailedToStart = 0x00000202,
    RecordStatus_FileSucceeded = 0x00000400,
    RecordStatus_FileFailed = 0x00000401,
    RecordStatus_LogInfo = 0x00000800,
    RecordStatus_LogError = 0x00001000,
};

class RecorderConfiguration;

class SurfaceTrackerResult;

class SurfaceTracker;

class ImageHelper;

class ListOfPointerOfObjectTarget;

class ListOfVec3F;

class ListOfPointerOfTargetInstance;

struct FunctorOfVoidFromPointerOfTargetAndBool;

class ListOfPointerOfTarget;

struct FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget;

struct FunctorOfVoidFromPermissionStatusAndString;

struct FunctorOfVoidFromCameraState;

class ListOfPointerOfImage;

struct FunctorOfVoidFromLogLevelAndString;

struct FunctorOfVoidFromVideoStatus;

class ListOfPointerOfImageTarget;

struct FunctorOfVoidFromRecordStatusAndString;

}

#endif
