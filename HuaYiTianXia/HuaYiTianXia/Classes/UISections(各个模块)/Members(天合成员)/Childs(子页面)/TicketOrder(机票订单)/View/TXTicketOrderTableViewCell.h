//
//  TXTicketOrderTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/17.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTicketOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXTicketOrderTableViewCell : UITableViewCell
@property (strong, nonatomic) UIView *boxView;
/**订单号*/
@property (strong, nonatomic) UILabel *o_numLabel;
@property (strong, nonatomic) UIView *linerView;
@property (strong, nonatomic) UIImageView *imagesViewPlane;
/**起飞城市*/
@property (strong, nonatomic) UILabel *dep_city_label;
@property (strong, nonatomic) UIView *dep_arv_liner_h;
/**到达城市*/
@property (strong, nonatomic) UILabel *arv_city_label;
/**起飞日期时间*/
@property (strong, nonatomic) UILabel *o_datetime_label;

/*机票价格*/
@property (strong, nonatomic) UILabel *o_priceLabel;

/**起飞机场*/
@property (strong, nonatomic) UILabel *dep_airportLabel;
@property (strong, nonatomic) UIView *dep_arv_liner_v;
/**到达机场*/
@property (strong, nonatomic) UILabel *arv_airportLabel;
/**订票人姓名*/
@property (strong, nonatomic) UILabel *o_nameLabel;//111
/**订单状态*/
@property (strong, nonatomic) UILabel *o_statusLabel;
@property (strong, nonatomic) TicketOrderModel *orderModel;
@end

NS_ASSUME_NONNULL_END
