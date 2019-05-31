//
//  TXCharterMachineModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/31.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterMachineModel.h"


@implementation CharterMachineModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"         : @"id",
             @"arvCity"     : @"destination",
             @"depCity"     : @"origin"};
}
@end

@implementation CharterMachineListModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"list"        : @"records"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CharterMachineModel class]};
}
@end

@implementation TXCharterMachineModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CharterMachineListModel class]};
}
@end
