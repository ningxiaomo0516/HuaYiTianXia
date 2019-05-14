//
//  TXRecommendedModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXRecommendedModel.h"
@implementation RecommendChildModel
+ (NSDictionary *)objectClassInArray{
    return @{@"banners"      : [NewsBannerModel class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"        : @"id",
             @"datatime"   : @"time"};
}
@end

@implementation TXRecommendedModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [RecommendChildModel class]};
}
@end
