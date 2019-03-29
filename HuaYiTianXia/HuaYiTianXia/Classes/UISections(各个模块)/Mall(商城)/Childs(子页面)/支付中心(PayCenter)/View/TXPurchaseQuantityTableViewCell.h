//
//  TXPurchaseQuantityTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/27.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomMarginLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXPurchaseQuantityTableViewCell : UITableViewCell
/// 标题
@property (nonatomic, strong) UILabel       *titleLabel;
/// 数量
@property (nonatomic, strong) SCCustomMarginLabel   *quantityLabel;
/// 减
@property (nonatomic, strong) UIButton      *reductionBtn;
/// 加
@property (nonatomic, strong) UIButton      *increaseBtn;

@end

NS_ASSUME_NONNULL_END
