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


@interface TXTeamTableViewCell : UITableViewCell
/// 排名图片
@property (nonatomic, strong) UIImageView *imagesRanking;
/// 排名数字
@property (nonatomic, strong) UILabel *labelRanking;
/// 团队名称
@property (nonatomic, strong) UILabel *teamnameLabel;
/// 团长名称
@property (nonatomic, strong) UILabel *leadershipLabel;
/// 团队创建日期
@property (nonatomic, strong) UILabel *dateLabel;
/// 加入按钮
@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) TeamModel *teamModel;
@end

NS_ASSUME_NONNULL_END
