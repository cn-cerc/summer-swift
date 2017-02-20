//
//  lhScanQCodeViewController.h
//  lhScanQCodeTest
//
//  Created by bosheng on 15/10/20.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseOCViewController.h"
#import <TesseractOCR/TesseractOCR.h>

@protocol ScanViewController <NSObject>

-(void)scanCardReturn:(NSString *)urlStr;

-(void)backBar;

@end

@interface ScanViewController : BaseOCViewController<G8TesseractDelegate>

@property (nonatomic,weak)id<ScanViewController> delegate;

@end
