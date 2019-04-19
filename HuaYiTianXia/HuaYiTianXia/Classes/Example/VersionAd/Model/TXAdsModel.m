//
//  TXAdsModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXAdsModel.h"

@implementation TXAdsModel
- (NSString *)description{
    return [self yy_modelDescription];
}


@end

@implementation TTAdsData
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TTAdsModel class]};
}
@end

@implementation TTAdsModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"         : @"id",
             @"imageUrl"    : @"imgurl",
             @"showTime"    : @"countdown",
             @"jumpUrl"     : @"url"};
}
@end
