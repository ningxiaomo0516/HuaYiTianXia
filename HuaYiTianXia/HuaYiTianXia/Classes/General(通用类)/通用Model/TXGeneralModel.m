//
//  TXGeneralModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXGeneralModel.h"

@implementation TXGeneralModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"message"     : @"msg",
             @"errorcode"   : @"code",
             @"realname"    : @"name"};
}
@end


@implementation OrderData

@end


@implementation RegionalPromptModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"message"     : @"msg",
             @"errorcode"   : @"code",
             @"data"        : @"obj"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [RegionalModel class]};
}
@end

@implementation RegionalModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"     : @"id"};
}
@end

@implementation RealnameModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"message"     : @"msg",
             @"errorcode"   : @"code"};
}

@end
