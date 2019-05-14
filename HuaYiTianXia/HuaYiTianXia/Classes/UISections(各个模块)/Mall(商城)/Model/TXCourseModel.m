//
//  TXCourseModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCourseModel.h"

@implementation Flightmodels
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"     : @"id"};
}
@end

@implementation FlightCourseModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"     : @"id"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"flightmodels" : [Flightmodels class]};
}
@end

@implementation CourseListModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"     : @"id"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"flightcourse" : [FlightCourseModel class]};
}
@end

@implementation CourseDataModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"list"    : @"records"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CourseListModel class]};
}
@end

@implementation TXCourseModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CourseDataModel class]};
}
@end
