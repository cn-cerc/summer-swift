//
//  CustemNavItem.h
//  summer
//
//  Created by FangLin on 16/11/11.
//  Copyright © 2016年 FangLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustemBBI <NSObject>

-(void)BBIdidClickWithName:(NSString *)infoStr;

@end

@interface CustemNavItemOC : UIBarButtonItem

/**
 *  自定义BBI图标
 *
 *  @param image   图片
 *  @param target  代理
 *  @param infoStr 标识字段
 *
 *  @return 当前对象BBI
 */
+(instancetype)initWithImage:(UIImage *)image andTarget:(id <CustemBBI>)target andinfoStr:(NSString *)infoStr;
/**
 *  自定义BBI图标
 *
 *  @param Str     字符
 *  @param target  代理
 *  @param infoStr 标识字段
 *
 *  @return 当前对象BBI
 */
+(instancetype)initWithString:(NSString *)Str andTarget:(UIViewController *)target andinfoStr:(NSString *)infoStr;

@property (nonatomic,weak)id <CustemBBI>delegate;

@end
