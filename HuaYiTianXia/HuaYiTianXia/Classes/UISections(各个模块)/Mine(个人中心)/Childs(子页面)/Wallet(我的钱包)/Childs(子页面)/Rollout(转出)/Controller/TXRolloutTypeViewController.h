//
//  TXRolloutTypeViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/3.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^RolloutTypeBlock) (NSString *text);

@interface TXRolloutTypeViewController : TTBaseTableViewController
//定义一个block
@property (nonatomic, copy) RolloutTypeBlock typeBlock;
@end

NS_ASSUME_NONNULL_END
