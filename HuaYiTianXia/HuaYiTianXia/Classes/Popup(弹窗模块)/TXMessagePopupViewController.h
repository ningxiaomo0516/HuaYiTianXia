//
//  TXMessagePopupViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/13.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXMessagePopupViewController : TTBaseViewController
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *enterButton;
@end

NS_ASSUME_NONNULL_END
