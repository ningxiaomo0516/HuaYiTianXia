//
//  TXPushMessageModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PushMessageData,PushMessageModel;
@interface TXPushMessageModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
/// 消息Data
@property (nonatomic, strong) PushMessageData *data;
@end

@interface PushMessageData : NSObject
///  -----------  列表  -----------  ///
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) BOOL searchCount;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSMutableArray<PushMessageModel *> *list;
///  -----------  转账详情  -----------  ///
/// 对方姓名
@property (nonatomic, copy) NSString *realname;
/// 对方账户
@property (nonatomic, copy) NSString *account;
/// 交易金额
@property (nonatomic, copy) NSString *tradingAmount;
/// 订单号
@property (nonatomic, copy) NSString *orderid;
/// 交易时间
@property (nonatomic, copy) NSString *tradingTime;
/// 转账备注
@property (nonatomic, copy) NSString *remarks;
/// 头像地址
@property (nonatomic, copy) NSString *avatarURL;
/// 对方昵称
@property (nonatomic, copy) NSString *nickname;

///  -----------  公告详情  -----------  ///
/// 公告标题
@property (nonatomic, copy) NSString *title;
/// 公告日期时间
@property (nonatomic, copy) NSString *datetime;
/// 公告内容
@property (nonatomic, copy) NSString *content;
@end


@interface PushMessageModel : NSObject
/// 消息类容
@property (nonatomic, copy) NSString *content;
/// 消息ID
@property (nonatomic, copy) NSString *kid;
/// 消息类型 2：转出记录 3：转入记录 4：后台公告 5：通知
@property (nonatomic, assign) NSInteger messageType;
/// 消息日期时间
@property (nonatomic, copy) NSString *datetime;
/// 消息标题
@property (nonatomic, copy) NSString *title;
/// 0：未读消息 1：已读消息
@property (nonatomic, assign) NSInteger hasRead;
@property (nonatomic, assign) NSInteger outID;
@property (nonatomic, copy) NSString *money;

@end

@interface PushHandleModel : NSObject

///  -----------  点击推送消息  -----------  ///
@property (nonatomic, copy) NSString *noID;
/// 消息ID
@property (nonatomic, copy) NSString *kid;
/// 2：转出记录 3：转入记录 4：后台公告 5：通知 6：新闻详情 7：直接跳转到“我的团队”
@property (nonatomic, assign) NSInteger messageType;
@end


NS_ASSUME_NONNULL_END
