//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import "OCARBinding.h"
#import "OCUtil.h"

static const NSString* kKey_active          = @"active";
static const NSString* kKey_arbindingId     = @"arbindingId";
static const NSString* kKey_contentId       = @"contentId";
static const NSString* kKey_crsId           = @"crsId";
static const NSString* kKey_created         = @"created";
static const NSString* kKey_modified        = @"modified";
static const NSString* kKey_name            = @"name";
static const NSString* kKey_target          = @"target";
static const NSString* kKey_targetType      = @"targetType";

#undef NSAssert
#define NSAssert(...)

@interface OCARBinding()
@end

@implementation OCARBinding


-(instancetype)initWithResult:(NSDictionary*)result
{
    self = [super init];
    if (self) {

        NSAssert([result[kKey_active] isKindOfClass:[NSNumber class]], @"%@ should be a number, but %@", kKey_active, result[kKey_active]);
        NSAssert([result[kKey_arbindingId] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_arbindingId, result[kKey_arbindingId]);
        NSAssert([result[kKey_contentId] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_contentId, result[kKey_contentId]);
        NSAssert([result[kKey_crsId] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_crsId, result[kKey_crsId]);
        NSAssert([[OCUtil dateFromString_20180509:result[kKey_created]] isKindOfClass:[NSDate class]], @"%@ should be a date, but %@", kKey_created, result[kKey_created]);
        NSAssert([[OCUtil dateFromString_20180509:result[kKey_modified]] isKindOfClass:[NSDate class]], @"%@ should be a date, but %@", kKey_modified, result[kKey_modified]);
        NSAssert([result[kKey_name] isKindOfClass:[NSString class]], @"%@ should be a number, but %@", kKey_name, result[kKey_name]);
        NSAssert([result[kKey_target] isKindOfClass:[NSString class]], @"%@ should be a number, but %@", kKey_target, result[kKey_target]);
        NSAssert([result[kKey_targetType] isKindOfClass:[NSString class]], @"%@ should be a number, but %@", kKey_targetType, result[kKey_targetType]);

        self.active = [result[kKey_active] boolValue];
        self.arbindingId = result[kKey_arbindingId];
        self.contentId = result[kKey_contentId];
        self.crsId = result[kKey_crsId];
        self.created = [NSString stringWithFormat:@"%@",result[kKey_created]];
        self.modified = [NSString stringWithFormat:@"%@",result[kKey_modified]];// 仅仅用字符串进行比较即可
        self.name = result[kKey_name];
        self.targetId = result[kKey_target];
        self.targetType = result[kKey_targetType];

        NSAssert(nil != self.created, @"");
        NSAssert(nil != self.modified, @"");
        NSAssert([self.arbindingId length] > 0, @"");
        NSAssert([self.contentId length] > 0, @"");
        NSAssert([self.name length] > 0, @"");
        NSAssert([self.targetId length] > 0, @"");
        NSAssert([self.targetType length] > 0, @"");
        
        self.result = result;
    }
    return self;
}

-(BOOL)isValid
{
    return nil != self.result;
}

@end
