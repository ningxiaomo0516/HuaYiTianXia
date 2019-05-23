//
//  TXInvitationModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/30.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class InvitationModel,InvitationData;
@interface TXInvitationModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
/// 产品详情Model数据
@property (nonatomic, strong) InvitationData *data;
@end

@interface InvitationData : NSObject
/// 当前页
@property (nonatomic, assign) NSInteger current;
/// 总页数
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger searchCount;
/// 每页条数
@property (nonatomic, assign) NSInteger size;
/// 总条数
@property (nonatomic, assign) NSInteger total;
/// list 集合
@property (nonatomic, strong) NSMutableArray<InvitationModel *> *list;
@end

@interface InvitationModel : NSObject
/// 用户ID
@property (nonatomic, copy) NSString *uid;
/// 头像
@property (nonatomic, copy) NSString *avatar;
/// 身份证号
@property (nonatomic, copy) NSString *idnumber;
/// 是否已购买
@property (nonatomic, copy) NSString *ispay;
/// 用户名(手机号)
@property (nonatomic, copy) NSString *mobile;
/// 真实姓名
@property (nonatomic, copy) NSString *username;
/// 手机号(联系方式)
@property (nonatomic, copy) NSString *phone;
/// 性别
@property (nonatomic, assign) NSInteger sex;
@end

NS_ASSUME_NONNULL_END
