//
//  ARSpiritVoiceTextView.h
//  5G精灵
//
//  Created by YangTengJiao on 2019/7/16.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARSpiritVoiceTextView : UIView
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) UILabel *voiceLabel;

- (void)showViewWithVoice:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
