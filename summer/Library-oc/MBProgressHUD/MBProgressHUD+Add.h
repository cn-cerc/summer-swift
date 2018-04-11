//
//  MBProgressHUD+Add.h
//  CJWShopAPP
//
//  Created by lx on 15/7/17.
//  Copyright (c) 2015年 HG. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

+(MBProgressHUD *)showInView:(UIView *)contentView message:(NSString *)msg;
+(void)showText:(NSString *)msg;
+(void)showError:(NSString *)errorMsg;
+(void)hideAllHUD;



@end
