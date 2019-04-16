//
//  TXTicketListTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTicketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXTicketListTableViewCell : UITableViewCell
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
@property (strong, nonatomic) UILabel *economyLabel;
/// 公务舱
@property (strong, nonatomic) UILabel *businessleLabel;
/// 头等舱
@property (strong, nonatomic) UILabel *luxuryLabel;

/// 含税总价
@property (strong, nonatomic) UILabel *taxPriceLabel;
/// 全价
@property (strong, nonatomic) UILabel *allPriceLabel;

/// 到图片
@property (strong, nonatomic) UIImageView *imagesTo;
/// 时间图片
@property (strong, nonatomic) UIImageView *imagesTime;

@property (strong, nonatomic) TicketModel *ticketModel;

@end

NS_ASSUME_NONNULL_END
