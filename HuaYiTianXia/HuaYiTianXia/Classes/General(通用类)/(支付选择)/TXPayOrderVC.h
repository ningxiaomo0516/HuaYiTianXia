//
//  TXPayOrderVC.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/12.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXPayOrderVC : TTBaseViewController
@property (nonatomic, strong) UIView *boxView;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 价格
@property (nonatomic, strong) UILabel *totalPriceLabel;
/// 规格标题
@property (nonatomic, strong) UILabel *specTipsLabel;
/// 规格
@property (nonatomic, strong) UILabel *specLabel;
/// 加入货币
@property (nonatomic, strong) UILabel *priceTipsLabel;
/// 累加金额
@property (nonatomic, strong) UILabel *priceLabel;
/// 减少按钮
@property (nonatomic, strong) UIButton *minusBtn;
/// 增加按钮
@property (nonatomic, strong) UIButton *increaseBtn;

@property (nonatomic, strong) UIView *linerView1;
@property (nonatomic, strong) UIView *linerView2;

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UILabel *tipsLabel;
@end

NS_ASSUME_NONNULL_END
