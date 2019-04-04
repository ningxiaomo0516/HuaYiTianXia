//
//  TTUserModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTUserModel.h"
#import "SCLocalCacheTool.h"

static NSString *uid            = @"uid";
static NSString *isLogin        = @"isLogin";
static NSString *username       = @"username";
static NSString *realname       = @"realname";
static NSString *mobile         = @"mobile";
static NSString *phone          = @"phone";
static NSString *avatar         = @"avatar";
static NSString *sex            = @"sex";
static NSString *registertime   = @"registertime";
static NSString *pwd            = @"pwd";
static NSString *tranPwd        = @"tranPwd";
static NSString *type           = @"type";

static NSString *idnumber       = @"idnumber";
static NSString *imgb           = @"imgb";
static NSString *imgz           = @"imgz";


static NSString *ainvited       = @"ainvited";
static NSString *arcurrency     = @"arcurrency";
static NSString *inviteCode     = @"inviteCode";
static NSString *suinvited      = @"suinvited";

static NSString *ispay          = @"ispay";
static NSString *upproxy        = @"upproxy";

static NSString *vrcurrency     = @"vrcurrency";
static NSString *stockRight     = @"stockRight";
static NSString *balance        = @"balance";
static NSString *totalAssets    = @"totalAssets";



@implementation TTUserDataModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"data"        : @"obj",
             @"errorcode"   : @"code",
             @"message"     : @"msg"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TTUserModel class]};
}

@end

@implementation TTUserModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"uid"     : @"id",
             @"username": @"nickName",
             @"realname": @"name",
             @"avatar"  : @"headImg",
             @"registertime": @"time",
             @"idnumber"    : @"code",
             @"totalAssets": @"assets"};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"banners" : [NewsBannerModel class]};
}

static TTUserModel *userModel = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[TTUserModel alloc] init];
    });
    return userModel;
}

- (BOOL)isLogin{
    if (self.uid.length > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isBindTel{
    if (self.mobile.length > 0) {
        return YES;
    }
    return NO;
}

/**
 * 归档 将user对象保存到本地文件夹
 */
- (void)dump {
    NSString *userDataPath = [SCLocalCacheTool userDataDirectoryWithFileName:@"users"];
    [SCLocalCacheTool createUserLocalDirectory:userDataPath];
    NSString *userDataFile = [userDataPath stringByAppendingPathComponent:@"userInfo.dat"];
    
    BOOL b = [NSKeyedArchiver archiveRootObject:[TTUserModel shared] toFile:userDataFile];
    
    if (b) {
        MVLog(@"TTUserModel dump 成功");
    } else {
        MVLog(@"TTUserModel dump 失败");
    }
}

/**
 * 取档 从本地文件夹中获取user对象
 */
- (TTUserModel *)load {
    NSString *userDataPath = [SCLocalCacheTool userDataDirectoryWithFileName:@"users"];
    NSString *filePath = [userDataPath stringByAppendingPathComponent:@"userInfo.dat"];
    TTUserModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (user) {
        MVLog(@"SCSettingsModel load 成功");
        MVLog(@"userID:%@", [TTUserModel shared].uid);
    } else {
        MVLog(@"SCSettingsModel load 失败");
    }
    return user;
}

/// 从文件读取一个对象的时候会调用该方法，该方法用于描述如何读取保存在文件中的数据
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        /// 解码并返回一个与给定键相关联的Object类型的值
        [TTUserModel shared].uid = [aDecoder decodeObjectForKey:uid];
        [TTUserModel shared].username = [aDecoder decodeObjectForKey:username];
        [TTUserModel shared].realname = [aDecoder decodeObjectForKey:realname];
        [TTUserModel shared].avatar = [aDecoder decodeObjectForKey:avatar];
        [TTUserModel shared].sex = [aDecoder decodeIntegerForKey:sex];
        [TTUserModel shared].mobile = [aDecoder decodeObjectForKey:mobile];
        [TTUserModel shared].phone = [aDecoder decodeObjectForKey:phone];
        [TTUserModel shared].pwd = [aDecoder decodeObjectForKey:pwd];
        [TTUserModel shared].tranPwd = [aDecoder decodeIntegerForKey:tranPwd];
        [TTUserModel shared].registertime = [aDecoder decodeObjectForKey:registertime];
        
        /// 解码并返回一个与给定键相关联的Bool类型的值
        [TTUserModel shared].isLogin = [[aDecoder decodeObjectForKey:isLogin] boolValue];
        
        [TTUserModel shared].idnumber = [aDecoder decodeObjectForKey:idnumber];
        [TTUserModel shared].imgb = [aDecoder decodeObjectForKey:imgb];
        [TTUserModel shared].imgz = [aDecoder decodeObjectForKey:imgz];
        
        [TTUserModel shared].ainvited = [aDecoder decodeObjectForKey:ainvited];
        [TTUserModel shared].arcurrency = [aDecoder decodeObjectForKey:arcurrency];
        [TTUserModel shared].inviteCode = [aDecoder decodeObjectForKey:inviteCode];
        [TTUserModel shared].totalAssets = [aDecoder decodeObjectForKey:totalAssets];
        [TTUserModel shared].balance = [aDecoder decodeObjectForKey:balance];
        [TTUserModel shared].vrcurrency = [aDecoder decodeObjectForKey:vrcurrency];
        [TTUserModel shared].suinvited = [aDecoder decodeObjectForKey:suinvited];
        [TTUserModel shared].stockRight = [aDecoder decodeObjectForKey:stockRight];
        
        [TTUserModel shared].ispay = [aDecoder decodeIntegerForKey:ispay];
        [TTUserModel shared].upproxy = [aDecoder decodeObjectForKey:upproxy];
        [TTUserModel shared].type = [aDecoder decodeIntegerForKey:type];
    }
    return self;
}

