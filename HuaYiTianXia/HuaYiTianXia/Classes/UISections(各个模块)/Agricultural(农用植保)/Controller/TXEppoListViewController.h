//
//  TXEppoListViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/5.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXEppoListViewController : TTBaseViewController
/// productType 1:农业 2:蔬菜 3:水果 4:其他
@property (nonatomic, assign) NSInteger idx;
/// 2:农用植保产品(购买) 6:生态农业商城产品(消费)
@property (nonatomic, assign) NSInteger status;
@end

NS_ASSUME_NONNULL_END
