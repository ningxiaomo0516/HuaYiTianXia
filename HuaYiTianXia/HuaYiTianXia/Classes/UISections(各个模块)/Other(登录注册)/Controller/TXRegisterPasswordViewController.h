//
//  TXRegisterPasswordViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXRegisterPasswordViewController : TTBaseTableViewController
/// 0:注册 1:找回密码
@property (nonatomic, assign) NSInteger pageType;
/// 手机号
@property (copy, nonatomic) NSString *telphone;
@end

NS_ASSUME_NONNULL_END
