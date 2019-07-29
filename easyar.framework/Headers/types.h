//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_TYPES_H__
#define __EASYAR_TYPES_H__

#ifndef __cplusplus
#include <stdbool.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef struct { char _placeHolder_; } easyar_String;
void easyar_String_from_utf8(const char * begin, const char * end, /* OUT */ easyar_String * * Return);
void easyar_String_from_utf8_begin(const char * begin, /* OUT */ easyar_String * * Return);
const char * easyar_String_begin(const easyar_String * This);
const char * easyar_String_end(const easyar_String * This);
void easyar_String_copy(const easyar_String * This, /* OUT */ easyar_String * * Return);
void easyar_String__dtor(easyar_String * This);

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_ObjectTargetParameters;

/// <summary>
/// class
/// extends Target
/// </summary>
typedef struct { char _placeHolder_; } easyar_ObjectTarget;

typedef enum
{
    easyar_ObjectTrackerMode_PreferConsistency = 0,
    easyar_ObjectTrackerMode_PreferSuccessrate = 1,
} easyar_ObjectTrackerMode;

/// <summary>
/// class
/// extends TargetTrackerResult
/// </summary>
typedef struct { char _placeHolder_; } easyar_ObjectTrackerResult;

/// <summary>
/// class
/// extends TargetTracker
/// </summary>
typedef struct { char _placeHolder_; } easyar_ObjectTracker;

typedef enum
{
    easyar_CloudStatus_FoundTargets = 0,
    easyar_CloudStatus_TargetsNotFound = 1,
    easyar_CloudStatus_Reconnecting = 2,
    easyar_CloudStatus_ProtocolError = 3,
} easyar_CloudStatus;

/// <summary>
/// class
/// extends FrameFilter
/// </summary>
typedef struct { char _placeHolder_; } easyar_CloudRecognizer;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_AndroidJniUtility;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_Buffer;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_BufferDictionary;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_CallbackScheduler;

/// <summary>
/// class
/// extends CallbackScheduler
/// </summary>
typedef struct { char _placeHolder_; } easyar_DelayedCallbackScheduler;

/// <summary>
/// class
/// extends CallbackScheduler
/// </summary>
typedef struct { char _placeHolder_; } easyar_ImmediateCallbackScheduler;

typedef enum
{
    easyar_CameraDeviceFocusMode_Normal = 0,
    easyar_CameraDeviceFocusMode_Continousauto = 2,
    easyar_CameraDeviceFocusMode_Infinity = 3,
    easyar_CameraDeviceFocusMode_Macro = 4,
} easyar_CameraDeviceFocusMode;

typedef enum
{
    easyar_AndroidCameraApiType_Automatic = 0,
    easyar_AndroidCameraApiType_Camera1 = 1,
    easyar_AndroidCameraApiType_Camera2 = 2,
} easyar_AndroidCameraApiType;

typedef enum
{
    easyar_CameraDeviceType_Default = 0,
    easyar_CameraDeviceType_Back = 1,
    easyar_CameraDeviceType_Front = 2,
} easyar_CameraDeviceType;

typedef enum
{
    easyar_CameraDevicePresetProfile_Photo = 0,
    easyar_CameraDevicePresetProfile_High = 1,
    easyar_CameraDevicePresetProfile_Medium = 2,
    easyar_CameraDevicePresetProfile_Low = 3,
} easyar_CameraDevicePresetProfile;

typedef enum
{
    easyar_CameraState_Unknown = 0x00000000,
    easyar_CameraState_Disconnected = 0x00000001,
    easyar_CameraState_Preempted = 0x00000002,
} easyar_CameraState;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_CameraParameters;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_CameraDevice;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_Drawable;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_Engine;

/// <summary>
/// class
/// extends Drawable
/// </summary>
typedef struct { char _placeHolder_; } easyar_Frame;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_FrameFilter;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_FrameStreamer;

/// <summary>
/// class
/// extends FrameStreamer
/// </summary>
typedef struct { char _placeHolder_; } easyar_CameraFrameStreamer;

/// <summary>
/// class
/// extends FrameStreamer
/// </summary>
typedef struct { char _placeHolder_; } easyar_ExternalFrameStreamer;

