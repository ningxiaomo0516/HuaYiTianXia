//
//  TXMainModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/9/5.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMainModel.h"

@implementation TXMainModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [MainModel class]};
}
@end


@implementation MainModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [MainListModel class],
             @"banners" : [NewsBannerModel class]};
}
@end

@implementation MainListModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid" : @"id"};
}
@end
