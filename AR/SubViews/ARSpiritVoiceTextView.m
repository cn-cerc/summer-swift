//
//  ARSpiritVoiceTextView.m
//  5G精灵
//
//  Created by YangTengJiao on 2019/7/16.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARSpiritVoiceTextView.h"

@implementation ARSpiritVoiceTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        [self creatSubView];
    }
    return self;
}
// 70 20 12

- (void)creatSubView {
    self.backgroundColor = [UIColor clearColor];
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 309, 80)];
    [self.bgImageView setImage:kGetImage(@"toastbg")];
    [self addSubview:self.bgImageView];
    self.bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(36, 70, 20, 12)];
    [self.bottomImageView setImage:kGetImage(@"jiantou")];
    [self addSubview:self.bottomImageView];
    self.voiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 309-15-15, 80-15-15)];
    self.voiceLabel.numberOfLines = 0.0;
    self.voiceLabel.textColor = [UIColor whiteColor];
    self.voiceLabel.font = FontTJ(13);
    [self addSubview:self.voiceLabel];
}

- (void)showViewWithVoice:(NSString *)text {
    self.hidden = NO;
    self.voiceLabel.text = text;
}

@end
