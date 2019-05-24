//
//  TXMineTeamModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/23.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMineTeamModel.h"

@implementation TXMineTeamModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [MineTeamDataModel class]};
}
@end


@implementation MineTeamDataModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"         : @"id",
             @"list"        : @"customers",
             @"teamName"    : @"name"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [MineTeamModel class]};
}
@end

@implementation MineTeamModel

@end



@implementation TeamModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"createTime"  : @"sysTime",
             @"kid"         : @"id"};
}
@end

@implementation TeamListModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [TeamModel class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"list"        : @"records"};
}
@end

@implementation TeamDataModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TeamListModel class]};
}

@end


