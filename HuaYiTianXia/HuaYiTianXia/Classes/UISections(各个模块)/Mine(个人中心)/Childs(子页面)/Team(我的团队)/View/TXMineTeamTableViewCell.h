//
//  TXMineTeamTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/23.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXMineTeamModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TXMineTeamTableViewCell : UITableViewCell
/// 图片(头像)
@property (nonatomic, strong) UIImageView *imagesAvatar;
/// 用户名字
@property (nonatomic, strong) UILabel *usernameLabel;
/// 我
@property (nonatomic, strong) UILabel *mineLabel;
/// 电话
@property (nonatomic, strong) UILabel *telphoneLabel;
/// 投保金额
@property (nonatomic, strong) UILabel *insuredLabel;

@property (nonatomic, strong) MineTeamModel *teamModel;
@end

NS_ASSUME_NONNULL_END
