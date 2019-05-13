//
//  TXMallUAVModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/12.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMallUAVModel.h"

@implementation TXMallUAVModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TXMallUAVDataModel class]};
}
@end

@implementation TXMallUAVDataModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"list"        : @"records"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [MallUAVListModel class]};
}
@end
