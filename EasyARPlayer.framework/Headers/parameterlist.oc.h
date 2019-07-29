#import <Foundation/Foundation.h>

@interface easyar_ParameterList : NSObject

+(int) create;
+(void) release:(int) parameterListId;
+(int) getNumParameters:(int) parameterListId;

+(void) pushInt32:(int) data forParameterListID:(int) parameterListId;
+(int) getInt32:(int) index forParameterListID:(int) parameterListId;

+(void) pushFloat:(float) data forParameterListID:(int) parameterListId;
+(float) getFloat:(int) index forParameterListID:(int) parameterListId;

+(void) pushString:(NSString*) data forParameterListID:(int) parameterListId;
+(NSString*) getString:(int) index forParameterListID:(int) parameterListId;

+(void) pushBytes:(NSData*)data forParameterListID:(int) parameterListId;
+(void) pushBytes:(const void*)bytes bytesSize:(int) dataLen forParameterListID:(int) parameterListId;
+(NSData*) getBytes:(int) index forParameterListID:(int) parameterListId;

@end
