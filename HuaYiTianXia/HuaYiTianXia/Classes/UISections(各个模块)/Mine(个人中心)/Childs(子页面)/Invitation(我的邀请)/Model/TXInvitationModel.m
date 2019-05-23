//
//  TXInvitationModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/30.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXInvitationModel.h"

@implementation TXInvitationModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [InvitationData class]};
}
@end


@implementation InvitationData
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"list"        : @"records"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [InvitationModel class]};
}
@end

@implementation InvitationModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"uid"     : @"id",
             @"username": @"nickName",
             @"avatar"  : @"headImg",
             @"idnumber": @"code"};
}
@end
