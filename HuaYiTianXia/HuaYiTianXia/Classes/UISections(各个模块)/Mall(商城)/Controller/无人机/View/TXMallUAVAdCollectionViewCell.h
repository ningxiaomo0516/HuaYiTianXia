//
//  TXMallUAVAdCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomMarginLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXMallUAVAdCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imagesView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) MallUAVListModel *model;
@property (nonatomic, strong) UIImageView *imagesViewAd;
/// 精选活动(结束)
@property (nonatomic, strong) SCCustomMarginLabel *endAdLabel;
@end

NS_ASSUME_NONNULL_END
