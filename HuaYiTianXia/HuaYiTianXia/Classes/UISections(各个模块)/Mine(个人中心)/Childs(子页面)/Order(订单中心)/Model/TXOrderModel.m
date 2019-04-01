//
//  TXOrderModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/30.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXOrderModel.h"

@implementation TXOrderModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [OrderRecordsModel class]};
}
@end

@implementation OrderRecordsModel
+ (NSDictionary *)objectClassInArray{
    return @{@"records" : [OrderModel class]};
}
@end

@implementation OrderModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"        : @"id"};
}
@end
