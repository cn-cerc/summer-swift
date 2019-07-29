//
//  ARSpiritVideoView.m
//  5G精灵
//
//  Created by YangTengJiao on 2019/7/9.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARSpiritVideoView.h"
#define kCenterWidth 65
#define kLineWidth 5.0
#define kPointLong 35
#define kPointSort 25
#define kTimerIndexMax 300.0


@implementation ARSpiritVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        self.progress = 0.0;
        self.timerIndex = 0;
        self.centerRadius = kPointLong;
        [self creatSubView];
    }
    return self;
}
- (void)creatSubView {
    self.backgroundColor = [UIColor clearColor];
    
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.centerButton.frame = self.bounds;
    [self.centerButton addTarget:self action:@selector(centerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.centerButton];
    
    [self reloadProgress:0.0];
}

- (void)showView {
    self.hidden = NO;
}
- (void)hiddenView {
    self.hidden = YES;
}


- (void)centerButtonAction {
    if (self.isRecoding) {
        [self stopTimer];
    } else {
        [self startTimer];
    }
}

-(void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 保存初始状态
    CGContextSaveGState(context);
    // 绘制图片
    UIImage *image = kGetImage(@"videobg");
    CGRect rectImage = CGRectMake(0, 0, kCenterWidth, kCenterWidth);
    [image drawInRect:rectImage];
    // 恢复到初始状态
    CGContextRestoreGState(context);
    
    UIBezierPath * path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kCenterWidth/2.0, kCenterWidth/2.0) radius:self.centerRadius/2.0 startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
    [[UIColor whiteColor] setFill];
    [path2 fill];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    CGFloat startA = - M_PI_2; //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2.0 * self.progress; //圆终点位置
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kCenterWidth/2.0, kCenterWidth/2.0) radius:kCenterWidth/2.0-kLineWidth/2.0 startAngle:startA endAngle:endA clockwise:YES];
    CGContextSetLineWidth(ctx,kLineWidth); //设置线条宽度
    [RGBTJ(255, 255, 255) setStroke];
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    CGContextStrokePath(ctx); //渲染
}

- (void)reloadProgress:(CGFloat )progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"progress %lf",progress);
        self.progress = progress;
        [self setNeedsDisplay];
    });
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerRunAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
- (void)startTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isRecoding = YES;
        self.timerIndex = 0;
        self.centerRadius = kPointSort;
        [self.timer setFireDate:[NSDate distantPast]];
        if (self.arSpiritVideoBlock) {
            self.arSpiritVideoBlock(@"start");
        }
    });
}
- (void)stopTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isRecoding = NO;
        self.centerRadius = kPointLong;
        [self.timer setFireDate:[NSDate distantFuture]];
        self.timerIndex = 0;
        [self reloadProgress:0.0];
        if (self.arSpiritVideoBlock) {
            self.arSpiritVideoBlock(@"over");
        }
    });
}
- (void)timerRunAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timerIndex += 1;
        if (self.timerIndex >= kTimerIndexMax) {
            [self stopTimer];
        } else {
            [self reloadProgress:self.timerIndex/kTimerIndexMax];
        }
    });
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
