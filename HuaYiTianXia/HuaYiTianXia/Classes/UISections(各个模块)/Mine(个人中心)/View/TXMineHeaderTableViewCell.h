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
/// VH资产
@property (nonatomic, strong) UILabel *vrAssetsLabel;
/// VH资产提示
@property (nonatomic, strong) UILabel *vrAssetsTipsLabel;
/// 竖线
@property (nonatomic, strong) UIView *linerView;
/// AH资产
@property (nonatomic, strong) UILabel *arAssetsLabel;
/// AH资产提示
@property (nonatomic, strong) UILabel *arAssetsTipsLabel;


@property (nonatomic, strong) UIView *vrBoxView;
@property (nonatomic, strong) UIView *arBoxView;

@end

NS_ASSUME_NONNULL_END
