//
//  TXMallGoodsBannerTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//typedef void(^TXMineBannerTableViewCellCallBlock)(PVVideoListModel* videoListModel);
typedef void(^TXMallGoodsBannerTableViewCellCallBlock)(NSInteger idx);

@interface TXMallGoodsBannerTableViewCell : UITableViewCell

- (void)setImagesDidOnClickCallBlock:(TXMallGoodsBannerTableViewCellCallBlock)block;

@end

NS_ASSUME_NONNULL_END
