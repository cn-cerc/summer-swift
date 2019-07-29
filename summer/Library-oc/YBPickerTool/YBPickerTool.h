//
//  YBAreaPickerView.h
//  XHGY_Agent
//
//  Created by 尚往文化 on 17/6/9.
//  Copyright © 2017年 YBing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YBPickerDidSelectBlock)(NSIndexPath *indexPath);
typedef void(^YBPickerDidCancelBlock)();

@interface YBPickerTool : UIPickerView
@property (nonatomic, assign) NSInteger selectedIndex;
+ (void)show:(NSArray<NSArray<NSString *> *> *)datas didSelectBlock:(YBPickerDidSelectBlock)didSelectBlock didCancelBlock:(YBPickerDidCancelBlock)didCancelBlock;

@end