typedef enum
{
    easyar_PixelFormat_Unknown = 0,
    easyar_PixelFormat_Gray = 1,
    easyar_PixelFormat_YUV_NV21 = 2,
    easyar_PixelFormat_YUV_NV12 = 3,
    easyar_PixelFormat_YUV_I420 = 4,
    easyar_PixelFormat_YUV_YV12 = 5,
    easyar_PixelFormat_RGB888 = 6,
    easyar_PixelFormat_BGR888 = 7,
    easyar_PixelFormat_RGBA8888 = 8,
    easyar_PixelFormat_BGRA8888 = 9,
} easyar_PixelFormat;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_Image;

typedef enum
{
    easyar_LogLevel_Error = 0,
    easyar_LogLevel_Warning = 1,
    easyar_LogLevel_Info = 2,
} easyar_LogLevel;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_Log;

/// <summary>
/// record
/// </summary>
typedef struct
{
    float data[16];
} easyar_Matrix44F;

typedef enum
{
    easyar_PermissionStatus_Granted = 0x00000000,
    easyar_PermissionStatus_Denied = 0x00000001,
    easyar_PermissionStatus_Error = 0x00000002,
} easyar_PermissionStatus;

typedef enum
{
    easyar_RendererAPI_Auto = 0,
    easyar_RendererAPI_None = 1,
    easyar_RendererAPI_GLES2 = 2,
    easyar_RendererAPI_GLES3 = 3,
    easyar_RendererAPI_GL = 4,
    easyar_RendererAPI_D3D9 = 5,
    easyar_RendererAPI_D3D11 = 6,
    easyar_RendererAPI_D3D12 = 7,
} easyar_RendererAPI;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_TextureId;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_Renderer;

typedef enum
{
    easyar_StorageType_App = 0,
    easyar_StorageType_Assets = 1,
    easyar_StorageType_Absolute = 2,
    easyar_StorageType_Json = 0x00000100,
} easyar_StorageType;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_Target;

typedef enum
{
    easyar_TargetStatus_Unknown = 0,
    easyar_TargetStatus_Undefined = 1,
    easyar_TargetStatus_Detected = 2,
    easyar_TargetStatus_Tracked = 3,
} easyar_TargetStatus;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_TargetInstance;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_TargetTrackerResult;

/// <summary>
/// class
/// extends FrameFilter
/// </summary>
typedef struct { char _placeHolder_; } easyar_TargetTracker;

/// <summary>
/// record
/// </summary>
typedef struct
{
    float data[4];
} easyar_Vec4F;

/// <summary>
/// record
/// </summary>
typedef struct
{
    float data[3];
} easyar_Vec3F;

/// <summary>
/// record
/// </summary>
typedef struct
{
    float data[2];
} easyar_Vec2F;

/// <summary>
/// record
/// </summary>
typedef struct
{
    int data[4];
} easyar_Vec4I;

/// <summary>
/// record
/// </summary>
typedef struct
{
    int data[2];
} easyar_Vec2I;

typedef enum
{
    easyar_VideoStatus_Error = -1,
    easyar_VideoStatus_Ready = 0,
    easyar_VideoStatus_Completed = 1,
} easyar_VideoStatus;

typedef enum
{
    easyar_VideoType_Normal = 0,
    easyar_VideoType_TransparentSideBySide = 1,
    easyar_VideoType_TransparentTopAndBottom = 2,
} easyar_VideoType;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_VideoPlayer;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_ImageTargetParameters;

/// <summary>
/// class
/// extends Target
/// </summary>
typedef struct { char _placeHolder_; } easyar_ImageTarget;

typedef enum
{
    easyar_ImageTrackerMode_PreferQuality = 0,
    easyar_ImageTrackerMode_PreferPerformance = 1,
} easyar_ImageTrackerMode;

/// <summary>
/// class
/// extends TargetTrackerResult
/// </summary>
typedef struct { char _placeHolder_; } easyar_ImageTrackerResult;

/// <summary>
/// class
/// extends TargetTracker
/// </summary>
typedef struct { char _placeHolder_; } easyar_ImageTracker;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_QRCodeScannerResult;

/// <summary>
/// class
/// extends FrameFilter
/// </summary>
typedef struct { char _placeHolder_; } easyar_QRCodeScanner;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_Recorder;

