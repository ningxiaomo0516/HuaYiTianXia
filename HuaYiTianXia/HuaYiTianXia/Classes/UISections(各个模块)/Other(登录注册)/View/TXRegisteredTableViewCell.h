//
//  TXRegisteredTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXRegisteredTableViewCell : UITableViewCell
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 输入框
@property (nonatomic, strong) UITextField *textField;
/// 获取验证码
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIView *linerView;
@end

NS_ASSUME_NONNULL_END
