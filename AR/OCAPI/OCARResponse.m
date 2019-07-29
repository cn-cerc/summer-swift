//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import "OCARResponse.h"
#import "OCUtil.h"

static const NSString *kStatusCode  = @"statusCode";
static const NSString *kMessage     = @"msg";
static const NSString *kDate        = @"timestamp";
static const NSString *kResult      = @"result";

#undef NSAssert
#define NSAssert(...)

@implementation OCARResponse

-(instancetype)initWithJSON:(NSDictionary*)jso
{
    self = [super init];
    if (self)
    {
        NSAssert([jso[kStatusCode] isKindOfClass:[NSNumber class]], @"%@ should be a number", kStatusCode);
        NSAssert([jso[kMessage] isKindOfClass:[NSString class]], @"%@ should be a string", kMessage);
        NSAssert([jso[kDate] isKindOfClass:[NSString class]], @"%@ should be a string date", kDate);
        NSAssert([jso[kResult] isKindOfClass:[NSDictionary class]], @"%@ should be a dictionary", kResult);
        
        self.statusCode = [jso[kStatusCode] integerValue];
        self.message = jso[kMessage];
        self.timestamp = jso[kDate];
        self.restult = jso[kResult];
        
        NSAssert(nil != self.message, @"");
        NSAssert(nil != self.date, @"");
        NSAssert(nil != self.restult, @"");
    }
    return self;
}

-(BOOL)isStatusCodeOK
{
    return 0 == self.statusCode;
}

//-(BOOL)isPastThanDate:(NSDate*)date
//{
//    return [OCUtil isPastDate:self.date thanDate:date];
//}
//
//-(BOOL)isFutureThanDate:(NSDate*)date
//{
//    return [OCUtil isFutureDate:self.date thanDate:date];
//}
//
//-(BOOL)isPastThanTime:(NSTimeInterval)time
//{
//    return [OCUtil isPastTime:[self.date timeIntervalSince1970] thanTime:time];
//}
//
//-(BOOL)isFutureThanTime:(NSTimeInterval)time
//{
//    return [OCUtil isFutureTime:[self.date timeIntervalSince1970] thanTime:time];
//}

@end
