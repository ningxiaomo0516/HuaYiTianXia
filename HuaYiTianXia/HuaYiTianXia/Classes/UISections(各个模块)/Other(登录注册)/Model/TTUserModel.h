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

/// 记录当前的充值类型默认为0： (1:充值 2:商城支付 3:农保支付)
@property (nonatomic, assign) NSInteger topupType;
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
@property (nonatomic, copy) NSString *userid;
/// 身份证背面
@property (nonatomic, copy) NSString *imgb;
/// 身份证正面
@property (nonatomic, copy) NSString *imgz;
/// 邀请码
@property (nonatomic, copy) NSString *inviteCode;
/// 是否已购买
@property (nonatomic, assign) NSInteger ispay;
/// 登录账号
@property (nonatomic, copy) NSString *account;
/// 姓名
@property (nonatomic, copy) NSString *realname;
/// 昵称
@property (nonatomic, copy) NSString *username;
/// 联系方式
@property (nonatomic, copy) NSString *phone;
/// 密码
@property (nonatomic, copy) NSString *password;
/// 性别(0:男 1：女)
@property (nonatomic, assign) NSInteger sex;
/// 邀请成功人数
@property (nonatomic, copy) NSString *suinvited;
/// 注册时间
@property (nonatomic, copy) NSString *registertime;
/// 最近登录时间
@property (nonatomic, copy) NSString *lastTime;
/// 上级代理ID
@property (nonatomic, copy) NSString *upproxy;
/// VR币
@property (nonatomic, copy) NSString *vrcurrency;
/// 0：未认证 1：认证中 2：已认证 3：认证失败
@property (nonatomic, assign) NSInteger isValidation;
/// 股权总数
@property (nonatomic, copy) NSString *stockRight;
/// 余额
@property (nonatomic, copy) NSString *balance;
/// 0：未设置交易密码 1：已设置交易密码
@property (nonatomic, assign) NSInteger tranPwd;


/// 天合会员当前级别
@property (nonatomic, copy) NSString *thGrade;
/// 天合会员总登记数
@property (nonatomic, copy) NSString *thGradeCount;
/// 天合会员等级名称（需判断是否为""）
@property (nonatomic, copy) NSString *thGradeName;
/// 分公司名称
@property (nonatomic, copy) NSString *companyname;
/// 分公司已加入人数
@property (nonatomic, copy) NSString *joined;
/// 分公司允许加入总人数
@property (nonatomic, copy) NSString *totalPeople;
/// 会员类型名称
@property (nonatomic, copy) NSString *userTypeName;
/// 会员类型 0：普通会员 1：天合会员
@property (nonatomic, assign) NSInteger usertype;

@property (nonatomic, strong) NSMutableArray<NewsBannerModel *> *banners;

/// 默认收货地址
@property (nonatomic, copy) NSString *receivedGoodsAddr;
/// 收货人姓名
@property (nonatomic, copy) NSString *receivedUserName;
/// 收货人电话
@property (nonatomic, copy) NSString *receivedTelphone;


//// 登录中的未知参数
@property (nonatomic, copy) NSString *ifStart;
@property (nonatomic, copy) NSString *ifActivate;

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
