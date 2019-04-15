//
//  TXBuyCountTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomMarginLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXBuyCountTableViewCell : UITableViewCell
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 商城里面详情的购买数量
@property (nonatomic, strong) SCCustomMarginLabel *buyNumLabel;
/// 减少按钮
@property (nonatomic, strong) UIButton *minusBtn;
/// 增加按钮
@property (nonatomic, strong) UIButton *increaseBtn;
/// 盒子View
@property (nonatomic, strong) UIView *boxView;

/// 农业植保页面详情的购买数量
@property (nonatomic, strong) SCCustomMarginLabel *buyCountLabel;
@end

NS_ASSUME_NONNULL_END
