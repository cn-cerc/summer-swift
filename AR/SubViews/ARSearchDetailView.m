//
//  ARSearchDetailView.m
//  5G精灵
//
//  Created by YangTengJiao on 2019/7/18.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARSearchDetailView.h"

@implementation ARSearchDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatSubView];
    }
    return self;
}
- (void)creatSubView {
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 304, 87)];
    [self.bgImageView setImage:kGetImage(@"deatil_bg")];
    [self addSubview:self.bgImageView];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 13, 304-13-13, 13)];
    self.titleLabel.font = MediumFontTJ(13);
    self.titleLabel.textColor = RGBTJ(247, 251, 255);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    self.adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 40, 304-13-13, 30)];
    self.adressLabel.font = RegularFontTJ(12);
    self.adressLabel.textColor = RGBTJ(247, 251, 255);
    self.adressLabel.numberOfLines = 0;
    [self addSubview:self.adressLabel];
}

- (void)showViewWith:(NSString *)title address:(NSString *)address {
    self.hidden = NO;
    self.titleLabel.text = title;
    self.adressLabel.text = address;
}

- (void)hiddenView {
    self.hidden = YES;
}



@end
