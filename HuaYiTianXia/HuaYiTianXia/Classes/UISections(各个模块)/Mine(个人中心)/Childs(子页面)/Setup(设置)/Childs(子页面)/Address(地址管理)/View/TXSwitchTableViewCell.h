//
//  TXSwitchTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXSwitchTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *isSwitch;

@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *helpButton;

- (void) showlabel;
@end

NS_ASSUME_NONNULL_END
