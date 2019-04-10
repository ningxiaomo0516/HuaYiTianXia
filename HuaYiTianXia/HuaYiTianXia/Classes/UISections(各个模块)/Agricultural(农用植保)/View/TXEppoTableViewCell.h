//
//  TXEppoTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/10.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXEppoTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *boxView;
/// 图片
@property (nonatomic, strong) UIImageView *imagesView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 副标题(内容)
@property (nonatomic, strong) UILabel *subtitleLabel;
/// 当前价格
@property (nonatomic, strong) UILabel *priceLabel;
/// 规格
@property (nonatomic, strong) UILabel *specLabel;
@property (nonatomic, strong) NewsRecordsModel *recordsModel;
@end

NS_ASSUME_NONNULL_END
