//
//  TTBaseNavImagesTableViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseNavImagesViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTBaseNavImagesTableViewController : TTBaseNavImagesViewController
/// 给当前view添加识别手势,点击tableView中带有输入框点击背景关闭键盘
- (void) addGesture:(UITableView *) tableView;

@end

NS_ASSUME_NONNULL_END
