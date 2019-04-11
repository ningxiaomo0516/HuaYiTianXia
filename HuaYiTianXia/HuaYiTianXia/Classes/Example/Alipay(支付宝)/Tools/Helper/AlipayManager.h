//
//  AlipayManager.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/11.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface AlipayManager : NSObject
/// 打开支付宝客户端进行支付
+ (void)doAlipayPay:(TXGeneralModel *) model;
/// 打开微信支付
+ (void)doWechatPay:(TXGeneralModel *) model;
@end

NS_ASSUME_NONNULL_END
