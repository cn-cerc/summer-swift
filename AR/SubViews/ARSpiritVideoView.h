//
//  ARSpiritVideoView.h
//  5G精灵
//
//  Created by YangTengJiao on 2019/7/9.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^ARSpiritVideoViewBlock)(NSString * _Nonnull type);

NS_ASSUME_NONNULL_BEGIN

@interface ARSpiritVideoView : UIView
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timerIndex;
@property (nonatomic, assign) float centerRadius;
@property (nonatomic, copy) ARSpiritVideoViewBlock arSpiritVideoBlock;
@property (nonatomic, assign) BOOL isRecoding;


- (void)showView;
- (void)hiddenView;

- (void)startTimer;
- (void)stopTimer;

@end

NS_ASSUME_NONNULL_END
