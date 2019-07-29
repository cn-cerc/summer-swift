//
//  ARSearchView.h
//  5G精灵
//
//  Created by YangTengJiao on 2019/7/8.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJDefine.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ARSearchViewBlock)(NSString *text);

@interface ARSearchView : UIView
@property (nonatomic, strong) UIImageView *topBgImageView;
@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, strong) UIImageView *searchBgImageView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIView *typeView;
@property (nonatomic, strong) UIImageView *typebgImageView;

@property (nonatomic, strong) NSArray *testArray;

@property (nonatomic, copy) ARSearchViewBlock searchBlock;

- (void)showView;
- (void)hiddenView;


@end

NS_ASSUME_NONNULL_END
