//
//  TXAddInvoiceViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/9.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"
#import "TXInvoiceModel.h"

NS_ASSUME_NONNULL_BEGIN
// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^invoiceViewBlock) (void);
@interface TXAddInvoiceViewController : TTBaseViewController
//定义一个block
@property (nonatomic, copy) invoiceViewBlock invoiceBlock;

- (instancetype)initInvoiceModel:(InvoiceModel *)invoiceModel;
@end

NS_ASSUME_NONNULL_END
