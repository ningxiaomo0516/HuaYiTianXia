//
//  TXLogisticViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/14.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TTBaseTableViewController.h"
#import "TXOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXLogisticViewController : TTBaseTableViewController
- (instancetype)initWithOrderModel:(OrderModel *)orderModel;
@end

NS_ASSUME_NONNULL_END
