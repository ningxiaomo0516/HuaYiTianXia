//
//  TXOrderModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/30.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderRecordsModel,OrderModel;
@interface TXOrderModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) OrderRecordsModel *data;
@end

@interface OrderRecordsModel : NSObject
/// 页码
@property (nonatomic, copy) NSString *current;
/// 总页数
@property (nonatomic, copy) NSString *pages;
/// 产品详情Model数据
@property (nonatomic, strong) NSMutableArray<OrderModel *> *records;
@end

@interface OrderModel : NSObject
/// 订单id
@property (nonatomic, copy) NSString *kid;
/// 时间
@property (nonatomic, copy) NSString *housTime;
/// 金额
@property (nonatomic, copy) NSString *totalMoney;
/// 时间(数据库时间)
@property (nonatomic, copy) NSString *time;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 型号(规格)
@property (nonatomic, copy) NSString *spec;
/// 封面图片路径
@property (nonatomic, copy) NSString *coverimg;
/// 日期
@property (nonatomic, copy) NSString *yearTime;
/// VR币
@property (nonatomic, copy) NSString *totalCurrency;
/// 产品所属分类 如：2：农用植保产品；3：VR产品；
@property (nonatomic, assign) NSInteger status;
@end
NS_ASSUME_NONNULL_END
