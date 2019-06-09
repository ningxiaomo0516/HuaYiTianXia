//
//  TXInvoiceModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/9.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class InvoiceModel;
@interface TXInvoiceModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) NSMutableArray<InvoiceModel *> *list;
@end

@interface InvoiceModel : NSObject
/// 发票ID
@property (nonatomic, copy) NSString *kid;
/// 发票抬头
@property (nonatomic, copy) NSString *invoiceTaxNumber;
/// 发票税号
@property (nonatomic, copy) NSString *invoiceRise;
@end

NS_ASSUME_NONNULL_END
