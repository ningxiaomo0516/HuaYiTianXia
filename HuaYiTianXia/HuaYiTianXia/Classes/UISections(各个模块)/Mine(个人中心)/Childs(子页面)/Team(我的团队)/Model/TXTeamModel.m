//
//  TXTeamModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/30.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTeamModel.h"

@implementation TXTeamModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TeamData class]};
}
@end


@implementation TeamData
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"list"        : @"records"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [TeamModel class]};
}
@end

@implementation TeamModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"uid"     : @"id",
             @"username": @"nickName",
             @"avatar"  : @"headImg",
             @"idnumber": @"code"};
}
@end
