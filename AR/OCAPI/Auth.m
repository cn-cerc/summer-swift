//================================================================================================================================
//
//  Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
//  EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
//  and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//================================================================================================================================

#import "Auth.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Auth

static NSString *kTimestamp = @"timestamp";
static NSString *kOCKey = @"ocKey";
static NSString *kSignature = @"signature";

+ (NSString *)sha256Hex:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);

    NSMutableString *res = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [res appendFormat:@"%02x", digest[i]];
    }
    return res;
}

+ (NSString *)generateSignature:(NSDictionary *)param withSecret:(NSString *)secret {
    NSArray *keys = [[param allKeys] sortedArrayUsingSelector:@selector(compare:)];

    NSMutableString *paramStr = [NSMutableString new];
    for (NSString *key in keys) {
        [paramStr appendString:key];
        [paramStr appendString:[param objectForKey:key]];
    }

    [paramStr appendString:secret];

    return [Auth sha256Hex:paramStr];
}

+ (NSDictionary *)signParam:(NSDictionary *)param withKey:(NSString *)key andSecret:(NSString *)secret {
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithDictionary:param];
    
    NSString*dateStr = [NSString stringWithFormat:@"%llu",(unsigned long long)[[NSDate date] timeIntervalSince1970]*1000];

    [res setObject:dateStr forKey:kTimestamp];
    [res setObject:key forKey:kOCKey];
    [res setObject:[Auth generateSignature:res withSecret:secret] forKey:kSignature];

    return res;
}

@end
