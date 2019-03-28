//
//  TXNewTemplateTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXNewTemplateTableViewCell : UITableViewCell
/// 图片
@property (nonatomic, strong) UIImageView *imagesView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 副标题(内容)
@property (nonatomic, strong) UILabel *subtitleLabel;
/// 日期时间
@property (nonatomic, strong) UILabel *dataTimeLabel;

@property (nonatomic, strong) NewsRecordsModel *recordsModel;

@end

NS_ASSUME_NONNULL_END
