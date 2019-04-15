//
//  TXShoppingTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXShoppingTableViewCell : UITableViewCell

/// 产品图片
@property (nonatomic, strong) UIImageView *imagesView;
/// 产品标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 产品规格
@property (nonatomic, strong) UILabel *specLabel;
/// 产品内容
@property (nonatomic, strong) UILabel *subtitleLabel;
/// 产品价格
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) NewsRecordsModel *model;
@end

NS_ASSUME_NONNULL_END
