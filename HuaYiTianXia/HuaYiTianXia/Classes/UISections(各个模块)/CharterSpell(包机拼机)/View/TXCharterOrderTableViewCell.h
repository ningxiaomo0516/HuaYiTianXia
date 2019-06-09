//
//  TXCharterOrderTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/1.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCharterOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXCharterOrderTableViewCell : UITableViewCell
/// 出发城市
@property (nonatomic, strong) UILabel *dep_city_label;
/// 出发机场
@property (nonatomic, strong) UILabel *dep_airport_label;
/// 到达城市
@property (nonatomic, strong) UILabel *arv_city_label;
/// 到达机场
@property (nonatomic, strong) UILabel *arv_airport_label;
/// 机型
@property (nonatomic, strong) UILabel *models_label;
/// 时长
@property (nonatomic, strong) UILabel *duration_label;
/// 图片
@property (nonatomic, strong) UIImageView *imagesView;
/// 座位
@property (nonatomic, strong) UILabel *seatLabel;
/// 出发时间
@property (nonatomic, strong) UILabel *dep_time_label;
/// 出发时间(title)
@property (nonatomic, strong) UILabel *dep_time_label_t;
/// 到达时间
@property (nonatomic, strong) UILabel *arv_time_label;
/// 到达时间(title)
@property (nonatomic, strong) UILabel *arv_time_label_t;
/// 出发日期
@property (nonatomic, strong) UILabel *dep_date_label;
/// 到达日期
@property (nonatomic, strong) UILabel *arv_date_label;
/// 出发实际日期
@property (nonatomic, strong) UILabel *dep_datetime_label;
/// 到达实际日期
@property (nonatomic, strong) UILabel *arv_datetime_label;
/// 出发航站楼
@property (nonatomic, strong) UILabel *dep_terminal_label;
/// 到达航站楼
@property (nonatomic, strong) UILabel *arv_terminal_label;
/// 出发航站楼(标题)
@property (nonatomic, strong) UILabel *dep_terminal_label_t;
/// 到达航站楼(标题)
@property (nonatomic, strong) UILabel *arv_terminal_label_t;
/// 分割线1
@property (nonatomic, strong) UIView *liner_1_view;
/// 分割线2
@property (nonatomic, strong) UIView *liner_2_view;
/// 分割线3
@property (nonatomic, strong) UIView *liner_3_view;



@property (nonatomic, strong) CharterOrderModel *orderModel;
@end

NS_ASSUME_NONNULL_END
