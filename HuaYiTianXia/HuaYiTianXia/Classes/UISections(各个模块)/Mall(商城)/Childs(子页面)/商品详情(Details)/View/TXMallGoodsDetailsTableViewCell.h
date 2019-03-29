//
//  TXMallGoodsDetailsTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXMallGoodsDetailsTableViewCell : UITableViewCell
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 副标题内容
@property (nonatomic, strong) UILabel *subtitleLabel;
/// 价格
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) NewsRecordsModel *model;

@end

NS_ASSUME_NONNULL_END
