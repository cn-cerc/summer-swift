//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_TYPES_HPP__
#define __EASYAR_TYPES_HPP__

#include "easyar/types.h"
#include <cstddef>
#include <memory>
#include <string>
#include <array>
#include <vector>
#include <functional>
#include <stdexcept>

namespace easyar {

static inline std::shared_ptr<easyar_String> std_string_to_easyar_String(std::string s)
{
    easyar_String * ptr;
    easyar_String_from_utf8(s.data(), s.data() + s.size(), &ptr);
    return std::shared_ptr<easyar_String>(ptr, [](easyar_String * ptr) { easyar_String__dtor(ptr); });
}
static inline std::string std_string_from_easyar_String(std::shared_ptr<easyar_String> s)
{
    return std::string(easyar_String_begin(s.get()), easyar_String_end(s.get()));
}

class ObjectTargetParameters;

class ObjectTarget;

enum class ObjectTrackerMode
{
    PreferConsistency = 0,
    PreferSuccessrate = 1,
};

class ObjectTrackerResult;

class ObjectTracker;

enum class CloudStatus
{
    FoundTargets = 0,
    TargetsNotFound = 1,
    Reconnecting = 2,
    ProtocolError = 3,
};

class CloudRecognizer;

class AndroidJniUtility;

class Buffer;

class BufferDictionary;

class CallbackScheduler;

class DelayedCallbackScheduler;

class ImmediateCallbackScheduler;

enum class CameraDeviceFocusMode
{
    Normal = 0,
    Continousauto = 2,
    Infinity = 3,
    Macro = 4,
};

enum class AndroidCameraApiType
{
    Automatic = 0,
    Camera1 = 1,
    Camera2 = 2,
};

enum class CameraDeviceType
{
    Default = 0,
    Back = 1,
    Front = 2,
};

enum class CameraDevicePresetProfile
{
    Photo = 0,
    High = 1,
    Medium = 2,
    Low = 3,
};

enum class CameraState
{
    Unknown = 0x00000000,
    Disconnected = 0x00000001,
    Preempted = 0x00000002,
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

enum class PixelFormat
{
    Unknown = 0,
    Gray = 1,
    YUV_NV21 = 2,
    YUV_NV12 = 3,
    YUV_I420 = 4,
    YUV_YV12 = 5,
    RGB888 = 6,
    BGR888 = 7,
    RGBA8888 = 8,
    BGRA8888 = 9,
};

class Image;

enum class LogLevel
{
    Error = 0,
    Warning = 1,
    Info = 2,
};

class Log;

struct Matrix44F;

enum class PermissionStatus
{
    Granted = 0x00000000,
    Denied = 0x00000001,
    Error = 0x00000002,
};

enum class RendererAPI
{
    Auto = 0,
    None = 1,
    GLES2 = 2,
    GLES3 = 3,
    GL = 4,
    D3D9 = 5,
    D3D11 = 6,
    D3D12 = 7,
};

class TextureId;

class Renderer;

enum class StorageType
{
    App = 0,
    Assets = 1,
    Absolute = 2,
    Json = 0x00000100,
};

class Target;

enum class TargetStatus
{
    Unknown = 0,
    Undefined = 1,
    Detected = 2,
    Tracked = 3,
};

class TargetInstance;

class TargetTrackerResult;

class TargetTracker;

struct Vec4F;

struct Vec3F;

struct Vec2F;

struct Vec4I;

struct Vec2I;

enum class VideoStatus
{
    Error = -1,
    Ready = 0,
    Completed = 1,
};

enum class VideoType
{
    Normal = 0,
    TransparentSideBySide = 1,
    TransparentTopAndBottom = 2,
};

class VideoPlayer;

class ImageTargetParameters;

class ImageTarget;

enum class ImageTrackerMode
{
    PreferQuality = 0,
    PreferPerformance = 1,
};

class ImageTrackerResult;

class ImageTracker;

class QRCodeScannerResult;

class QRCodeScanner;

class Recorder;

enum class RecordProfile
{
    Quality_1080P_Low = 0x00000001,
    Quality_1080P_Middle = 0x00000002,
    Quality_1080P_High = 0x00000004,
    Quality_720P_Low = 0x00000008,
    Quality_720P_Middle = 0x00000010,
    Quality_720P_High = 0x00000020,
    Quality_480P_Low = 0x00000040,
    Quality_480P_Middle = 0x00000080,
    Quality_480P_High = 0x00000100,
    Quality_Default = 0x00000010,
};

enum class RecordVideoSize
{
    Vid1080p = 0x00000002,
    Vid720p = 0x00000010,
    Vid480p = 0x00000080,
};

enum class RecordZoomMode
{
    NoZoomAndClip = 0x00000000,
    ZoomInWithAllContent = 0x00000001,
};

enum class RecordVideoOrientation
{
    Landscape = 0x00000000,
    Portrait = 0x00000001,
};

enum class RecordStatus
{
    OnStarted = 0x00000002,
    OnStopped = 0x00000004,
    FailedToStart = 0x00000202,
    FileSucceeded = 0x00000400,
    FileFailed = 0x00000401,
    LogInfo = 0x00000800,
    LogError = 0x00001000,
};

class RecorderConfiguration;

class SurfaceTrackerResult;

class SurfaceTracker;

class ImageHelper;

}

#endif
