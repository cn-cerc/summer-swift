#import <Foundation/Foundation.h>
@class easyar_Message;
@class easyar_PlayerView;

/**
 * MessageClient, must call in a single thread
 */
@interface easyar_MessageClient : NSObject

/**
 * 为PlayerView初始化MessageClient
 * @param playerView player view
 * @param name MessageClient名
 * @param destName 目标MessageClient名（后续可以修改）
 * @param callback 接收消息的回调
 * @return 初始化的MessageClient
 */
- (instancetype)initWithPlayerView:(easyar_PlayerView*)playerView name:(NSString*)name destName:(NSString*)destName callback:(void(^)(NSString*from, easyar_Message*message))callback;

/** 释放MessageClient */
-(void)releaseClient;

/**
 * 设置消息发送目标MessageClient名
 * @param dst 目标MessageClient名
 * @return 始终为true
 */
-(void)setDest:(NSString*)dst;

/**
 * 发送消息到目标MessageClient
 * @param msg 消息
 * @return 是否成功
 */
-(BOOL)send:(easyar_Message*)msg;

-(int)getuid;

@end
