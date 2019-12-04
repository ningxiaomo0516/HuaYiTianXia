//
//  YKBuyTicketViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/7.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TTBaseTableViewController.h"
#import "TXTicketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YKBuyTicketViewController : TTBaseTableViewController
- (id)initTicketModel:(TicketModel *)ticketModel seatItems:(SeatItems *)seatItems;
@end

NS_ASSUME_NONNULL_END
