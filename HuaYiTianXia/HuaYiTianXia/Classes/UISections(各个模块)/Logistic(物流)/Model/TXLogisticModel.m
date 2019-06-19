//
//  TXLogisticModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXLogisticModel.h"

@implementation TXLogisticModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [LogisticData class]};
}
@end

@implementation LogisticData
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"logisticInfo" : @"kdniaoInfo"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"logisticInfo" : [LogisticModel class]};
}
@end

@implementation LogisticModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"list" : @"Traces"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [TracesList class]};
}
@end

@implementation TracesList


@end
