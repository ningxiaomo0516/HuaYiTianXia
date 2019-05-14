//
//  TXCourseChildModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCourseChildModel.h"

@implementation CourseChildModel
+ (NSDictionary *)objectClassInArray{
    return @{@"flightcourse" : [FlightCourseModel class],
             @"banners"      : [NewsBannerModel class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"        : @"id"};
}
@end

@implementation TXCourseChildModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CourseChildModel class]};
}
@end
