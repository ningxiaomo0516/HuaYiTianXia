//
//  TXBannerCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/21.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXNewsModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^TTBannerViewCellCallBlock)(NSInteger idx);
@interface TXBannerCollectionViewCell : UICollectionViewCell
/// 方块视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取方块视图对象
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

- (void)setBannerImagesDidOnClickCallBlock:(TTBannerViewCellCallBlock)block;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, assign) BOOL isPageControl;

@end

@interface TTBannerViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView       *imagesView;
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UIView            *boxView;
@property (nonatomic, strong) UIImageView       *imagesViewBottom;
@property (nonatomic, strong) UILabel           *countLabel;
@property (nonatomic, strong) NewsBannerModel   *bannerModel;
@end
NS_ASSUME_NONNULL_END
