//
//  TXPayPasswordViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/9.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXPayPasswordViewController : TTBaseViewController

@property (nonatomic, copy) NSString *tipsText;
@property (nonatomic, copy) NSString *integralText;
/// 0:转出 1:复投 2:转换 3:商城余额购买 4:新增机票购买
@property (nonatomic, assign) NSInteger pageType;

@end

NS_ASSUME_NONNULL_END
