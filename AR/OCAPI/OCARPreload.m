//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import "OCARPreload.h"
#import "OCUtil.h"
#import "OCARTarget.h"

static const NSString* kKey_active          = @"active";
static const NSString* kKey_arbindingArray  = @"arbindingArray";
static const NSString* kKey_crsIdToStart    = @"crsIdToStart";
static const NSString* kKey_created         = @"created";
static const NSString* kKey_modified        = @"modified";
static const NSString* kKey_loadARBindings  = @"loadARBindings";
static const NSString* kKey_loadTargets     = @"loadTargets";
static const NSString* kKey_name            = @"name";
static const NSString* kKey_startSchemaId   = @"startSchemaId";
static const NSString* kKey_targets         = @"targets";

#undef NSAssert
#define NSAssert(...)

@interface OCARPreload()

@end

@implementation OCARPreload

-(instancetype)initWithResult:(NSDictionary*)result
{
    self = [super init];
    if (self) {

        NSAssert([result[kKey_active] isKindOfClass:[NSNumber class]], @"%@ should be a number, but %@", kKey_active, result[kKey_active]);
        NSAssert([[OCUtil jsonFromString:result[kKey_arbindingArray]] isKindOfClass:[NSArray class]], @"%@ should be a array, but %@", kKey_arbindingArray, result[kKey_arbindingArray]);
        NSAssert([[OCUtil jsonFromString:result[kKey_crsIdToStart]] isKindOfClass:[NSArray class]], @"%@ should be a array, but %@", kKey_crsIdToStart, result[kKey_crsIdToStart]);
        NSAssert([[OCUtil dateFromString_20180509:result[kKey_created]] isKindOfClass:[NSDate class]], @"%@ should be a date, but %@", kKey_created, result[kKey_created]);
        NSAssert([[OCUtil dateFromString_20180509:result[kKey_modified]] isKindOfClass:[NSDate class]], @"%@ should be a date, but %@", kKey_modified, result[kKey_modified]);
        
        NSAssert([result[kKey_loadARBindings] isKindOfClass:[NSString class]], @"%@ should be a string(bool), but %@", kKey_loadARBindings, result[kKey_loadARBindings]);
        NSAssert([result[kKey_loadARBindings] isEqualToString:@"true"] || [result[kKey_loadARBindings] isEqualToString:@"false"], @"");
        
        NSAssert([result[kKey_loadTargets] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_loadTargets, result[kKey_loadTargets]);
        NSAssert([result[kKey_loadTargets] isEqualToString:@"true"] || [result[kKey_loadTargets] isEqualToString:@"false"], @"");
        
        NSAssert([result[kKey_name] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_name, result[kKey_name]);
        NSAssert([result[kKey_startSchemaId] isKindOfClass:[NSString class]], @"%@ should be a string, but %@", kKey_startSchemaId, result[kKey_startSchemaId]);
        NSAssert([result[kKey_targets] isKindOfClass:[NSArray class]], @"%@ should be a array, but %@", kKey_targets, result[kKey_targets]);

        self.active = [result[kKey_active] boolValue];
        self.arbindingArray = [OCUtil jsonFromString:result[kKey_arbindingArray]];
        self.crsIdToStart = [OCUtil jsonFromString:result[kKey_crsIdToStart]];
        self.created = [NSString stringWithFormat:@"%@",result[kKey_created]];
        self.modified = [NSString stringWithFormat:@"%@",result[kKey_modified]];// 仅仅用字符串进行比较即可
        self.loadARBindings = [result[kKey_loadARBindings] boolValue];
        self.loadTargets = [result[kKey_loadTargets] boolValue];
        self.name = result[kKey_name];
        self.startSchemaId = result[kKey_startSchemaId];
        
        {
            NSArray<NSDictionary*>*targets = result[kKey_targets];
            NSMutableArray<OCARTarget*>*mTargets = [NSMutableArray<OCARTarget*> new];
            for (NSUInteger i=0;i<[targets count];i++)
            {
                NSDictionary* dict = [targets objectAtIndex:i];
                [mTargets addObject:[[OCARTarget alloc] initWithResult:dict isImageURL:YES]];
            }
            
            self.targets = mTargets;
        }

        NSAssert([self.arbindingArray count] > 0, @"");
        NSAssert([self.name length] > 0, @"");
        NSAssert([self.startSchemaId length] > 0, @"");
        NSAssert([self.targets count] > 0, @"");
        
        self.result = result;
    }
    return self;
}

-(BOOL)isValid
{
    return nil != self.result;
}

@end
