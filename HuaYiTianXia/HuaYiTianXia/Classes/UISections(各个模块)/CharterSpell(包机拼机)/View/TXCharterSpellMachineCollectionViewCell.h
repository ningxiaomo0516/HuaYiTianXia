//
//  TXCharterSpellMachineCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCharterMachineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXCharterSpellMachineCollectionViewCell : UICollectionViewCell
/// 上部分
@property (nonatomic, strong) UIView *boxView;
/// 背景图片
@property (nonatomic, strong) UIImageView *imagesView;
/// 排名图片
@property (nonatomic, strong) UIImageView *imagesRank;
/// 半透明图片
@property (nonatomic, strong) UIImageView *imagesViewBottom;
/// 包机特惠
@property (nonatomic, strong) UILabel *youhuiLabel;
/// 到达城市
@property (nonatomic, strong) UILabel *arvCityLabel;
/// 出发城市
@property (nonatomic, strong) UILabel *depCityLabel;
/// 飞机图片
@property (nonatomic, strong) UIImageView *imagesPlane;


/// 执飞
@property (nonatomic, strong) UILabel *freshLabel_s;
@property (nonatomic, strong) UILabel *freshLabel;
/// 日期
@property (nonatomic, strong) UILabel *dateLabel_s;
@property (nonatomic, strong) UILabel *dateLabel;
/// 时间
@property (nonatomic, strong) UILabel *timeLabel_s;
@property (nonatomic, strong) UILabel *timeLabel;
/// 时长
@property (nonatomic, strong) UILabel *flightTimeLabel_s;
@property (nonatomic, strong) UILabel *flightTimeLabel;





/// 分割线
@property (nonatomic, strong) UIView *linerView;
/// 包机提示
@property (nonatomic, strong) UILabel *charterLabel;
/// 包机价格
@property (nonatomic, strong) UILabel *priceLabel;



@property (nonatomic, strong) CharterMachineModel *machineModel;
@end

NS_ASSUME_NONNULL_END
