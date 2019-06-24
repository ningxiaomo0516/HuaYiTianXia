//
//  TXClubRecommendedTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXMallClubModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TXClubRecommendedTableViewCell : UITableViewCell
/// 图片
@property (nonatomic, strong) UIImageView *imagesView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 副标题(内容)
@property (nonatomic, strong) UILabel *subtitleLabel;
/// 价格
@property (nonatomic, strong) UILabel *priceLabel;
/// 付款人数
@property (nonatomic, strong) UILabel *numLabel;
/// 购买按钮
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) MallClubListModel *listModel;

@end

NS_ASSUME_NONNULL_END
