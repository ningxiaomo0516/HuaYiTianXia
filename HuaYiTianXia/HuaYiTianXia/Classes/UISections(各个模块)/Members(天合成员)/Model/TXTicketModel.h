//
//  TXTicketModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TicketModel,SeatItems,Policys,PricesModel;
@interface TXTicketModel : NSObject

@property (nonatomic, assign) NSInteger errorcode;
/// 机票列表
@property (nonatomic, strong) NSMutableArray<TicketModel *> *data;
/// 返回说明，错误原因
@property (nonatomic, copy) NSString *message;

@end

@interface TicketModel : NSObject
/**转换成月日的日期*/
@property (nonatomic, copy) NSString *dep_date;
/**转换成时分的时间*/
@property (nonatomic, copy) NSString *dep_time;
/**周几*/
@property (nonatomic, copy) NSString *dep_week;
/**出发日期*/
@property (nonatomic, copy) NSString *depDate;

/**航班号 MU5318*/
@property (nonatomic, copy) NSString *flightNo;
/**起飞时间 yyyy­MM­dd hh:mm:ss*/
@property (nonatomic, copy) NSString *depTime;
/**起飞机场三字码*/
@property (nonatomic, copy) NSString *depCode;
@property (nonatomic, copy) NSString *depName;
/**出发城市*/
@property (nonatomic, copy) NSString *depCname;
/// 航班抵达时间(2018­-10-­12 12:00)
@property (nonatomic, copy) NSString *arrDate;
/**抵达时间 yyyy­MM­dd hh:mm:ss*/
@property (nonatomic, copy) NSString *arrTime;
/**到达机场三字码*/
@property (nonatomic, copy) NSString *arrCode;
@property (nonatomic, copy) NSString *arrName;
/**抵达城市*/
@property (nonatomic, copy) NSString *arrCname;
/**出发航站楼 T1*/
@property (nonatomic, copy) NSString *depJetquay;
/**抵达航站楼 T1*/
@property (nonatomic, copy) NSString *arrJetquay;
/**经停次数，数字代表次数*/
@property (nonatomic, copy) NSString *stopNum;
/**机型 33H*/
@property (nonatomic, copy) NSString *planeType;
/**飞行里程 800*/
@property (nonatomic, copy) NSString *distance;
/**基础价格*/
@property (nonatomic, copy) NSString *basePrics;
/**餐食标识*/
@property (nonatomic, strong) NSString *meal;
/**舱位信息*/
@property (nonatomic, strong) NSMutableArray<SeatItems *> *seatItems;
@end

@interface SeatItems : NSObject
/**舱位 W*/
@property (nonatomic, copy) NSString *seatCode;
/**儿童舱位 W*/
@property (nonatomic, copy) NSString *chdSeatCode;
/**舱位状态 0­9 或者 英文字母*/
@property (nonatomic, copy) NSString *seatStatus;
/**儿童舱位状态 1­9代表剩余座位数，A代表座位数大于9*/
@property (nonatomic, copy) NSString *chdSeatStatus;
/**服务级别 1.头等舱 2.商务舱 3.经济舱 5.超级经济舱 6.高端 经济舱 7.尊享经济
 8.超值经济 9.超值公务 10.超值头等 11.舒适经济 12.优惠商务 13.明珠经济 14.超值商务"*/
@property (nonatomic, copy) NSString *cabinClass;
/**舱位说明*/
@property (nonatomic, copy) NSString *seatMsg;
/**是否特价舱位 1.普通 2.特价*/
@property (nonatomic, assign) NSInteger seatType;
/**折扣*/
@property (nonatomic, assign) double discount;
/**产品信息"*/
@property (nonatomic, strong) Policys *policys;



/**乘机人类型 1 成人 2 儿童 3 婴儿 暂不使用*/
@property (nonatomic, copy) NSString *crewType;
/**票面价*/
@property (nonatomic, copy) NSString *price;
/**单人结算价 (price*(1­ commisionPoint%)­ commisionMoney)不含税*/
@property (nonatomic, copy) NSString *settlement;
/**单人机建*/
@property (nonatomic, copy) NSString *airportTax;
/**单人燃油费*/
@property (nonatomic, copy) NSString *fuelTax;
/**返点 0.1 =0.1%*/
@property (nonatomic, copy) NSString *commisionPoint;
/**定额*/
@property (nonatomic, copy) NSString *commisionMoney;
/**支付手续费*/
@property (nonatomic, copy) NSString *payFee;
/**是否换编码出票 1:原编码出票 2:需要换编码出票*/
@property (nonatomic, copy) NSString *isSwitchPnr;
/**政策类型 BSP或者B2B*/
@property (nonatomic, copy) NSString *policyType;
/**出票效率*/
@property (nonatomic, copy) NSString *ticketSpeed;

@end

@interface Policys : NSObject
/**产品ID 用于验舱验价及下单*/
@property (nonatomic, copy) NSString *policyId;
/**
 产品类型
 商旅优选:1、2、3、4、12、13、
 低价推荐:41、42、43、44、45、
 官网:21、22、23、24、25
 */
