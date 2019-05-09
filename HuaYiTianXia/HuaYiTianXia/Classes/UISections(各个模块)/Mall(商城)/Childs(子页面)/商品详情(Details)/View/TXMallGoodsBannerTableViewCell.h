//
//  TXMallGoodsBannerTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TXMallGoodsBannerTableViewCellCallBlock)(NewsBannerModel *bannerModel);

@interface TXMallGoodsBannerTableViewCell : UITableViewCell

- (void)setImagesDidOnClickCallBlock:(TXMallGoodsBannerTableViewCellCallBlock)block;

@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, assign) BOOL isPageControl;

@end

NS_ASSUME_NONNULL_END
