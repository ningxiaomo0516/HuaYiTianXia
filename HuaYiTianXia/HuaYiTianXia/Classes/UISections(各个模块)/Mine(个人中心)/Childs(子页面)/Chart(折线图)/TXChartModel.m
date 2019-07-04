//
//  TXChartModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/7/4.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXChartModel.h"

@implementation TXChartModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [ChartDataModel class]};
}
@end

@implementation ChartDataModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"VH"  : @"VHChange",
             @"FT"  : @"MultipleChange",
             @"AH"  : @"AHChange"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"VH" : [ChartModel class],
             @"FT" : [ChartModel class],
             @"AH" : [ChartModel class]};
}
@end

@implementation ChartModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"timestamp" : @"time"};
}

@end
