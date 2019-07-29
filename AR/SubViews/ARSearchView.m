//
//  ARSearchView.m
//  5G精灵
//
//  Created by YangTengJiao on 2019/7/8.
//  Copyright © 2019 YangTengJiao. All rights reserved.
//

#import "ARSearchView.h"

@implementation ARSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    self.topBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenTJWidth, (KIsiPhoneX?104:64))];
    [self.topBgImageView setImage:kGetImage(@"navbar")];
    [self addSubview:self.topBgImageView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, (KIsiPhoneX?60:20), 44, 44);
    [self.backButton setImage:kGetImage(@"return_icon") forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    self.searchBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(44, (KIsiPhoneX?60:20)+6, ScreenTJWidth-44-44, 30)];
    self.searchBgImageView.backgroundColor = [UIColor whiteColor];
    self.searchBgImageView.layer.masksToBounds = YES;
    self.searchBgImageView.layer.cornerRadius = 2;
    [self addSubview:self.searchBgImageView];
    
    self.searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(44+7, (KIsiPhoneX?60:20)+6+7, 16, 16)];
    [self.searchImageView setImage:kGetImage(@"search_icon")];
    [self addSubview:self.searchImageView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(44+30, (KIsiPhoneX?60:20)+6, ScreenTJWidth-44-30-44-10, 30)];
    self.textField.font = FontTJ(14);
    self.textField.placeholder = @"查找地点";
    [self addSubview:self.textField];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.frame = CGRectMake(ScreenTJWidth-44, (KIsiPhoneX?60:20), 44, 44);
    [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    self.searchButton.titleLabel.textColor = [UIColor whiteColor];
    self.searchButton.titleLabel.font = FontTJ(14);
    [self.searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.searchButton];
    
    
    self.typeView = [[UIView alloc] initWithFrame:CGRectMake(0, (KIsiPhoneX?104:64)+20, ScreenTJWidth, 231)];
    self.typeView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.typeView];
    
    self.typebgImageView = [[UIImageView alloc] initWithFrame:self.typeView.bounds];
    [self.typebgImageView setImage:kGetImage(@"bg")];
    [self.typeView addSubview:self.typebgImageView];
    
    NSArray *nameArray = @[@"food_icon",@"hotel_icon",@"supermarkrt_icon",@"bus_icon",@"atm_icon",@"travel_icon",@"house_icon",@"wc_icon"];
    self.testArray = @[@"美食",@"酒店",@"超市",@"公交",@"ATM",@"景点",@"住宅",@"厕所"];
    float width = (ScreenTJWidth-64*4-16*2)/3.0;
    for (NSInteger i = 0; i < self.testArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(16+(i>3?i-4:i)*(width+64), (i>3?111:29), 64, 64);
        [button setImage:kGetImage(nameArray[i]) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [self.typeView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16+(i>3?i-4:i)*(width+64), (i>3?176:94), 64, 13)];
        label.font = FontTJ(13);
        label.textColor = [UIColor whiteColor];
        label.text = self.testArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self.typeView addSubview:label];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
- (void)showView {
    self.hidden = NO;
    [self.textField becomeFirstResponder];
}
- (void)hiddenView {
    self.hidden = YES;
    [self.textField resignFirstResponder];
}
- (void)backButtonAction {
    [self hiddenView];
    if (self.searchBlock) {
        self.searchBlock(nil);
    }
}

- (void)searchButtonAction {
    [self hiddenView];
    if (self.searchBlock) {
        self.searchBlock(self.textField.text);
    }
}
- (void)typeButtonAction:(UIButton *)button {
    [self hiddenView];
    if (self.searchBlock) {
        self.searchBlock(self.testArray[button.tag-100]);
    }
}

@end