typedef enum
{
    easyar_RecordProfile_Quality_1080P_Low = 0x00000001,
    easyar_RecordProfile_Quality_1080P_Middle = 0x00000002,
    easyar_RecordProfile_Quality_1080P_High = 0x00000004,
    easyar_RecordProfile_Quality_720P_Low = 0x00000008,
    easyar_RecordProfile_Quality_720P_Middle = 0x00000010,
    easyar_RecordProfile_Quality_720P_High = 0x00000020,
    easyar_RecordProfile_Quality_480P_Low = 0x00000040,
    easyar_RecordProfile_Quality_480P_Middle = 0x00000080,
    easyar_RecordProfile_Quality_480P_High = 0x00000100,
    easyar_RecordProfile_Quality_Default = 0x00000010,
} easyar_RecordProfile;

typedef enum
{
    easyar_RecordVideoSize_Vid1080p = 0x00000002,
    easyar_RecordVideoSize_Vid720p = 0x00000010,
    easyar_RecordVideoSize_Vid480p = 0x00000080,
} easyar_RecordVideoSize;

typedef enum
{
    easyar_RecordZoomMode_NoZoomAndClip = 0x00000000,
    easyar_RecordZoomMode_ZoomInWithAllContent = 0x00000001,
} easyar_RecordZoomMode;

typedef enum
{
    easyar_RecordVideoOrientation_Landscape = 0x00000000,
    easyar_RecordVideoOrientation_Portrait = 0x00000001,
} easyar_RecordVideoOrientation;

typedef enum
{
    easyar_RecordStatus_OnStarted = 0x00000002,
    easyar_RecordStatus_OnStopped = 0x00000004,
    easyar_RecordStatus_FailedToStart = 0x00000202,
    easyar_RecordStatus_FileSucceeded = 0x00000400,
    easyar_RecordStatus_FileFailed = 0x00000401,
    easyar_RecordStatus_LogInfo = 0x00000800,
    easyar_RecordStatus_LogError = 0x00001000,
} easyar_RecordStatus;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_RecorderConfiguration;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_SurfaceTrackerResult;

/// <summary>
/// class
/// extends FrameFilter
/// </summary>
typedef struct { char _placeHolder_; } easyar_SurfaceTracker;

/// <summary>
/// class
/// </summary>
typedef struct { char _placeHolder_; } easyar_ImageHelper;

typedef struct { char _placeHolder_; } easyar_ListOfPointerOfObjectTarget;

typedef struct { char _placeHolder_; } easyar_ListOfVec3F;

typedef struct { char _placeHolder_; } easyar_ListOfPointerOfTargetInstance;

typedef struct { char _placeHolder_; } easyar_ListOfPointerOfTarget;

typedef struct { char _placeHolder_; } easyar_ListOfPointerOfImage;

typedef struct { char _placeHolder_; } easyar_ListOfPointerOfImageTarget;

typedef struct
{
    void * _state;
    void (* func)(void * _state, easyar_Target *, bool);
    void (* destroy)(void * _state);
} easyar_FunctorOfVoidFromPointerOfTargetAndBool;

typedef struct
{
    void * _state;
    void (* func)(void * _state, easyar_CloudStatus, easyar_ListOfPointerOfTarget *);
    void (* destroy)(void * _state);
} easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget;

typedef struct
{
    void * _state;
    void (* func)(void * _state, easyar_PermissionStatus, easyar_String *);
    void (* destroy)(void * _state);
} easyar_FunctorOfVoidFromPermissionStatusAndString;

typedef struct
{
    void * _state;
    void (* func)(void * _state, easyar_CameraState);
    void (* destroy)(void * _state);
} easyar_FunctorOfVoidFromCameraState;

typedef struct
{
    void * _state;
    void (* func)(void * _state, easyar_LogLevel, easyar_String *);
    void (* destroy)(void * _state);
} easyar_FunctorOfVoidFromLogLevelAndString;

typedef struct
{
    void * _state;
    void (* func)(void * _state, easyar_VideoStatus);
    void (* destroy)(void * _state);
} easyar_FunctorOfVoidFromVideoStatus;

typedef struct
{
    void * _state;
    void (* func)(void * _state, easyar_RecordStatus, easyar_String *);
    void (* destroy)(void * _state);
} easyar_FunctorOfVoidFromRecordStatusAndString;

#ifdef __cplusplus
}
#endif

#endif
