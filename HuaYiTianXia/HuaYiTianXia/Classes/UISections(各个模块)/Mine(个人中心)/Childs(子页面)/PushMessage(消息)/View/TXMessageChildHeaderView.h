//
//  TXMessageChildHeaderView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/30.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXMessageChildHeaderView : UIView
/// 头像
@property (nonatomic, strong) UIImageView *imagesViewAvatar;
/// 用户昵称
@property (nonatomic, strong) UILabel *nicknameLabel;
/// 转账金额
@property (nonatomic, strong) UILabel *amountLabel;
/// 转账状态
@property (nonatomic, strong) UILabel *statusLabel;
@end

NS_ASSUME_NONNULL_END
