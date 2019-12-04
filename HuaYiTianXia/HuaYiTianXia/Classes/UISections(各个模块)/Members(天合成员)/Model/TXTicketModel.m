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
    return @{@"errorcode"   : @"code",
             @"message"     : @"msg",
             @"data"        : @"obj"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TicketModel class]};
}
@end

@implementation TicketModel
+ (NSDictionary *)objectClassInArray{
    return @{@"seatItems" : [SeatItems class]};
}
@end

@implementation SeatItems
+ (NSDictionary *)objectClassInArray{
    return @{@"policys" : [Policys class]};
}
@end

@implementation Policys
+ (NSDictionary *)objectClassInArray{
    return @{@"priceDatas" : [PricesModel class]};
}
@end

@implementation PricesModel

@end


@implementation FlightServiceModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"errorcode"   : @"code",
             @"message"     : @"msg",
             @"data"        : @"obj"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [ServiceInfoModel class]};
}
@end

@implementation ServiceInfoModel
+ (NSDictionary *)objectClassInArray{
    return @{@"flightTax" : [FlightTaxModel class],
             @"customer" : [CustomerModel class],
             @"idCards" : [IdCardsModel class]
             };
}
@end

@implementation FlightTaxModel

@end

@implementation CustomerModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"   : @"id"};
}
@end

@implementation IdCardsModel

@end


@implementation SegmentModel

@end

@implementation PriceDataModel

@end

@implementation PassengerModel

@end

