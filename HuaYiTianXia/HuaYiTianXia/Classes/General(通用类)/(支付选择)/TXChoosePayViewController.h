//
//  TXChoosePayViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/10.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^ChoosePayTypeBlock) (NSString *text,NSInteger kid);
@interface TXChoosePayViewController : TTBaseViewController

//定义一个block
@property (nonatomic, copy) ChoosePayTypeBlock typeBlock;
@end

NS_ASSUME_NONNULL_END
