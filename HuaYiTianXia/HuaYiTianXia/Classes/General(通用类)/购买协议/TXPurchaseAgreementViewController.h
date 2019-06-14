//
//  TXPurchaseAgreementViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^PurchaseAgreementBlock) (NSString *imageURL);
@interface TXPurchaseAgreementViewController : TTBaseViewController
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) NSString *amountText;
//定义一个block
@property (nonatomic, copy) PurchaseAgreementBlock completionHandler;
@end

NS_ASSUME_NONNULL_END
