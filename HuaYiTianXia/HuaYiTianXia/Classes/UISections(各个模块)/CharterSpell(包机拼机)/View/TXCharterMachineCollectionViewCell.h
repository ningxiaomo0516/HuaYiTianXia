//
//  TXCharterMachineCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/31.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomMarginLabel.h"
#import "TXCharterMachineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXCharterMachineCollectionViewCell : UICollectionViewCell
/// 分割线
@property (nonatomic, strong) UIView *liner_l_view;
/// 分割线
@property (nonatomic, strong) UIView *liner_r_view;

/// 出发城市
@property (nonatomic, strong) UILabel *dep_city_label;
/// 出发机场
@property (nonatomic, strong) UILabel *dep_airport_label;
/// 到达城市
@property (nonatomic, strong) UILabel *arv_city_label;
/// 到达机场
@property (nonatomic, strong) UILabel *arv_airport_label;
/// 挑战者昵称
@property (nonatomic, strong) UILabel *challengerLabel;
/// 时长
@property (nonatomic, strong) UILabel *durationLabel;
/// 价格
@property (nonatomic, strong) SCCustomMarginLabel *priceLabel;
/// 图片
@property (nonatomic, strong) UIImageView *imagesView;

@property (nonatomic, strong) CharterMachineModel *machineModel;
@end

NS_ASSUME_NONNULL_END
