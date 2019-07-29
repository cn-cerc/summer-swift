/**
* Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#import <GLKit/GLKView.h>

@protocol easyar_IFileSystem;
@class easyar_Service;

/** Player的View */
@interface easyar_PlayerView : GLKView

/**
 * 设置FPS
 * @param fps FPS值
 */
- (void)setFPS:(int)fps;

/**
 * dispose
 */
- (void)dispose;

/**
 * 加载包
 * @param localPath 包路径
 * @param onFinish 完成时的回调
 * @return 始终是true
 */
- (BOOL)loadPackage:(NSString *)localPath onFinish:(void(^)())onFinish;

/**
 * 卸载包
 * @param localPath 路径
 * @return 始终是true
 */
- (BOOL)unloadPackage:(NSString *)localPath;

/**
 * 注册服务
 * @param service 服务
 */
- (void)registerService:(easyar_Service *)service;


/**
 * 注销服务
 * @param service 服务
 */
- (void)unregisterService:(easyar_Service *)service;

/**
 * 截屏
 * @param onSuccess 成功时的回调
 * @param onFailed 失败时的回调
 */
- (void)snapshot:(void(^)(UIImage *image))onSuccess failed:(void(^)(NSString *msg))onFailed;

/**
 * 设置文件系统
 * @param fileSystem 文件系统
 */
-(void) setFileSystem:(id<easyar_IFileSystem>)fileSystem;

/**
 * 添加PostRender回调
 * @param funcCallback 回调函数
 * @return 成功时返回回调的Id, 失败时返回-1
 */
-(int)addPostRenderCallback:(void(^)(int textureId, unsigned int width, unsigned int height))funcCallback;

/**
 * 移除PostRender回调
 * @param callbackId 回调的Id
 */
-(void)removePostRenderCallback:(int)callbackId;

@end
