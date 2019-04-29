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
/// banner 集合
@property (nonatomic, strong) PushMessageData *data;
@end

@interface PushMessageData : NSObject
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) BOOL searchCount;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSMutableArray<PushMessageModel *> *list;
@end
@interface PushMessageModel : NSObject
/// 消息类容
@property (nonatomic, copy) NSString *content;
/// 消息ID
@property (nonatomic, assign) NSInteger kid;
/// 消息类型
@property (nonatomic, assign) NSInteger messageType;
/// 消息日期时间
@property (nonatomic, copy) NSString *datetime;
/// 消息标题
@property (nonatomic, copy) NSString *title;
/// 0：未读消息 1：已读消息
@property (nonatomic, copy) NSString *yidu;
@property (nonatomic, copy) NSString *outID;
@property (nonatomic, copy) NSString *money;
@end


NS_ASSUME_NONNULL_END
