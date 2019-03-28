//
//  TXNewsModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/27.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXNewsModel.h"

@implementation TXNewsModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data" : @"obj"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TXNewsTabModel class]};
}
@end

@implementation TXNewsTabModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid" : @"id"};
}

@end

@implementation TXNewsArrayModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data" : @"obj",
             @"banners":@"banner"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [NewsModel class],
             @"banners" : [NewsBannerModel class]};
}
@end

@implementation NewsModel
+ (NSDictionary *)objectClassInArray{
    return @{@"records" : [NewsRecordsModel class]};
}
@end

@implementation NewsRecordsModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid" : @"id"};
}
@end

@implementation NewsBannerModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid" : @"id"};
}
@end

@implementation MallProductArrayModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data" : @"banner"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"banners" : [TXNewsTabModel class]};
}
@end

