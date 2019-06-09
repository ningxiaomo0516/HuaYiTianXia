//
//  TXCharterMachineChildViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/31.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"
#import "TXCharterMachineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXCharterMachineChildViewController : TTBaseViewController
@property (nonatomic, copy) NSString *webUrl;
- (id)initTicketModel:(CharterMachineModel *)ticketTodel;
@end

NS_ASSUME_NONNULL_END
