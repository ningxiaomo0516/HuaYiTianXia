//
//  TXShareViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^didSelectItemAtIndexPathBlock) (NSInteger idx,NSString *title);
@interface TXShareViewController : TTBaseViewController
//定义一个block
@property (nonatomic, copy) didSelectItemAtIndexPathBlock selectItemBlock;
@end

NS_ASSUME_NONNULL_END
