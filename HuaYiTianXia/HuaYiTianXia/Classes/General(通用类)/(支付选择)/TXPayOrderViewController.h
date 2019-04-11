//
//  TXPayOrderViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/11.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXPayOrderViewController : TTBaseViewController
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 价格
@property (nonatomic, strong) UILabel *priceLabel;
@end

NS_ASSUME_NONNULL_END
