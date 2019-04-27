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
@property (nonatomic, copy) NSString *orderNumber;
//// 出发地
@property (nonatomic, copy) NSString *destination;
/// 订票人姓名
@property (nonatomic, copy) NSString *username;
/// 目的地
@property (nonatomic, copy) NSString *origin;
/// 机票价格
@property (nonatomic, copy) NSString *price;
/// 订票状态类型 0:未支付 1:订票中 2:已取消 3:已取消 4:已取消 5:已出票
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *typeName;
/// 日期时间
@property (nonatomic, copy) NSString *datetime;
/// 航班号
@property (nonatomic, copy) NSString *flightNumber;
/// 起飞时间
@property (nonatomic, copy) NSString *arvTime;
/// 到达时间
@property (nonatomic, copy) NSString *depTime;
/// 用户ID
@property (nonatomic, copy) NSString *userID;
/// 航空公司
@property (nonatomic, copy) NSString *airline;
@property (nonatomic, copy) NSString *idcard;
/// 起飞机场
@property (nonatomic, copy) NSString *arvAirport;
/// 到达机场
@property (nonatomic, copy) NSString *depAirport;
@property (nonatomic, copy) NSString *phone;
/// 飞机类型
@property (nonatomic, copy) NSString *aircraft;
/// 备注
@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, copy) NSString *orderprice;
@property (nonatomic, copy) NSString *orderTime;
@end
NS_ASSUME_NONNULL_END
