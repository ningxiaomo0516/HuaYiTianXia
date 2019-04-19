//
//  TXVersionModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXVersionModel.h"

@implementation TXVersionModel

- (NSString *)description{
    return [self yy_modelDescription];
}

@end


@implementation TXVersionCellModel

@end

@implementation TTVersionData

- (NSString *)description{
    return [self yy_modelDescription];
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TTVersionModel class]};
}

@end

@implementation TTVersionModel

- (NSString *)description{
    return [self yy_modelDescription];
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"kid"         : @"id",
             @"updateInfo"  : @"vexplain"};
}

@end
