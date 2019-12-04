//
//  TXMineHeaderView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXMineHeaderView : UIView
/// 头像
@property (nonatomic, strong) UIImageView   *imagesViewAvatar;
/// 头像背景
@property (nonatomic, strong) UIImageView   *avatarView;
/// 背景图
@property (nonatomic, strong) UIImageView   *imagesView_BG;
/// 用户昵称
@property (nonatomic, strong) UILabel       *nicknameLabel;
/// 等级图标
@property (nonatomic, strong) UIImageView   *images_level;
/// 等级图标
//@property (nonatomic, strong) UILabel *levelLabel;
/// 升级按钮
@property (nonatomic, strong) UIButton *upgradeButton;
/// 公司名称(公司人数)
@property (nonatomic, strong) UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
