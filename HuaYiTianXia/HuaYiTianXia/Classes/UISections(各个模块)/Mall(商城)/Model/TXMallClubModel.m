//
//  TXMallClubModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/12.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMallClubModel.h"

@implementation TXMallClubModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TXMallClubDataModel class]};
}
@end

@implementation TXMallClubDataModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"list"        : @"records"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [MallClubListModel class]};
}
@end
