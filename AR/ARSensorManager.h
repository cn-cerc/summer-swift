//
//  ARSensorManager.h
//  GuizhouUniversity
//
//  Created by 刘高升 on 2019/6/20.
//  Copyright © 2019 刘高升. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CLHeading.h>
#import <CoreMotion/CoreMotion.h>


NS_ASSUME_NONNULL_BEGIN

@interface ARSensorManager : NSObject
+ (instancetype)shared;
- (void)startSensor;
- (void)startGyroscope;
- (void)stopSensor;

@property (nonatomic, copy) void (^didUpdateHeadingBlock)(CLLocationDirection theHeading);
@property (nonatomic, copy) void (^updateDeviceMotionBlock)(CMDeviceMotion *data);
@end

NS_ASSUME_NONNULL_END
