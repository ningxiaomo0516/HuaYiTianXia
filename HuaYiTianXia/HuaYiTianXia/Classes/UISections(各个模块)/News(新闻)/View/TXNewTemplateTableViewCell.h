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
/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

/// 图片
@property (nonatomic, strong) UIImageView *imagesView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 副标题(内容)
@property (nonatomic, strong) UILabel *subtitleLabel;
/// 日期时间
@property (nonatomic, strong) UILabel *dateTimeLabel;

@property (nonatomic, strong) NewsRecordsModel *recordsModel;


/// 图片_左
@property (nonatomic, strong) UIImageView *imagesView_L;
/// 图片_中
@property (nonatomic, strong) UIImageView *imagesView_C;
/// 图片_右
@property (nonatomic, strong) UIImageView *imagesView_R;
@end

NS_ASSUME_NONNULL_END
