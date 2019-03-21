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
/// Nav背景
@property (nonatomic, strong) UIImageView *imagesView;
/// 用户头像
@property (nonatomic, strong) UIImageView *imagesViewAvatar;
/// 用户昵称
@property (nonatomic, strong) UILabel *nickNameLabel;
/// 用户ID
@property (nonatomic, strong) UILabel *kidLabel;
/// 会员等级
@property (nonatomic, strong) UILabel *levelLabel;

/// 外层View
@property (nonatomic, strong) UIView *boxView;

@end

NS_ASSUME_NONNULL_END
