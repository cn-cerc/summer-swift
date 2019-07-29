#import <Foundation/Foundation.h>
@class easyar_BufferVariant;

/** EasyAR多类型字典 */
@interface easyar_Dictionary : NSObject

-(int) size;


// sample：
//
// NSString*key = nil;
// [dict loopReset];
// while(nil != (key=[dict loopNextKey]))
// {
//      if ([dict isInt32:key])         { ... }
//      if ([dict isFloat:key])         { ... }
//      if ([dict isString:key])        { ... }
//      if ([dict isBufferVariant:key]) { ... }
// }
-(void)loopReset;
-(NSString*)loopNextKey;

-(void) setInt32:(int)val forKey:(NSString*) key;
-(int)  getInt32ForKey:(NSString*)key;
-(BOOL) isInt32ForKey:(NSString*)key;

-(void) setFloat:(float)val forKey:(NSString*) key;
-(float)getFloatForKey:(NSString*)key;
-(BOOL) isFloatForKey:(NSString*)key;

-(void) setString:(NSString*)val forKey:(NSString*) key;
-(NSString*)getStringForKey:(NSString*)key;
-(BOOL) isStringForKey:(NSString*)key;

-(void) setBufferVariant:(easyar_BufferVariant*)val forKey:(NSString*) key;
-(easyar_BufferVariant*)getBufferVariantForKey:(NSString*)key;
-(BOOL) isBufferVariantForKey:(NSString*)key;

@end
