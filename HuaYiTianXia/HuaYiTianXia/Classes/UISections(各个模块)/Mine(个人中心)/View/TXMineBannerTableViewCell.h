//
//  TXMineBannerTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef void(^TXMineBannerTableViewCellCallBlock)(PVVideoListModel* videoListModel);
typedef void(^TXMineBannerTableViewCellCallBlock)(NSInteger idx);

@interface TXMineBannerTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *boxView;
- (void)setImagesDidOnClickCallBlock:(TXMineBannerTableViewCellCallBlock)block;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@end

NS_ASSUME_NONNULL_END
