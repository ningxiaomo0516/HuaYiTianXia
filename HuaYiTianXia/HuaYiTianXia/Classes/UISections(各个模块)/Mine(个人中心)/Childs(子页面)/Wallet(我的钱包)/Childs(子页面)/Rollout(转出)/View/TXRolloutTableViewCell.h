//
//  TXRolloutTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXRolloutTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *imagesArrow;
@property (nonatomic, strong) SCTextField *sc_textField;

@end

NS_ASSUME_NONNULL_END