@property (nonatomic, copy) NSString *productType;
/**出票工作时间*/
@property (nonatomic, copy) NSString *workTime;
/**退票工作时间 当前日期的工作时间如*/
@property (nonatomic, copy) NSString *vtWorkTime;
/**备注(产品备注)*/
@property (nonatomic, copy) NSString *comment;
/**价格信息*/
@property (nonatomic, strong) NSMutableArray<PricesModel *> *priceDatas;
@end

@interface PricesModel : NSObject
/**乘机人类型 1 成人 2 儿童 3 婴儿 暂不使用*/
@property (nonatomic, copy) NSString *crewType;
/**票面价*/
@property (nonatomic, copy) NSString *price;
/**单人结算价 (price*(1­ commisionPoint%)­ commisionMoney)不含税*/
@property (nonatomic, copy) NSString *settlement;
/**单人机建*/
@property (nonatomic, copy) NSString *airportTax;
/**单人燃油费*/
@property (nonatomic, copy) NSString *fuelTax;
/**返点 0.1 =0.1%*/
@property (nonatomic, copy) NSString *commisionPoint;
/**定额*/
@property (nonatomic, copy) NSString *commisionMoney;
/**支付手续费*/
@property (nonatomic, copy) NSString *payFee;
/**是否换编码出票 1:原编码出票 2:需要换编码出票*/
@property (nonatomic, copy) NSString *isSwitchPnr;
/**政策类型 BSP或者B2B*/
@property (nonatomic, copy) NSString *policyType;
/**出票效率*/
@property (nonatomic, copy) NSString *ticketSpeed;
@end


@class ServiceInfoModel,FlightTaxModel,CustomerModel,IdCardsModel;
@interface FlightServiceModel : NSObject
@property (nonatomic, assign) NSInteger errorcode;
/// 机票列表
@property (nonatomic, strong) ServiceInfoModel *data;
/// 返回说明，错误原因
@property (nonatomic, copy) NSString *message;
@end

@interface ServiceInfoModel : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) FlightTaxModel *flightTax;
@property (nonatomic, strong) CustomerModel *customer;
@property (nonatomic, strong) NSMutableArray<IdCardsModel *> *idCards;
@end

@interface FlightTaxModel : NSObject
@property (nonatomic, copy) NSString *serviceTax;
@property (nonatomic, copy) NSString *fuelTax;
@property (nonatomic, copy) NSString *insureTax;
@end

@interface CustomerModel : NSObject
@property (nonatomic, copy) NSString *kid;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *phone;
/// 1:会员 0:非会员
@property (nonatomic, assign) NSInteger usertype;

@end

@interface IdCardsModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *identityNo;
@property (nonatomic, copy) NSString *phoneNum;
/// 1:身份证 2：其他
@property (nonatomic, assign) NSInteger identityType;
@end




///// 航程航线数据
@interface SegmentModel : NSObject
/// 航班号
@property (nonatomic, copy) NSString *flightNo;
/// 航班时间(2018­-10-­12 12:00)
@property (nonatomic, copy) NSString *depDate;
/// 航班抵达时间(2018­-10-­12 12:00)
@property (nonatomic, copy) NSString *arrDate;
/// 出发如:SZX (机场三字码)
@property (nonatomic, copy) NSString *depCode;
/// 抵达如:SZX (机场三字码)
@property (nonatomic, copy) NSString *arrCode;
/// 舱位。 大写 如:Y
@property (nonatomic, copy) NSString *cabin;
/// 携带儿童为必填。儿童舱位。 大写 如:Y
@property (nonatomic, copy) NSString *chdCabin;

@end

/// 价格信息 :传入时平台验价后 生成订单 不传入价格 有 平台规则生成订单
@interface PriceDataModel : NSObject
/// 乘机人类型 1 成人 2 儿童 3 婴儿 暂不 使用
@property (nonatomic, copy) NSString *crewType;
/// 票面价
@property (nonatomic, copy) NSString *price;
/// 机建
@property (nonatomic, copy) NSString *airportTax;
/// 燃油费
@property (nonatomic, copy) NSString *fuelTax;

@end

//// 乘客信息Model
@interface PassengerModel : NSObject
/// 姓名
@property (nonatomic, copy) NSString *name;
/// 性别 1，男 2 女
@property (nonatomic, copy) NSString *sex;
/// 生日 儿童为必填(格式:2018­-05-­05
@property (nonatomic, copy) NSString *birthday;
/// 证件类型 1 身份证 2 其他证件
@property (nonatomic, copy) NSString *identityType;
/// 证件号码
@property (nonatomic, copy) NSString *identityNo;
/// 乘机人类型 1:成人 2:儿童 3:婴儿(暂不使 用)
@property (nonatomic, copy) NSString *crewType;
/// 乘客手机号 CTCM
@property (nonatomic, copy) NSString *phoneNum;
/// 证件有效期 2018­10­12
@property (nonatomic, copy) NSString *effectiveDate;


/// 仅用于新增乘机人是否有新增按钮的标识
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, assign) BOOL isSelected;
@end
NS_ASSUME_NONNULL_END
