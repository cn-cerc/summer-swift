//
//  TJAVPlayerControlView.m
//  NKAVPlayer
//
//  Created by YangTengJiao on 2019/5/20.
//  Copyright © 2019 聂宽. All rights reserved.
//

#import "TJAVPlayerControlView.h"
#define kProgressBgViewWidth (self.bounds.size.width-18-66)
#define KSlipViewSize 20

@interface TJAVPlayerControlView()

@end


@implementation TJAVPlayerControlView

- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton setImage:kGetImage(@"play") forState:UIControlStateNormal];
        _bgButton.frame = self.bounds;
        [_bgButton addTarget:self action:@selector(bgButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}
- (void)bgButtonAction {
    self.isPlaying = !self.isPlaying;
    if (self.isPlaying) {
        [_bgButton setImage:kGetImage(@"") forState:UIControlStateNormal];
        if (self.controlViewBlock) {
            self.controlViewBlock(@"play", nil);
        }
    } else {
        [_bgButton setImage:kGetImage(@"play") forState:UIControlStateNormal];
        if (self.controlViewBlock) {
            self.controlViewBlock(@"pause", nil);
        }
    }
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:kGetImage(@"返回") forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(20, kStatusBarHeight, 40, 40);
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (void)backButtonAction {
    if (self.controlViewBlock) {
        self.controlViewBlock(@"back", nil);
    }
}

- (UIImageView *)progressBgView {
    if (!_progressBgView) {
        _progressBgView = [[UIImageView alloc] initWithFrame:CGRectMake(18, self.bounds.size.height-(KIsiPhoneX?54:43), kProgressBgViewWidth, 4)];
        _progressBgView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.63];
        _progressBgView.clipsToBounds = YES;
    }
    return _progressBgView;
}
- (UIImageView *)progressTopView {
    if (!_progressTopView) {
        _progressTopView = [[UIImageView alloc] initWithFrame:CGRectMake(-kProgressBgViewWidth, 0, kProgressBgViewWidth, 4)];
        [_progressTopView setImage:kGetImage(@"进度条-渐变")];
    }
    return _progressTopView;
}
- (UIImageView *)slipView {
    if (!_slipView) {
        _slipView = [[UIImageView alloc] initWithFrame:CGRectMake(18-2, self.bounds.size.height-(KIsiPhoneX?54:43), KSlipViewSize, KSlipViewSize)];
        _slipView.userInteractionEnabled = YES;
        _slipView.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_slipView addGestureRecognizer:recognizer];
    }
    return _slipView;
}
#pragma mark - 处理手势操作
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    self.isSliping = YES;
    CGPoint translation = [recognizer translationInView:self.progressBgView];
    CGFloat moveX = translation.x;
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.slipView];
    CGFloat centerX = self.slipView.center.x + moveX;
    float progress = (centerX-self.progressBgView.frame.origin.x)/self.progressBgView.frame.size.width;
    self.slipView.center = CGPointMake(centerX, self.progressBgView.center.y);
    self.progressTopView.frame = CGRectMake(kProgressBgViewWidth*(progress-1), 0, kProgressBgViewWidth, 4);
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.controlViewBlock) {
            self.controlViewBlock(@"slip", [NSString stringWithFormat:@"%f",progress]);
        }
    }
}
- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2.0-48/2.0, self.bounds.size.height-(KIsiPhoneX?54:43)-4-10-18, 48, 18)];
        _currentTimeLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.28];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.font = FontTJ(12);
        _currentTimeLabel.textColor = [UIColor whiteColor];
    }
    return _currentTimeLabel;
}
- (UILabel *)allTimeLabel {
    if (!_allTimeLabel) {
        _allTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-16-41, self.bounds.size.height-(KIsiPhoneX?54:43)-4-5, 41, 18)];
        _allTimeLabel.font = FontTJ(12);
        _allTimeLabel.textColor = [UIColor whiteColor];
    }
    return _allTimeLabel;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self addSubview:self.bgButton];
        [self addSubview:self.backButton];
        [self addSubview:self.progressBgView];
        [self.progressBgView addSubview:self.progressTopView];
        [self addSubview:self.slipView];
        [self addSubview:self.currentTimeLabel];
        [self addSubview:self.allTimeLabel];
    }
    return self;
}
- (void)showPlayView {
    [_bgButton setImage:kGetImage(@"") forState:UIControlStateNormal];
}
- (void)showPauseView {
    [_bgButton setImage:kGetImage(@"play") forState:UIControlStateNormal];
}
- (void)showProgressWith:(float)currentTime duration:(float)duration progress:(float)progress {
    if (duration > 0) {
        if (self.isSliping) {
            return;
        }
        self.progress = progress;
        self.currentTimeLabel.text = [self getMMSSFromSS:currentTime];
        self.allTimeLabel.text = [self getMMSSFromSS:duration];
        self.progressTopView.frame = CGRectMake(kProgressBgViewWidth*(self.progress-1), 0, kProgressBgViewWidth, 4);
        self.slipView.center = CGPointMake(self.progressBgView.frame.origin.x+self.progressBgView.frame.size.width*self.progress, self.progressBgView.center.y);
    }
}
    
- (NSString *)getMMSSFromSS:(NSInteger )seconds{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    if ([str_hour integerValue] > 0) {
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }
    return format_time;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgButton.frame = self.bounds;
    self.backButton.frame = CGRectMake(20, kStatusBarHeight, 40, 40);
    self.progressBgView.frame = CGRectMake(18, self.bounds.size.height-(KIsiPhoneX?54:43), self.bounds.size.width-18-66, 4);
    self.progressTopView.frame = CGRectMake(kProgressBgViewWidth*(self.progress-1)-18-66, 0, kProgressBgViewWidth, 4);
    self.currentTimeLabel.frame = CGRectMake(self.bounds.size.width/2.0-48/2.0, self.bounds.size.height-(KIsiPhoneX?54:43)-4-10-18, 48, 18);
    self.allTimeLabel.frame = CGRectMake(self.bounds.size.width-16-41, self.bounds.size.height-(KIsiPhoneX?54:43)-4-5, 41, 18);
}
- (void)dealloc
{
//    [_timer invalidate];
//    _timer = nil;
}

@end
