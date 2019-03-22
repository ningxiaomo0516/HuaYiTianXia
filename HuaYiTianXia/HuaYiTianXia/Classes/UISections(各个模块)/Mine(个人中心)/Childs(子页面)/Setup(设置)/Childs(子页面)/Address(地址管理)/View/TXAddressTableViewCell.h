//
//  TXAddressTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXAddressTableViewCell : UITableViewCell
/// 图片
@property (nonatomic, strong) UIImageView *imagesView;
/// 右边箭头
@property (nonatomic, strong) UIImageView *imagesArrow;
/// 昵称
@property (nonatomic, strong) UILabel *titleLabel;
/// 电话
@property (nonatomic, strong) UILabel *telLabel;
/// 默认标签
@property (nonatomic, strong) UILabel *defaultLabel;
/// 昵称
@property (nonatomic, strong) UILabel *addressLabel;

@end

NS_ASSUME_NONNULL_END
