//
//  TXTicketModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TicketModel,TicketPricesModel;
@interface TXTicketModel : NSObject
/**
返回码。
 0代表调用成功，
 其他代表调用失败：
    101代表没有该用户；
    102代表签名错误；
    103代表AIP不存在；
    104代表调用太频繁；
    105代表请求并发数超过限制；
    110代表可调用次数不足；
    111代表请求IP不在白名单中；
    112代表当前账户余额为负或代表验证码扣费失败，
请查看余额；
    113代表用户自定义退出；
    114代表没有返回数据；
    500代表其他错误类型，具体原因请看返回结果的错误原因。
*/
@property (nonatomic, assign) NSInteger errorcode;
/// 机票列表
@property (nonatomic, strong) NSMutableArray<TicketModel *> *data;
/// 返回说明，错误原因
@property (nonatomic, copy) NSString *message;

@end

@interface TicketModel : NSObject

/**航班ID*/
@property (nonatomic, strong) NSArray *uniq_key;
/**航班号*/
@property (nonatomic, copy) NSString *flight_number;
@property (nonatomic, copy) NSString *reason;
/**航空公司*/
@property (nonatomic, copy) NSString *airline;
/**机型*/
@property (nonatomic, copy) NSString *model;
/**起飞时间*/
@property (nonatomic, copy) NSString *dep_time;
/**起飞机场*/
@property (nonatomic, copy) NSString *dep_airport;
/**起飞航站楼*/
@property (nonatomic, copy) NSString *dep_airport_term;
/**到达时间*/
@property (nonatomic, copy) NSString *arv_time;
/**到达机场*/
@property (nonatomic, copy) NSString *arv_airport;
/**到达航站楼*/
@property (nonatomic, copy) NSString *arv_airport_term;
/**准点率*/
@property (nonatomic, copy) NSString *ontime_rate;
/**转机*/
@property (nonatomic, strong) NSArray *transfer_flights;

/**价格*/
@property (nonatomic, strong) NSMutableArray<TicketPricesModel *> *prices;
@end

@interface TicketPricesModel : NSObject
/**经济舱"*/
@property (nonatomic, copy) NSString *type;
/**价格（元）*/
@property (nonatomic, copy) NSString *price;
/**折扣*/
@property (nonatomic, copy) NSString *discount;
@end
NS_ASSUME_NONNULL_END
