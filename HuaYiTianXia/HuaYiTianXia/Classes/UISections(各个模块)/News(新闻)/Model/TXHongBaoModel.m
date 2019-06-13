//
//  TXHongBaoModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/13.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXHongBaoModel.h"

@implementation TXHongBaoModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [HongBaoModel class]};
}
@end

@implementation HongBaoModel



@end
