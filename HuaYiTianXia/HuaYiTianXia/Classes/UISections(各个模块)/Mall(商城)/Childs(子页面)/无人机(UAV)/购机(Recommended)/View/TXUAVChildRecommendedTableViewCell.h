//
//  TXUAVChildRecommendedTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXRecommendedModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXUAVChildRecommendedTableViewCell : UITableViewCell
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 价钱
@property (nonatomic, strong) UILabel *priceLabel;
/// 付款人数
@property (nonatomic, strong) UILabel *paymentNumLabel;

@property (nonatomic, strong) RecommendChildModel *dataModel;
@end

NS_ASSUME_NONNULL_END
