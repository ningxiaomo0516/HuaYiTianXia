//
//  TXLogisticModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LogisticModel,LogisticData,TracesList;
@interface TXLogisticModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
/// 物流数据
@property (nonatomic, strong) LogisticData *data;
@end

@interface LogisticData : NSObject
/// 物流公司编号
@property (nonatomic, copy) NSString *abbreviation;
/// 快递API查询 输入信息
@property (nonatomic, copy) NSString *expressMsg;
/// 快递API查询状态 0：失败 1：成功
@property (nonatomic, assign) NSInteger expressStatus;
/// 物流信息
@property (nonatomic, strong) LogisticModel *logisticInfo;
/// 物流订单号
@property (nonatomic, copy) NSString *logisticsNo;
/// 物流公司logo
@property (nonatomic, copy) NSString *logoImg;
/// 物流公司名字
@property (nonatomic, copy) NSString *name;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 收货地址
@property (nonatomic, copy) NSString *receivingAddress;

//// 产品信息

/// 产品图片
@property (nonatomic, copy) NSString *imageText;
/// 产品标题
@property (nonatomic, copy) NSString *pro_title;
/// 产品副标题
@property (nonatomic, copy) NSString *pro_subtitle;

@end

@interface LogisticModel : NSObject
/// 物流状态：2-在途中,3-已签收,4-问题件（0时不显示状态轴）
@property (nonatomic, assign) NSInteger State;
/// 1-已揽收， 2-在途中， 201-到达派件城市， 202-派件中， 211-已放入快递柜或驿站， 3-已签收， 311-已取出快递柜或驿站， 4-问题件， 401-发货无信息， 402-超时未签收， 403-超时未更新， 404-拒收（退件）， 412-快递柜或驿站超时未取
@property (nonatomic, assign) NSInteger StateEx;
/// 请求状态
@property (nonatomic, assign) NSInteger Success;
/// 物流详情（为空数组时，表示无物流信息）
@property (nonatomic, strong) NSMutableArray<TracesList *> *list;
@end

/// 物流轨迹
@interface TracesList : NSObject
/**
 1-已揽收,
 2-在途中, 201-到达派件城市, 202-派件中, 211-已放入快递柜或驿站,
 3-已签收, 311-已取出快递柜或驿站,
 4-问题件, 401-发货无信息, 402-超时未签收, 403-超时未更新, 404-拒收(退件), 412-快递柜或驿站超时未取
 */
@property (nonatomic, assign) NSInteger Action;
/// 描述
@property (nonatomic, copy) NSString *AcceptStation;
/// 时间
@property (nonatomic, copy) NSString *AcceptTime;
/// 当前城市
@property (nonatomic, copy) NSString *Location;
/// 备注
@property (nonatomic, copy) NSString *Remark;
/// 当前物流状态：2-在途中,3-已签收,4-问题件（0时不显示状态轴）
@property (nonatomic, assign) NSInteger state;
@end

NS_ASSUME_NONNULL_END
