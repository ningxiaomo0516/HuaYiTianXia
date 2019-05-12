//
//  TTTemplateThreeCollectionViewCell.h
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/12/10.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXMallUAVModel.h"
#import "SCCustomMarginLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTTemplateThreeCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imagesView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) TXMallUAVModel *model;
@property (nonatomic, strong) UIImageView *imagesViewAd;
/// 精选活动(结束)
@property (nonatomic, strong) SCCustomMarginLabel *endAdLabel;
@end

NS_ASSUME_NONNULL_END
