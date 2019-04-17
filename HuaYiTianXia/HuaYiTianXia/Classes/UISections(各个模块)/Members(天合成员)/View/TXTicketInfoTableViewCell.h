//
//  TXTicketInfoTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/17.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTicketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXTicketInfoTableViewCell : UITableViewCell
/*起飞时间*/
@property (strong, nonatomic) UILabel *date_label;
/*起飞时间*/
@property (strong, nonatomic) UILabel *weekend_label;
/*起飞时间*/
@property (strong, nonatomic) UILabel *time_label;
/*起飞时间*/
@property (strong, nonatomic) UILabel *type_label;
/*起飞时间*/
@property (strong, nonatomic) UILabel *dep_arv_label;
@property (strong, nonatomic) TicketModel *ticketModel;
@end

NS_ASSUME_NONNULL_END
