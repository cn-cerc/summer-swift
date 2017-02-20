//
//  lhScanQCodeViewController.h
//  lhScanQCodeTest
//
//  Created by bosheng on 15/10/20.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseOCViewController.h"

@protocol lhScanQCodeViewController <NSObject>

-(void)scanCodeReturn:(NSString *)urlStr;

@end

@interface lhScanQCodeViewController : BaseOCViewController

@property (nonatomic,strong)id<lhScanQCodeViewController> delegate;

@end
