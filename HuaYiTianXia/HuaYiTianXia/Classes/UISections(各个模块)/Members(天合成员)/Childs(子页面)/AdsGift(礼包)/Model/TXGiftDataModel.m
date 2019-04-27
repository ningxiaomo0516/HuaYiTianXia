//
//  TXGiftDataModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/27.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXGiftDataModel.h"

@implementation TXGiftDataModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg",};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [GiftDataModel class]};
}
@end
@implementation GiftDataModel
+ (NSDictionary *)objectClassInArray{
    return @{@"records" : [GiftModel class]};
}
@end

@implementation GiftModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"datatime" : @"time"};
}

@end
