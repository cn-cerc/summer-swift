//
//  MBProgressHUD+Add.m
//  CJWShopAPP
//
//  Created by lx on 15/7/17.
//  Copyright (c) 2015年 HG. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

//菊花等待
+(MBProgressHUD *)showInView:(UIView *)contentView message:(NSString *)msg{

    if (!contentView) contentView = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:contentView animated:NO];
    hud.labelText = msg;
    hud.margin = 20.0;
    hud.yOffset = -50;
    
    return hud;
}

//显示在底部
+(void)showText:(NSString *)msg{
 
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 8.0;
    hud.layer.cornerRadius = 5.0;
    hud.yOffset = 0.0;
    [hud hide:YES afterDelay:1.0];

}
+(void)showError:(NSString *)errorMsg{

    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = errorMsg;
    hud.margin = 8.0;
    hud.layer.cornerRadius = 5.0;
    hud.yOffset = -30;
    [hud hide:YES afterDelay:1.0];


}
+(void)hideAllHUD{
    UIView * view = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}



@end
