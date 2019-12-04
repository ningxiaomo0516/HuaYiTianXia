//
//  YKTicketQueryBoxView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/8.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKTicketQueryBoxView : UIView
/// 图标
@property (nonatomic, strong) UIImageView *imagesView;
/// 出发城市
@property (nonatomic, strong) UILabel *dep_citylabel;
/// 抵达城市
@property (nonatomic, strong) UILabel *arv_citylabel;
/// 出发日期
@property (nonatomic, strong) UILabel *dep_datelabel;
/// 出发日期
@property (nonatomic, strong) UILabel *dep_titlelabel;
/// 当前日期星期几
@property (nonatomic, strong) UILabel *dep_weeklabel;
/// 仓位选择
@property (nonatomic, strong) UILabel *dep_seatlabel;

/// 分割线
@property (nonatomic, strong) UIView *linerView_t;
@property (nonatomic, strong) UIView *linerView_b;

/// 搜索按钮
@property (nonatomic, strong) UIButton *searchButton;


/// 儿童
@property (nonatomic, strong) UIButton *childButton;
/// 婴儿
@property (nonatomic, strong) UIButton *babyButtton;
/// 儿童年龄范围
@property (nonatomic, strong) UILabel *childlabel;
/// 婴儿年龄范围
@property (nonatomic, strong) UILabel *babylabel;

/// 支付安全
@property (nonatomic, strong) UIButton *payButton;
/// 服务保险
@property (nonatomic, strong) UIButton *serviceBtn;


/// 仓位选择
@property (nonatomic, strong) UIButton *dep_seat_btn;
/// 出发城市按钮
@property (nonatomic, strong) UIButton *dep_city_btn;
/// 抵达城市按钮
@property (nonatomic, strong) UIButton *arv_city_btn;
/// 日期选择按钮
@property (nonatomic, strong) UIButton *date_select_btn;
@end

NS_ASSUME_NONNULL_END

