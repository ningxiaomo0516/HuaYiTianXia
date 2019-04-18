//
//  TXMineTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXMineTableViewCell : UITableViewCell
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 副标题
@property (nonatomic, strong) UILabel *subtitleLabel;
/// 图片(头像)
@property (nonatomic, strong) UIImageView *imagesAvatar;
/// 右边箭头
@property (nonatomic, strong) UIImageView *imagesArrow;
/// 分割线
@property (nonatomic, strong) UIView *linerView;
@end

NS_ASSUME_NONNULL_END
