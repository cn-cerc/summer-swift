#pragma once

#import "EasyARPlayer/filesystem.oc.h"

@interface UserFileSystem : NSObject <easyar_IFileSystem>

-(BOOL) fileExist:(NSString*) fileName;
-(NSString*) convertUserToAbsolute:(NSString*) fileName;

-(void) clearCache;
-(void) setUserRootDir:(NSString*) dir;
@end
