//
//  TXMallCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXNewsModel.h"
#import "SCDeleteLineLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXMallCollectionViewCell : UICollectionViewCell
/// 图片
@property (nonatomic, strong) UIImageView *imagesView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 副标题(内容)
@property (nonatomic, strong) UILabel *subtitleLabel;
/// 原始价格
@property (nonatomic, strong) SCDeleteLineLabel *marketPriceLabel;
/// 当前价格
@property (nonatomic, strong) UILabel *currentPriceLabel;

@property (nonatomic, strong) NewsRecordsModel *recordsModel;

@end

NS_ASSUME_NONNULL_END
