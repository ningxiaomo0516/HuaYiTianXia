//
//  TXCharterFooterView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/1.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXCharterFooterView : UIView
/// 提交按钮
@property (nonatomic, strong) UIButton      *submitButton;
/// 金额总计文字
@property (nonatomic, strong) UILabel       *totalTitleLabel;
/// 总金额
@property (nonatomic, strong) UILabel       *totalAmountLabel;
@end

NS_ASSUME_NONNULL_END
