//
//  SCUploadImageModel.m
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/8/1.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import "SCUploadImageModel.h"

@implementation SCUploadImageModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [UploadImageModel class]};
}
@end

@implementation UploadImageModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"imageURL" : @"url"};
}
@end

