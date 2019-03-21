//
//  TXMallBannerCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TXMallBannerCollectionViewCellCallBlock)(NSInteger idx);

@interface TXMallBannerCollectionViewCell : UICollectionViewCell

- (void)setBannerImagesDidOnClickCallBlock:(TXMallBannerCollectionViewCellCallBlock)block;


@end

NS_ASSUME_NONNULL_END
