//
//  TXBecomeVipCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/23.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomMarginLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXBecomeVipCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imagesView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) SCCustomMarginLabel *identityLabel;
@property (nonatomic, strong) UIView *boxView;

- (void)setChecked:(BOOL)checked isClick:(BOOL)isClick;
@end

NS_ASSUME_NONNULL_END
