//
//  TXAddressModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/1.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXAddressModel.h"

@implementation TXAddressModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [AddressModel class]};
}
@end

@implementation AddressModel
- (BOOL)isDefault{
    if (self.status == 1) {
        return YES;
    }
    return NO;
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"sid"     : @"id",
             @"address" : @"adder",
             @"telphone": @"phot",
             @"username": @"userName",
             @"province": @"provinces"};
}
@end


@implementation TXCityModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"     : @"id"};
}
@end

@implementation TXCityData
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"list"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [TXCityModel class]};
}
@end
