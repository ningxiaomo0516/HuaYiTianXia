//
//  TXMineHeaderTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXMineHeaderTableViewCell : UITableViewCell
/// 总资产
@property (nonatomic, strong) UILabel *totalAssetsLabel;
/// 总资产提示
@property (nonatomic, strong) UILabel *totalAssetsTipsLabel;

/// V积分产
@property (nonatomic, strong) UILabel *vhAssetsLabel;
/// VH积分标题
@property (nonatomic, strong) UILabel *vhAssetsTipsLabel;
/// 提示是否可用
@property (nonatomic, strong) UILabel *vhAssetsTips;

/// AH积分
@property (nonatomic, strong) UILabel *ahAssetsLabel;
/// AH积分标题
@property (nonatomic, strong) UILabel *ahAssetsTipsLabel;
/// 提示是否可用
@property (nonatomic, strong) UILabel *ahAssetsTips;

/// VR View
@property (nonatomic, strong) UIView *vhBoxView;
/// AR View
@property (nonatomic, strong) UIView *ahBoxView;
/// 股权 View
@property (nonatomic, strong) UIView *eqBoxView;
/// 股权
@property (nonatomic, strong) UILabel *eqAssetsLabel;
/// 股权标题
@property (nonatomic, strong) UILabel *eqAssetsTipsLabel;
/// 提示是否可用
@property (nonatomic, strong) UILabel *eqAssetsTips;


@property (nonatomic, strong) TTUserModel *userModel;

@end

NS_ASSUME_NONNULL_END
