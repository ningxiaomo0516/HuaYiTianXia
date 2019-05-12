//
//  TTMallTemplateAdCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/12.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomMarginLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMallTemplateAdCollectionViewCell : UICollectionViewCell
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 图片
@property (nonatomic, strong) UIImageView *imagesView;
/// 活动(副标题)
@property (nonatomic, strong) UILabel *subtitleLabel;
/// 精选活动(结束)
@property (nonatomic, strong) SCCustomMarginLabel *endAdLabel;
/// 精选活动(标签)
@property (nonatomic, strong) UIImageView *imagesViewAd;
@end

NS_ASSUME_NONNULL_END
