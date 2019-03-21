//
//  TXTeamTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTeamTableViewCell : UITableViewCell
/// 昵称
@property (nonatomic, strong) UILabel *titleLabel;
/// 图片
@property (nonatomic, strong) UIImageView *imagesView;
/// UID
@property (nonatomic, strong) UILabel *kidLabel;
/// 手机号码
@property (nonatomic, strong) UILabel *telLabel;

@end

NS_ASSUME_NONNULL_END
