//
//  YKPassengersViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/11.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TTBaseTableViewController.h"
#import "TXTicketModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ReturnPassengerModel)(PassengerModel *passengerModel);
@interface YKPassengersViewController : TTBaseTableViewController
@property (nonatomic, strong) ReturnPassengerModel returnBlock;
@end

NS_ASSUME_NONNULL_END
