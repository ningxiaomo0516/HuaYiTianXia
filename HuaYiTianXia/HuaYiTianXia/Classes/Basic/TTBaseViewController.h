//
//  TTBaseViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLoadFailedView.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTBaseViewController : UIViewController

/// 给当前view添加识别手势,点击tableView中带有输入框点击背景关闭键盘
- (void) addGesture:(UITableView *) tableView;
/// 点击View关闭 输入框
- (void) tapGesture;
- (void) setupNavigationBarTheme;
/// 网络问题
@property (nonatomic, strong) SCLoadFailedView *loadFailedView;
/// 无数据的情况
@property (nonatomic, strong) SCNoDataView *noDataView;
/// 点击重新加载数据
- (void) reminderData;
@end

NS_ASSUME_NONNULL_END
