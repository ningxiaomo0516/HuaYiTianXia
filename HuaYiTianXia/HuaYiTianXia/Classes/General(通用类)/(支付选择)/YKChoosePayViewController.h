//
//  YKChoosePayViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/10.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"
#import "TXChoosePaySingleView.h"

NS_ASSUME_NONNULL_BEGIN
@interface YKChoosePayViewController : TTBaseViewController
@property (nonatomic, strong) TXChoosePaySingleView *paySingleView;
- (id)initDictionary:(NSMutableDictionary *)parameter;
@end

NS_ASSUME_NONNULL_END
