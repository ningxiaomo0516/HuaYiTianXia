//
//  TXCharterOrderModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/3.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterOrderModel.h"

@implementation TXCharterOrderModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CharterOrderModel class]};
}
@end

@implementation CharterOrderModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"         : @"id",
             @"arvCity"     : @"destination",
             @"depCity"     : @"origin"};
}

@end
