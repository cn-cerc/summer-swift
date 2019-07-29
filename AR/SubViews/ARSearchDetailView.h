//
//  ARSearchDetailView.h
//  5G精灵
//
//  Created by YangTengJiao on 2019/7/18.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARSearchDetailView : UIView
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *adressLabel;

- (void)showViewWith:(NSString *)title address:(NSString *)address;
- (void)hiddenView;

@end

NS_ASSUME_NONNULL_END