/// 将一个自定义归档时就会调用该方法，该方法用于描述如何存储自定义对象的属性
- (void)encodeWithCoder:(NSCoder *)aCoder{
    /// 将Object类型编码，使其与字符串类型的键相关联
    [aCoder encodeObject:[TTUserModel shared].uid forKey:uid];
    [aCoder encodeObject:[TTUserModel shared].username forKey:username];
    [aCoder encodeObject:[TTUserModel shared].realname forKey:realname];
    [aCoder encodeObject:[TTUserModel shared].avatar forKey:avatar];
    [aCoder encodeInteger:[TTUserModel shared].sex forKey:sex];
    [aCoder encodeObject:[TTUserModel shared].mobile forKey:mobile];
    [aCoder encodeObject:[TTUserModel shared].phone forKey:phone];
    [aCoder encodeObject:[TTUserModel shared].pwd forKey:pwd];
    [aCoder encodeInteger:[TTUserModel shared].tranPwd forKey:tranPwd];
    [aCoder encodeObject:[TTUserModel shared].registertime forKey:registertime];
    /// 将BOOL类型编码，使其与字符串类型的键相关联
    [aCoder encodeBool:[NSNumber numberWithBool:[TTUserModel shared].isLogin] forKey:isLogin];
    
    [aCoder encodeObject:[TTUserModel shared].idnumber forKey:idnumber];
    [aCoder encodeObject:[TTUserModel shared].imgb forKey:imgb];
    [aCoder encodeObject:[TTUserModel shared].imgz forKey:imgz];
    
    [aCoder encodeObject:[TTUserModel shared].ainvited forKey:ainvited];
    [aCoder encodeObject:[TTUserModel shared].arcurrency forKey:arcurrency];
    [aCoder encodeObject:[TTUserModel shared].inviteCode forKey:inviteCode];
    [aCoder encodeObject:[TTUserModel shared].totalAssets forKey:totalAssets];
    [aCoder encodeObject:[TTUserModel shared].balance forKey:balance];
    [aCoder encodeObject:[TTUserModel shared].vrcurrency forKey:vrcurrency];
    [aCoder encodeObject:[TTUserModel shared].suinvited forKey:suinvited];
    [aCoder encodeObject:[TTUserModel shared].stockRight forKey:stockRight];
    
    [aCoder encodeInteger:[TTUserModel shared].ispay forKey:ispay];
    [aCoder encodeObject:[TTUserModel shared].upproxy forKey:upproxy];
    [aCoder encodeInteger:[TTUserModel shared].type forKey:type];
}

/**
 * 清空数据
 */
- (void)logout {
    [TTUserModel shared].uid = @"";
    [TTUserModel shared].username = @"";
    [TTUserModel shared].realname = @"";
    [TTUserModel shared].avatar = @"";
    [TTUserModel shared].sex = 0;
    [TTUserModel shared].mobile = @"";
    [TTUserModel shared].phone = @"";
    [TTUserModel shared].pwd = @"";
    [TTUserModel shared].tranPwd = 0;
    [TTUserModel shared].registertime = @"";
    
    [TTUserModel shared].isLogin = NO;
    
    [TTUserModel shared].idnumber = @"";
    [TTUserModel shared].imgb = @"";
    [TTUserModel shared].imgz = @"";
    
    [TTUserModel shared].ainvited = @"";
    [TTUserModel shared].arcurrency = @"";
    [TTUserModel shared].inviteCode = @"";
    [TTUserModel shared].totalAssets = @"";
    [TTUserModel shared].balance = @"";
    [TTUserModel shared].vrcurrency = @"";
    [TTUserModel shared].suinvited = @"";
    [TTUserModel shared].stockRight = @"";
    
    [TTUserModel shared].ispay = 0;
    [TTUserModel shared].upproxy = @"";
    [TTUserModel shared].type = 0;
}
@end
