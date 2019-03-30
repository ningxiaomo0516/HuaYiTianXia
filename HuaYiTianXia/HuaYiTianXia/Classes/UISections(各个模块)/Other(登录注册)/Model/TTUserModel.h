//
//  TTUserModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TTUserModel;
@interface TTUserDataModel : NSObject
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) TTUserModel *data;
@end

@interface TTUserModel : NSObject
/// 是否登录
@property (nonatomic, assign) BOOL isLogin;

/// 已邀请人数
@property (nonatomic, copy) NSString *ainvited;
/// AR币
@property (nonatomic, copy) NSString *arcurrency;
/// 总资产
@property (nonatomic, copy) NSString *totalAssets;
/// 身份证号码
@property (nonatomic, copy) NSString *idnumber;
/// 头像
@property (nonatomic, copy) NSString *avatar;
/// ID
@property (nonatomic, copy) NSString *uid;
/// 身份证背面
@property (nonatomic, copy) NSString *imgb;
/// 身份证正面
@property (nonatomic, copy) NSString *imgz;
/// 邀请码
@property (nonatomic, copy) NSString *inviteCode;
/// 是否已购买
@property (nonatomic, assign) NSInteger ispay;
/// 用户名(手机号)
@property (nonatomic, copy) NSString *mobile;
/// 姓名
@property (nonatomic, copy) NSString *realname;
/// 昵称
@property (nonatomic, copy) NSString *username;
/// 联系方式
@property (nonatomic, copy) NSString *phone;
/// 密码
@property (nonatomic, copy) NSString *pwd;
/// 性别
@property (nonatomic, assign) NSInteger sex;
/// 邀请成功人数
@property (nonatomic, copy) NSString *suinvited;
/// 注册时间
@property (nonatomic, copy) NSString *registertime;
/// 上级代理ID
@property (nonatomic, copy) NSString *upproxy;
/// VR币
@property (nonatomic, copy) NSString *vrcurrency;
/// 0：未认证 1：认证中 2：已认证
@property (nonatomic, assign) NSInteger type;
/// 股权总数
@property (nonatomic, copy) NSString *stockRight;
/// 余额
@property (nonatomic, copy) NSString *balance;
/// 0：未设置交易密码 1：已设置交易密码
@property (nonatomic, copy) NSString *tranPwd;

@property (nonatomic, strong) NSMutableArray<NewsBannerModel *> *banners;


+ (instancetype)shared;
/**
 * 归档 将user对象保存到本地文件夹
 */
- (void)dump;

/**
 * 取档 从本地文件夹中获取user对象
 */
- (TTUserModel *)load;

/**
 * 清空数据
 */
- (void)logout;
@end

NS_ASSUME_NONNULL_END
