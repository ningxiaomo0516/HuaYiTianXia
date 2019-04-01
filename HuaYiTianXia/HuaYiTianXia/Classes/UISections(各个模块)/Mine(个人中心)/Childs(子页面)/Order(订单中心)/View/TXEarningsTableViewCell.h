//
//  TXEarningsTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXWalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXEarningsTableViewCell : UITableViewCell
/// 产品名字
@property (nonatomic, strong) UILabel *titleLabel;
/// 日期
@property (nonatomic, strong) UILabel *dateLabel;
/// 价钱
@property (nonatomic, strong) UILabel *priceLabel;
/// 价钱
@property (nonatomic, strong) WalletModel *model;

@end

NS_ASSUME_NONNULL_END
