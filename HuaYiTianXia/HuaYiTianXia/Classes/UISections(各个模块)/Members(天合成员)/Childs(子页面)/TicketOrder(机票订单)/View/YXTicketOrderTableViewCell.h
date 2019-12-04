//
//  YXTicketOrderTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/10.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXTicketOrderTableViewCell : UITableViewCell
/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

/// 出发城市到目的地
@property (nonatomic, strong) UILabel *dep_arv_city_label;
/// 日期
@property (nonatomic, strong) UILabel *dep_date_label;
/// 星期几
@property (nonatomic, strong) UILabel *dep_week_label;


/// 盒子
@property (nonatomic, strong) UIView *boxView;
/// 航班号
@property (nonatomic, strong) UILabel *flightNo_label;
/// 出发城市到抵达城市
@property (nonatomic, strong) UILabel *depCity_arvCity_label;

/// 盒子
@property (nonatomic, strong) UIView *childView_t;
@property (nonatomic, strong) UIView *childView_c;
@property (nonatomic, strong) UIView *childView_b;

/// 出发机场
@property (nonatomic, strong) UILabel *dep_airport_label;
/// 抵达机场
@property (nonatomic, strong) UILabel *arv_airport_label;
/// 出发时间
@property (nonatomic, strong) UILabel *dep_time_label;
/// 抵达时间
@property (nonatomic, strong) UILabel *arv_time_label;

/// 行程状态
@property (nonatomic, strong) UILabel *trip_status_label;
@property (nonatomic, strong) UIImageView *imagesView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIImageView *imagesView_t;
@property (nonatomic, strong) UIImageView *imagesView_b;


@end

NS_ASSUME_NONNULL_END
