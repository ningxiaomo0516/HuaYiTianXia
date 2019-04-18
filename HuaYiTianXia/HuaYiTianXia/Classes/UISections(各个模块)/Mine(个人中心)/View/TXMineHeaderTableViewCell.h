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

@property (nonatomic, strong) UIImageView *imagesViewBG;
/// 总资产
@property (nonatomic, strong) UILabel *totalAssetsLabel;
/// 总资产提示
@property (nonatomic, strong) UILabel *totalAssetsTipsLabel;
/// V积分产
@property (nonatomic, strong) UILabel *vrAssetsLabel;
/// VH积分提示
@property (nonatomic, strong) UILabel *vrAssetsTipsLabel;
/// 竖线
@property (nonatomic, strong) UIView *linerView;
/// AH积分
@property (nonatomic, strong) UILabel *arAssetsLabel;
/// AH积分提示
@property (nonatomic, strong) UILabel *arAssetsTipsLabel;

/// VR View
@property (nonatomic, strong) UIView *vrBoxView;
/// AR View
@property (nonatomic, strong) UIView *arBoxView;
/// 股权 View
@property (nonatomic, strong) UIView *eqBoxView;
/// 竖线
@property (nonatomic, strong) UIView *linersView;
/// 股权
@property (nonatomic, strong) UILabel *eqAssetsLabel;
/// 股权提示
@property (nonatomic, strong) UILabel *eqAssetsTipsLabel;


@property (nonatomic, strong) TTUserModel *userModel;

@end

NS_ASSUME_NONNULL_END
