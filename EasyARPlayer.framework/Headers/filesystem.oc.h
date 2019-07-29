#import <Foundation/Foundation.h>
@class easyar_PlayerView;

/**
 * 文件系统接口
 */
@protocol easyar_IFileSystem

/** check filename start with user:// exist */
-(BOOL) fileExist:(NSString*) fileName;

/** convert filename from user:// to absolute file, etc. /sdcard/easyar3d/sample.png */
-(NSString*) convertUserToAbsolute:(NSString*) fileName;

@end
