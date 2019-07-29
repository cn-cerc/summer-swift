//=============================================================================================================================
//
// EasyAR 3.0.0-beta2-r051e1c1c
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_RECORDER_CONFIGURATION_HPP__
#define __EASYAR_RECORDER_CONFIGURATION_HPP__

#include "easyar/types.hpp"

namespace easyar {

class RecorderConfiguration
{
protected:
    std::shared_ptr<easyar_RecorderConfiguration> cdata_;
    void init_cdata(std::shared_ptr<easyar_RecorderConfiguration> cdata);
    RecorderConfiguration & operator=(const RecorderConfiguration & data) = delete;
public:
    RecorderConfiguration(std::shared_ptr<easyar_RecorderConfiguration> cdata);
    virtual ~RecorderConfiguration();

    std::shared_ptr<easyar_RecorderConfiguration> get_cdata();

    RecorderConfiguration();
    void setOutputFile(std::string path);
    bool setProfile(RecordProfile profile);
    void setVideoSize(RecordVideoSize framesize);
    void setVideoBitrate(int bitrate);
    void setChannelCount(int count);
    void setAudioSampleRate(int samplerate);
    void setAudioBitrate(int bitrate);
    void setVideoOrientation(RecordVideoOrientation mode);
    void setZoomMode(RecordZoomMode mode);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_RECORDER_CONFIGURATION_HPP__
#define __IMPLEMENTATION_EASYAR_RECORDER_CONFIGURATION_HPP__

#include "easyar/recorder_configuration.h"

namespace easyar {

inline RecorderConfiguration::RecorderConfiguration(std::shared_ptr<easyar_RecorderConfiguration> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline RecorderConfiguration::~RecorderConfiguration()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_RecorderConfiguration> RecorderConfiguration::get_cdata()
{
    return cdata_;
}
inline void RecorderConfiguration::init_cdata(std::shared_ptr<easyar_RecorderConfiguration> cdata)
{
    cdata_ = cdata;
}
inline RecorderConfiguration::RecorderConfiguration()
    :
    cdata_(nullptr)
{
    easyar_RecorderConfiguration * _return_value_;
    easyar_RecorderConfiguration__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_RecorderConfiguration>(_return_value_, [](easyar_RecorderConfiguration * ptr) { easyar_RecorderConfiguration__dtor(ptr); }));
}
inline void RecorderConfiguration::setOutputFile(std::string arg0)
{
    easyar_RecorderConfiguration_setOutputFile(cdata_.get(), std_string_to_easyar_String(arg0).get());
}
inline bool RecorderConfiguration::setProfile(RecordProfile arg0)
{
    auto _return_value_ = easyar_RecorderConfiguration_setProfile(cdata_.get(), static_cast<easyar_RecordProfile>(arg0));
    return _return_value_;
}
inline void RecorderConfiguration::setVideoSize(RecordVideoSize arg0)
{
    easyar_RecorderConfiguration_setVideoSize(cdata_.get(), static_cast<easyar_RecordVideoSize>(arg0));
}
inline void RecorderConfiguration::setVideoBitrate(int arg0)
{
    easyar_RecorderConfiguration_setVideoBitrate(cdata_.get(), arg0);
}
inline void RecorderConfiguration::setChannelCount(int arg0)
{
    easyar_RecorderConfiguration_setChannelCount(cdata_.get(), arg0);
}
inline void RecorderConfiguration::setAudioSampleRate(int arg0)
{
    easyar_RecorderConfiguration_setAudioSampleRate(cdata_.get(), arg0);
}
inline void RecorderConfiguration::setAudioBitrate(int arg0)
{
    easyar_RecorderConfiguration_setAudioBitrate(cdata_.get(), arg0);
}
inline void RecorderConfiguration::setVideoOrientation(RecordVideoOrientation arg0)
{
    easyar_RecorderConfiguration_setVideoOrientation(cdata_.get(), static_cast<easyar_RecordVideoOrientation>(arg0));
}
inline void RecorderConfiguration::setZoomMode(RecordZoomMode arg0)
{
    easyar_RecorderConfiguration_setZoomMode(cdata_.get(), static_cast<easyar_RecordZoomMode>(arg0));
}

}

#endif
