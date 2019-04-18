//
//  TXResetTradingViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/4.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXResetTradingViewController : TTBaseViewController

/// 0:第一次设置 1:重复设置 2:验证交易密码
@property (nonatomic, assign) NSInteger pageType;
/// 第一次输入的密码
@property (nonatomic, copy) NSString *password;
@end

NS_ASSUME_NONNULL_END
