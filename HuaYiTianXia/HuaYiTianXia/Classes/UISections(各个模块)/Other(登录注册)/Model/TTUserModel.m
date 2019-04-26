//
//  TTUserModel.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTUserModel.h"
#import "SCLocalCacheTool.h"

static NSString *topupType      = @"topupType";

static NSString *userid         = @"userid";
static NSString *isLogin        = @"isLogin";
static NSString *username       = @"username";
static NSString *realname       = @"realname";
static NSString *account        = @"account";
static NSString *phone          = @"phone";
static NSString *avatar         = @"avatar";
static NSString *sex            = @"sex";
static NSString *registertime   = @"registertime";
static NSString *password       = @"pwd";
static NSString *tranPwd        = @"tranPwd";
static NSString *isValidation   = @"isValidation";

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

/// 收货地址信息
static NSString *receivedGoodsAddr  = @"receivedGoodsAddr";
static NSString *receivedUserName   = @"receivedUserName";
static NSString *receivedTelphone   = @"receivedTelphone";


static NSString *thGrade            = @"thGrade";
static NSString *thGradeCount       = @"thGradeCount";
static NSString *thGradeName        = @"thGradeName";
static NSString *companyname        = @"companyname";
static NSString *joined             = @"joined";
static NSString *totalPeople        = @"totalPeople";
static NSString *userTypeName       = @"userTypeName";
static NSString *usertype           = @"usertype";
static NSString *ifStart            = @"ifStart";
static NSString *ifActivate         = @"ifActivate";


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
    return @{@"userid"         : @"id",
             @"account"     : @"mobile",
             @"password"    : @"pwd",
             @"username"    : @"nickName",
             @"realname"    : @"name",
             @"avatar"      : @"headImg",
             @"registertime": @"time",
             @"idnumber"    : @"code",
             @"totalAssets" : @"assets",
             @"isValidation": @"type"};
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
    if (self.userid.length > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isBindTel{
    if (self.phone.length > 0) {
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
        MVLog(@"userID:%@", [TTUserModel shared].userid);
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
        
        
        [TTUserModel shared].topupType              = [aDecoder decodeIntegerForKey:topupType];
        
        [TTUserModel shared].userid                 = [aDecoder decodeObjectForKey:userid];
        [TTUserModel shared].username               = [aDecoder decodeObjectForKey:username];
        [TTUserModel shared].realname               = [aDecoder decodeObjectForKey:realname];
        [TTUserModel shared].avatar                 = [aDecoder decodeObjectForKey:avatar];
        [TTUserModel shared].sex                    = [aDecoder decodeIntegerForKey:sex];
        [TTUserModel shared].account                = [aDecoder decodeObjectForKey:account];
        [TTUserModel shared].phone                  = [aDecoder decodeObjectForKey:phone];
        [TTUserModel shared].password               = [aDecoder decodeObjectForKey:password];
        [TTUserModel shared].tranPwd                = [aDecoder decodeIntegerForKey:tranPwd];
        [TTUserModel shared].registertime           = [aDecoder decodeObjectForKey:registertime];
        
        /// 解码并返回一个与给定键相关联的Bool类型的值
        [TTUserModel shared].isLogin                = [[aDecoder decodeObjectForKey:isLogin] boolValue];
        
        [TTUserModel shared].idnumber               = [aDecoder decodeObjectForKey:idnumber];
        [TTUserModel shared].imgb                   = [aDecoder decodeObjectForKey:imgb];
        [TTUserModel shared].imgz                   = [aDecoder decodeObjectForKey:imgz];
        
        [TTUserModel shared].ainvited               = [aDecoder decodeObjectForKey:ainvited];
        [TTUserModel shared].arcurrency             = [aDecoder decodeObjectForKey:arcurrency];
        [TTUserModel shared].inviteCode             = [aDecoder decodeObjectForKey:inviteCode];
        [TTUserModel shared].totalAssets            = [aDecoder decodeObjectForKey:totalAssets];
        [TTUserModel shared].balance                = [aDecoder decodeObjectForKey:balance];
        [TTUserModel shared].vrcurrency             = [aDecoder decodeObjectForKey:vrcurrency];
        [TTUserModel shared].suinvited              = [aDecoder decodeObjectForKey:suinvited];
        [TTUserModel shared].stockRight             = [aDecoder decodeObjectForKey:stockRight];
        
        [TTUserModel shared].ispay                  = [aDecoder decodeIntegerForKey:ispay];
        [TTUserModel shared].upproxy                = [aDecoder decodeObjectForKey:upproxy];
        [TTUserModel shared].isValidation           = [aDecoder decodeIntegerForKey:isValidation];
        
        
        [TTUserModel shared].receivedGoodsAddr      = [aDecoder decodeObjectForKey:receivedGoodsAddr];
        [TTUserModel shared].receivedUserName       = [aDecoder decodeObjectForKey:receivedUserName];
        [TTUserModel shared].receivedTelphone       = [aDecoder decodeObjectForKey:receivedTelphone];
        
        
        [TTUserModel shared].thGrade                = [aDecoder decodeObjectForKey:thGrade];
        [TTUserModel shared].thGradeCount           = [aDecoder decodeObjectForKey:thGradeCount];
        [TTUserModel shared].thGradeName            = [aDecoder decodeObjectForKey:thGradeName];
        [TTUserModel shared].companyname            = [aDecoder decodeObjectForKey:companyname];
        [TTUserModel shared].joined                 = [aDecoder decodeObjectForKey:joined];
        [TTUserModel shared].totalPeople            = [aDecoder decodeObjectForKey:totalPeople];
        [TTUserModel shared].userTypeName           = [aDecoder decodeObjectForKey:userTypeName];
        [TTUserModel shared].ifStart                = [aDecoder decodeObjectForKey:ifStart];
        [TTUserModel shared].ifActivate             = [aDecoder decodeObjectForKey:ifActivate];
        
        [TTUserModel shared].usertype               = [aDecoder decodeIntegerForKey:usertype];
    }
    return self;
}

/// 将一个自定义归档时就会调用该方法，该方法用于描述如何存储自定义对象的属性
- (void)encodeWithCoder:(NSCoder *)aCoder{
    /// 将Object类型编码，使其与字符串类型的键相关联
    
    [aCoder encodeInteger:[TTUserModel shared].topupType forKey:topupType];

    [aCoder encodeObject:[TTUserModel shared].userid forKey:userid];
    [aCoder encodeObject:[TTUserModel shared].username forKey:username];
    [aCoder encodeObject:[TTUserModel shared].realname forKey:realname];
    [aCoder encodeObject:[TTUserModel shared].avatar forKey:avatar];
    [aCoder encodeInteger:[TTUserModel shared].sex forKey:sex];
    [aCoder encodeObject:[TTUserModel shared].account forKey:account];
    [aCoder encodeObject:[TTUserModel shared].phone forKey:phone];
    [aCoder encodeObject:[TTUserModel shared].password forKey:password];
    [aCoder encodeInteger:[TTUserModel shared].tranPwd forKey:tranPwd];
    [aCoder encodeObject:[TTUserModel shared].registertime forKey:registertime];
    /// 将BOOL类型编码，使其与字符串类型的键相关联
    [aCoder encodeObject:[NSNumber numberWithBool:[TTUserModel shared].isLogin] forKey:isLogin];
    
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
    [aCoder encodeInteger:[TTUserModel shared].isValidation forKey:isValidation];
    
    
    [aCoder encodeObject:[TTUserModel shared].receivedGoodsAddr forKey:receivedGoodsAddr];
    [aCoder encodeObject:[TTUserModel shared].receivedUserName forKey:receivedUserName];
    [aCoder encodeObject:[TTUserModel shared].receivedTelphone forKey:receivedTelphone];
    
    [aCoder encodeObject:[TTUserModel shared].thGrade forKey:thGrade];
    [aCoder encodeObject:[TTUserModel shared].thGradeCount forKey:thGradeCount];
    [aCoder encodeObject:[TTUserModel shared].thGradeName forKey:thGradeName];
    [aCoder encodeObject:[TTUserModel shared].companyname forKey:companyname];
    [aCoder encodeObject:[TTUserModel shared].joined forKey:joined];
    [aCoder encodeObject:[TTUserModel shared].totalPeople forKey:totalPeople];
    [aCoder encodeObject:[TTUserModel shared].userTypeName forKey:userTypeName];
    [aCoder encodeObject:[TTUserModel shared].ifStart forKey:ifStart];
    [aCoder encodeObject:[TTUserModel shared].ifActivate forKey:ifActivate];
    [aCoder encodeInteger:[TTUserModel shared].usertype forKey:usertype];
    
}

/**
 * 清空数据
 */
- (void)logout {
    [TTUserModel shared].userid = @"";
    [TTUserModel shared].username = @"";
    [TTUserModel shared].realname = @"";
    [TTUserModel shared].avatar = @"";
    [TTUserModel shared].sex = 0;
    [TTUserModel shared].account = @"";
    [TTUserModel shared].phone = @"";
    [TTUserModel shared].password = @"";
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
    [TTUserModel shared].isValidation = 0;
    
    [TTUserModel shared].receivedGoodsAddr = @"";
    [TTUserModel shared].receivedTelphone = @"";
    [TTUserModel shared].receivedUserName = @"";
    [TTUserModel shared].topupType = 0;
    
    [TTUserModel shared].thGrade = @"";
    [TTUserModel shared].thGradeCount = @"";
    [TTUserModel shared].thGradeName = @"";
    [TTUserModel shared].companyname = @"";
    [TTUserModel shared].joined = @"";
    [TTUserModel shared].totalPeople = @"";
    [TTUserModel shared].userTypeName = @"";
    [TTUserModel shared].ifStart = @"";
    [TTUserModel shared].ifActivate = @"";
    [TTUserModel shared].usertype  = 0;
}
@end
