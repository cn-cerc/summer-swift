
#import <Foundation/Foundation.h>
@class easyar_Dictionary;

/**
 * EasyAR Service
 */
@interface easyar_Service : NSObject

/**
 * 执行command
 * @param commandId command Id
 * @param params 参数
 * @param results 结果
 * @return 是否成功
 */
- (BOOL)command:(int)id withParams:(easyar_Dictionary *)params andResults:(easyar_Dictionary *)results;

/**
 * 获取此Service的Id
 * @return service Id，失败时返回0
 */
- (int)getServiceId;

/**
 * 获取Service类型
 * @return Service类型名，失败时返回"Unknown"
 */
- (NSString *)getServiceType;

/**
 * 设置Service类型
 * @param type Service类型名
 */
- (void)setServiceType:(NSString *)type;

/**
 * 获取Service的描述
 * @return 描述，失败时返回""
 */
- (NSString *)getServiceDesc;

/**
 * 设置Service的描述
 * @param desc 描述
 */
- (void)setServiceDesc:(NSString *)desc;

@end


