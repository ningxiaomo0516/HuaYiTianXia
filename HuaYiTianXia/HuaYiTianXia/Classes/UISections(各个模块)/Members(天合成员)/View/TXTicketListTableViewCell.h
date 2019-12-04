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
@property (strong, nonatomic) UIView *boxView;
/*起飞时间*/
@property (strong, nonatomic) UILabel *dep_timeLabel;
/*到达时间*/
@property (strong, nonatomic) UILabel *arv_timeLabel;

/*起飞机场*/
@property (strong, nonatomic) UILabel *dep_airportLabel;
/*到达机场*/
@property (strong, nonatomic) UILabel *arv_airportLabel;

/// 基础价格
@property (strong, nonatomic) UILabel *priceLabel;
/*航班号*/
@property (strong, nonatomic) UILabel *flightNoLabel;
/// 机型
@property (strong, nonatomic) UILabel *planeTypeLabel;
/// 图标
@property (strong, nonatomic) UIImageView *imagesView;
/// 图标
@property (strong, nonatomic) UILabel *timelabel;
/// 图标
@property (strong, nonatomic) UIImageView *imagesTime;

@property (strong, nonatomic) TicketModel *ticketModel;

@end

NS_ASSUME_NONNULL_END
