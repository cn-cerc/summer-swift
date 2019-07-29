//
//  TJAVPlayerControlView.h
//  NKAVPlayer
//
//  Created by YangTengJiao on 2019/5/20.
//  Copyright © 2019 聂宽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"

typedef void(^TJAVPlayerControlViewBlock)(NSString * _Nullable type,NSString * _Nullable info);

NS_ASSUME_NONNULL_BEGIN

@interface TJAVPlayerControlView : UIView
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *progressBgView;
@property (nonatomic, strong) UIImageView *progressTopView;
@property (nonatomic, strong) UIImageView *slipView;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *allTimeLabel;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) TJAVPlayerControlViewBlock controlViewBlock;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isSliping;

- (void)showPlayView;
- (void)showPauseView;
- (void)showProgressWith:(float)currentTime duration:(float)duration progress:(float)progress;




@end

NS_ASSUME_NONNULL_END
