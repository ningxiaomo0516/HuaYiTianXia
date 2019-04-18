//
//  TXTicketOrderModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/17.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TicketOrderData,TicketOrderModel;
@interface TXTicketOrderModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) TicketOrderData *data;
@end

@interface TicketOrderData : NSObject
/// 当前页
@property (nonatomic, assign) NSInteger current;
/// 总页数
@property (nonatomic, assign) NSInteger pages;
/// 总页数
@property (nonatomic, assign) BOOL searchCount;
/// 总页数
@property (nonatomic, assign) NSInteger size;
/// 总页数
@property (nonatomic, assign) NSInteger total;
/// records 新闻列表集合
@property (nonatomic, strong) NSMutableArray<TicketOrderModel *> *list;
@end

@interface TicketOrderModel : NSObject
@property (nonatomic, copy) NSString *kid;
//// 出发地
@property (nonatomic, copy) NSString *destination;
/// 订票人姓名
@property (nonatomic, copy) NSString *username;
/// 目的地
@property (nonatomic, copy) NSString *origin;
/// 机票价格
@property (nonatomic, copy) NSString *price;
/// 订票状态
@property (nonatomic, copy) NSString *status;
/// 日期时间
@property (nonatomic, copy) NSString *datetime;
@end

NS_ASSUME_NONNULL_END
