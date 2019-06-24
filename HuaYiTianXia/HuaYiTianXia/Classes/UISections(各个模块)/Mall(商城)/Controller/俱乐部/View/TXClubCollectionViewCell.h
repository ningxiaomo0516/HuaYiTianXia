//
//  TXClubCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/21.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXClubCollectionViewCell : UICollectionViewCell
/// 方块视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取方块视图对象
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

/// 图片
@property (nonatomic, strong) UIImageView   *imagesView;
/// 标题
@property (nonatomic, strong) UILabel       *titleLabel;
/// 内容
@property (nonatomic, strong) UILabel       *subtitleLabel;
/// 价格
@property (nonatomic, strong) UILabel       *priceLabel;
/// 数据
@property (nonatomic, strong) MallClubListModel *model;
@end

NS_ASSUME_NONNULL_END
