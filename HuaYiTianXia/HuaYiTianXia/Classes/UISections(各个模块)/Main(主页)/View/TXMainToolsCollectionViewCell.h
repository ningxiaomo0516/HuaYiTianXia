//
//  TXMainToolsCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/9/4.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXMainToolsCollectionViewCell : UICollectionViewCell
/// 方块视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取方块视图对象
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) UIImageView *imagesView;
@end

NS_ASSUME_NONNULL_END
