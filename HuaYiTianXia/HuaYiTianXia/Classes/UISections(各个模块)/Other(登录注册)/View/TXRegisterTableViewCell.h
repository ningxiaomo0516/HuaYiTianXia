//
//  TXRegisterTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXRegisterTableViewCell : UITableViewCell
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 输入框
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *linerView;
@end

NS_ASSUME_NONNULL_END
