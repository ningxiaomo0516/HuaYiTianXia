//
//  TXRolloutHeaderTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/15.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXRolloutHeaderTableViewCell : UITableViewCell
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
@end

NS_ASSUME_NONNULL_END
