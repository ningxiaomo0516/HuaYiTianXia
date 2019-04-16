//
//  TXTicketListTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTicketListTableViewCell : UITableViewCell
//"uniq_key":[  /*航班ID*/
//            "MU5138"
//            ],
//"flight_number":"MU5138",  /*航班号*/
//"":"东方航空",  /*航空公司*/
//"model":"空中客车 A330",  /*机型*/
//"":"1573426800",
//"":"首都国际机场",
//"dep_airport_term":"T2",  /*起飞航站楼*/
//"":"1573434900",
//"":"虹桥国际机场",  /*到达机场*/
//"arv_airport_term":"T2",  /*到达航站楼*/
//"ontime_rate":"无",  /*准点率*/
//"transfer_flights":[  /*转机*/
//
//                    ],
/*起飞时间*/
@property (strong, nonatomic) UILabel *dep_timeLabel;
/*到达时间*/
@property (strong, nonatomic) UILabel *arv_timeLabel;

/*起飞机场*/
@property (strong, nonatomic) UILabel *dep_airportLabel;
/*到达机场*/
@property (strong, nonatomic) UILabel *arv_airportLabel;

/*航空公司*/
@property (strong, nonatomic) UILabel *airlineLabel;

/// 查询日期
@property (strong, nonatomic) UILabel *dateLabel;
/// 飞行时长
@property (strong, nonatomic) UILabel *timerLabel;

/// 经济舱
@property (strong, nonatomic) UILabel *titleLabel;
/// 公务舱
@property (strong, nonatomic) UILabel *subtitleLabel;
/// 头等舱
@property (strong, nonatomic) UILabel *titleLabel;

/// 含税总价
@property (strong, nonatomic) UILabel *taxPriceLabel;
/// 全价
@property (strong, nonatomic) UILabel *allPriceLabel;

/// 到图片
@property (strong, nonatomic) UIImageView *imagesView;
/// 时间图片
@property (strong, nonatomic) UIImageView *imagesView;
@end

NS_ASSUME_NONNULL_END
