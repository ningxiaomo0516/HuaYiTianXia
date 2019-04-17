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
/**订单号*/
@property (strong, nonatomic) UILabel *o_numLabel;
/**订票日期*/
@property (strong, nonatomic) UILabel *o_dateLabel;
/**订票人姓名*/
@property (strong, nonatomic) UILabel *o_nameLabel;
/*机票价格*/
@property (strong, nonatomic) UILabel *o_priceLabel;
/**起飞机场*/
@property (strong, nonatomic) UILabel *dep_airportLabel;
/**到达机场*/
@property (strong, nonatomic) UILabel *arv_airportLabel;
/// 到图片
@property (strong, nonatomic) UIImageView *imagesTo;
/**订单状态*/
@property (strong, nonatomic) UILabel *o_statusLabel;
@property (strong, nonatomic) TicketOrderModel *orderModel;
@end

NS_ASSUME_NONNULL_END
