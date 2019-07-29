//
//  TJAVplayer.h
//  NKAVPlayer
//
//  Created by YangTengJiao on 2019/5/20.
//  Copyright © 2019 聂宽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TJAVPlayerControlView.h"
#import "TJDefine.h"

typedef void(^TJAVplayerViewPlayOverBlock)(NSString * _Nullable type);
typedef void(^TJAVplayerViewBlock)(NSString * _Nullable type);


NS_ASSUME_NONNULL_BEGIN

@interface TJAVplayerView : UIView
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *avPlayer;

@property (nonatomic, strong) TJAVPlayerControlView *controlView;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, assign) BOOL isNoUI;
@property (nonatomic, copy) TJAVplayerViewPlayOverBlock overBlock;
@property (nonatomic, assign) BOOL isPlayAgain;
@property (nonatomic, strong) UIButton *voiceButton;

@property (nonatomic, copy) TJAVplayerViewBlock viewBlock;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

/*
 初始化传入item 立即播放
 */
- (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem;
- (void)settingPlayerItemWithUrl:(NSURL *)playerUrl;
- (void)settingPlayerItem:(AVPlayerItem *)playerItem;
- (void)removeSelf;

@end

NS_ASSUME_NONNULL_END
