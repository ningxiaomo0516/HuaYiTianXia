//
//  TXCharterOrderModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/3.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CharterOrderModel;
@interface TXCharterOrderModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) CharterOrderModel *data;
@end

@interface CharterOrderModel : NSObject

/// 飞机类型
@property (nonatomic, copy) NSString *aircraft;
/// 图片
@property (nonatomic, copy) NSString *aircraftImg;
/// 航空公司
@property (nonatomic, copy) NSString *airline;
/// 抵达机场
@property (nonatomic, copy) NSString *arvAirport;
/// 抵达日期
@property (nonatomic, copy) NSString *arvDate;
/// 抵达时间
@property (nonatomic, copy) NSString *arvHour;
/// 抵达航站楼
@property (nonatomic, copy) NSString *arvTerminal;
/// 抵达日期时间(用于提交订单使用)
@property (nonatomic, copy) NSString *arvTime;
/// 详情
@property (nonatomic, copy) NSString *content;

/// 起飞机场
@property (nonatomic, copy) NSString *depAirport;
/// 起飞日期
@property (nonatomic, copy) NSString *depDate;
/// 起飞时间
@property (nonatomic, copy) NSString *depHour;
/// 起飞航站楼
@property (nonatomic, copy) NSString *depTerminal;
/// 起飞日期时间(用于提交订单使用)
@property (nonatomic, copy) NSString *depTime;
/// 目的地
@property (nonatomic, copy) NSString *arvCity;
/// 时长
@property (nonatomic, copy) NSString *duration;
/// 起始地
@property (nonatomic, copy) NSString *depCity;



/// 包机拼机表ID
@property (nonatomic, copy) NSString *kid;
/// 定金
@property (nonatomic, copy) NSString *needDeposit;
/// 价格
@property (nonatomic, copy) NSString *price;
/// 优惠前价格
@property (nonatomic, copy) NSString *referenceprice;

/// 座位总数
@property (nonatomic, copy) NSString *totalSeats;
/// 起飞星期几
@property (nonatomic, copy) NSString *week;

/// 是否提供餐点false：否 true：是
@property (nonatomic, assign) BOOL food;
/// 是否提供接送false：否 true：是
@property (nonatomic, assign) BOOL shuttle;


@property (nonatomic, copy) NSString *hot;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *surplusSeats;
@property (nonatomic, copy) NSString *sysTime;
@property (nonatomic, copy) NSString *flyDate;
@property (nonatomic, copy) NSString *flyTime;
@property (nonatomic, copy) NSString *holdFly;
@end

NS_ASSUME_NONNULL_END
