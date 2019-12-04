//
//  YKTicketOrderModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/10.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TicketDataModel,TicketListModel,TicketOrderSegment;
@interface YKTicketOrderModel : NSObject
@property (nonatomic, assign) NSInteger errorcode;
/// 机票列表
@property (nonatomic, strong) TicketDataModel *data;
/// 返回说明，错误原因
@property (nonatomic, copy) NSString *message;
@end

@interface TicketDataModel : NSObject
/// records 新闻列表集合
@property (nonatomic, strong) NSMutableArray<TicketListModel *> *records;
@end

@interface TicketListModel : NSObject
@property (nonatomic, copy) NSString *kid;
@property (nonatomic, copy) NSString *totalPay;
@property (nonatomic, copy) NSString *payFlag;
@property (nonatomic, copy) NSString *depCname;
@property (nonatomic, copy) NSString *arrCname;
@property (nonatomic, copy) NSString *depJetquay;
@property (nonatomic, copy) NSString *arrJetquay;
@property (nonatomic, copy) NSString *planeType;
@property (nonatomic, copy) NSString *meal;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *ctct;
@property (nonatomic, strong) TicketOrderSegment *segment;

@end
    
@interface TicketOrderSegment : NSObject
@property (nonatomic, copy) NSString *flightNo;
@property (nonatomic, copy) NSString *depDate;
@property (nonatomic, copy) NSString *arrDate;
@property (nonatomic, copy) NSString *depAirportCName;
@property (nonatomic, copy) NSString *arrAirportCName;
@property (nonatomic, copy) NSString *depCityCName;
@property (nonatomic, copy) NSString *arrCityCName;
@end


@class TicketOrderDataChildModel,TicketOrderChildPassengersModel;
@interface TicketOrderChildModel : NSObject
@property (nonatomic, assign) NSInteger errorcode;
/// 机票列表
@property (nonatomic, strong) TicketOrderDataChildModel *data;
/// 返回说明，错误原因
@property (nonatomic, copy) NSString *message;
@end

@interface TicketOrderDataChildModel : NSObject
/// 机票列表
@property (nonatomic, strong) TicketOrderSegment *segment;
@property (nonatomic, copy) NSString *kid;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *totalPay;
@property (nonatomic, copy) NSString *payFlag;
@property (nonatomic, copy) NSString *depCname;
@property (nonatomic, copy) NSString *arrCname;
@property (nonatomic, copy) NSString *statusName;

@property (nonatomic, strong) NSMutableArray<TicketOrderChildPassengersModel *> *passengers;
@end

@interface TicketOrderChildPassengersModel : NSObject
@property (nonatomic, copy) NSString *ticketNo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *certificateNum;
@end
NS_ASSUME_NONNULL_END
