#import "UserFileSystem.h"

@interface UserFileSystem()
@end

@implementation UserFileSystem
NSString* rootDir;

- (instancetype)init {
    self = [super init];
    if (self) {
        rootDir = nil;
    }
    return self;
}

-(void) clearCache
{
    
}

-(BOOL) fileExist:(NSString*) fileName
{
    NSLog(@"exist filename: %@", fileName);
    return TRUE;
}

-(NSString*) convertUserToAbsolute:(NSString*) fileName
{
    NSLog(@"convert filename: %@", fileName);
    NSString *stringNew = [fileName substringWithRange:NSMakeRange(7, [fileName length] - 7)];
//    NSLog(@"convert stringNew: %@", stringNew);
    NSString *stringLast =  [rootDir stringByAppendingString:stringNew];
    BOOL have = [[NSFileManager defaultManager] fileExistsAtPath:stringLast];
    NSString *strr = @"下载文件不存在";
    if (have) {
        strr = @"下载文件存在";
    }
    NSLog(@"convert stringLast: %@ %@",strr, stringLast);
    return stringLast;
}

-(void) setUserRootDir:(NSString*) dir
{
    NSLog(@"set dir %@", dir);
    rootDir = dir;
}
@end
