//
//  TXWalletModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/1.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXWalletModel.h"

@implementation TXWalletModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [WalletListModel class]};
}
@end

@implementation WalletListModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"list"        : @"records",
             @"currentPage" : @"current",
             @"totalPages"  : @"pages",
             @"totalSize"   : @"total"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [WalletModel class]};
}

@end

@implementation WalletModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"     : @"id",
             @"date"    : @"time",
             @"price"   : @"money"};
}

@end
