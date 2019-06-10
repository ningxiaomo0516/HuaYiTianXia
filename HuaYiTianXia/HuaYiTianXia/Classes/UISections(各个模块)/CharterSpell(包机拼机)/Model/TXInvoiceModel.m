//
//  TXInvoiceModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/9.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXInvoiceModel.h"

@implementation TXInvoiceModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"list"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [InvoiceModel class]};
}
@end

@implementation InvoiceModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"         : @"id"};
}

@end
