//
//  TXMallGoodsSpecTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomMarginLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXMallGoodsSpecTableViewCell : UITableViewCell
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 标题
@property (nonatomic, strong) SCCustomMarginLabel *subtitleLabel;
@end

NS_ASSUME_NONNULL_END
