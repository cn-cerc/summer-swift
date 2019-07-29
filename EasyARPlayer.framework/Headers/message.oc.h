#import <Foundation/Foundation.h>
@class easyar_Dictionary;

/** 消息 */
@interface easyar_Message : NSObject

@property(readonly, nonatomic)int theId;
@property(readonly, nonatomic)easyar_Dictionary*body;

- (instancetype)initWithId:(int)theId;
- (instancetype)initWithId:(int)theId body:(easyar_Dictionary*)body;

@end
