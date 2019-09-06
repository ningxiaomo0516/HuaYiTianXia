//
//  TXMainCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/9/4.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomMarginLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXMainCollectionViewCell : UICollectionViewCell
/// 方块视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取方块视图对象
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

/// 到达城市
@property (nonatomic, strong) UILabel *arvCityLabel;
/// 出发城市
@property (nonatomic, strong) UILabel *depCityLabel;
/// 飞机图片
@property (nonatomic, strong) UIImageView *imagesPlane;
/// 大图
@property (nonatomic, strong) UIImageView *imagesView;
/// 价格
@property (nonatomic, strong) UILabel *priceLabel;
/// 日期时间
@property (nonatomic, strong) UILabel *datetimeLabel;
/// 折扣
@property (nonatomic, strong) SCCustomMarginLabel *discountLabel;
@end

NS_ASSUME_NONNULL_END
