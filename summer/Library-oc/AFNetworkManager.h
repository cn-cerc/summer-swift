//
//  AFNetworkManager.h
//  HuangJia
//
//  Created by cts on 16/5/31.
//  Copyright © 2016年 cts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


typedef void(^AFSucBlock)(NSURLSessionDataTask *task,NSDictionary *responseObject);
typedef void(^AFErrBlock)(NSURLSessionDataTask *task,NSError *error);

typedef void(^AFSucBlock1)(AFHTTPRequestOperation *operation,NSDictionary *responseObject);
typedef void(^AFErrBlock1)(AFHTTPRequestOperation *operation,NSError *error);
typedef void(^AFFormDataBlock) (id<AFMultipartFormData> formData);
@interface AFNetworkManager : NSObject
/**
 *  POST 请求
 *
 *  @param url          请求url
 *  @param param        参数
 *  @param successBlock 成功block
 *  @param errorBlock   失败block
 */
+(void)POST:(NSString *)url parameters:(id)param success:(AFSucBlock)successBlock failure:(AFErrBlock)errorBlock;
/**
*  上传图片使用
*
*  @param url          URL
*  @param param        参数
*  @param title        菊花的标题
*  @param successBlock 成功回调数据
*  @param errorBlock   失败回调数据
*  @param dataBlock    图片上传类 appendPartWithFileURL  name是服务器要的参数名

*/

+(void)POST:(NSString *)url parameters:(id)param formData:(AFFormDataBlock)dataBlock success:(AFSucBlock1)successBlock failure:(AFErrBlock1)errorBlock;
/**
 *  get请求
 *
 */
+(void)GET:(NSString *)url parameters:(id)param success:(AFSucBlock1)successBlock failure:(AFErrBlock1)errorBlock;

+(void)downloadFileWithURL:(NSString*)requestURLString
                 parameters:(NSDictionary *)parameters
                  savedPath:(NSString*)savedPath
            downloadSuccess:(void (^)(NSURLResponse *response, NSURL *filePath))success
            downloadFailure:(void (^)(NSError *error))failure
           downloadProgress:(void (^)(NSProgress *downloadProgress))progress;

@end
