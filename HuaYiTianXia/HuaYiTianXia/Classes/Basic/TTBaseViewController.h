//
//  TTBaseViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTBaseViewController : UIViewController

/// 给当前view添加识别手势,点击tableView中带有输入框点击背景关闭键盘
- (void) addGesture:(UITableView *) tableView;
/// 点击View关闭 输入框
- (void) tapGesture;
- (void) setupNavigationBarTheme;
@end

NS_ASSUME_NONNULL_END
