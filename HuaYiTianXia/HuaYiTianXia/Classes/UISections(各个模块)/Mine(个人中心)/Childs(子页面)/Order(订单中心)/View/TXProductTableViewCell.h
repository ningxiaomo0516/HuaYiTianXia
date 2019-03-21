//
//  TXProductTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXProductTableViewCell : UITableViewCell
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 图片
@property (nonatomic, strong) UIImageView *imagesView;
/// 内容
@property (nonatomic, strong) UILabel *contentLabel;
/// 价格
@property (nonatomic, strong) UILabel *priceLabel;
/// 日期时间
@property (nonatomic, strong) UILabel *dateTimeLabel;
@end

NS_ASSUME_NONNULL_END
