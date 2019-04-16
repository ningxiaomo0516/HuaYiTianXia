//
//  TTBannerModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBannerModel.h"

@implementation TTBannerModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"banners"     : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"banners" : [NewsBannerModel class]};
}
@end
