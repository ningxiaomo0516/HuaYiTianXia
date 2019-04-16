//
//  TXTicketModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTicketModel.h"

@implementation TXTicketModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"errorcode"   : @"error_code",
             @"message"     : @"reason"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TicketModel class]};
}
@end

@implementation TicketModel
+ (NSDictionary *)objectClassInArray{
    return @{@"prices" : [TicketPricesModel class]};
}
@end

@implementation TicketPricesModel

@end
