//
//  TXPushMessageModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPushMessageModel.h"

@implementation TXPushMessageModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [PushMessageData class]};
}
@end

@implementation PushMessageData
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"list"        : @"records"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [PushMessageModel class]};
}

@end

@implementation PushMessageModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"        : @"id",
             @"messageType": @"status",
             @"datetime"   : @"time"};
}
@end

