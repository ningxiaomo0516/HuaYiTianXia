//
//  YKTicketOrderModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/10.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKTicketOrderModel.h"

@implementation YKTicketOrderModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"errorcode"   : @"code",
             @"message"     : @"msg",
             @"data"        : @"obj"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TicketDataModel class]};
}
@end

@implementation TicketDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"records" : [TicketListModel class]};
}
@end

@implementation TicketListModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"   : @"id"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"segment" : [TicketOrderSegment class]};
}

@end

@implementation TicketOrderSegment

@end



@implementation TicketOrderChildModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"errorcode"   : @"code",
             @"message"     : @"msg",
             @"data"        : @"obj"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TicketOrderDataChildModel class]};
}

@end


@implementation TicketOrderDataChildModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"   : @"id"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"segment" : [TicketOrderSegment class],
             @"passengers" : [TicketOrderChildPassengersModel class]};
}

@end

@implementation TicketOrderChildPassengersModel


@end

