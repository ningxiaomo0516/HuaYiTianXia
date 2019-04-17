//
//  TXTicketOrderModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/17.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTicketOrderModel.h"

@implementation TXTicketOrderModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TicketOrderData class]};
}
@end

@implementation TicketOrderData
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TicketOrderModel class]};
}
@end

@implementation TicketOrderModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"         : @"id",
             @"username"    : @"name",
             @"datetime"    : @"time"};
}
@end
