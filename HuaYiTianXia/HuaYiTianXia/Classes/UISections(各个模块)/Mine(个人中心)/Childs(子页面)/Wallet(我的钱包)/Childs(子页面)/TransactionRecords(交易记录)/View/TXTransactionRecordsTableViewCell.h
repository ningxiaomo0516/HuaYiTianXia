//
//  TXTransactionRecordsTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXWalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXTransactionRecordsTableViewCell : UITableViewCell
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 副标题
@property (nonatomic, strong) UILabel *subtitleLabel;
/// 价钱
@property (nonatomic, strong) UILabel *priceLabel;
/// 日期
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) WalletModel *model;
@end

NS_ASSUME_NONNULL_END
