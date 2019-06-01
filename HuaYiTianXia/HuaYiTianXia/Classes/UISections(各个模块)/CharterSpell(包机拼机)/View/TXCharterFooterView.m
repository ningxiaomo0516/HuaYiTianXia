//
//  TXCharterFooterView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/1.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterFooterView.h"

@implementation TXCharterFooterView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void) initView{
    [self addSubview:self.submitButton];
    [self addSubview:self.totalTitleLabel];
    [self addSubview:self.totalAmountLabel];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat height = IPHONE6_W(35);
        CGFloat top = (kTabBarHeight-height-kSafeAreaBottomHeight)/2;
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.height.equalTo(@(height));
        make.width.equalTo(@(IPHONE6_W(85)));
        make.top.equalTo(@(top));
    }];
    
    [self.totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.submitButton.mas_left).offset(-15);
        make.centerY.equalTo(self.submitButton);
    }];
    
    [self.totalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalAmountLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.submitButton);
    }];
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _submitButton.titleLabel.font = kFontSizeMedium15;
        [_submitButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:kButtonColorNormal forState:UIControlStateNormal];
        [_submitButton lz_setCornerRadius:3.0];
        MV(weakSelf);
        [_submitButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//            [weakSelf submitBtnClick:self.submitButton];
        }];
    }
    return _submitButton;
}

- (UILabel *)totalAmountLabel{
    if (!_totalAmountLabel) {
        _totalAmountLabel = [UILabel lz_labelWithTitle:@"" color:kColorWithRGB(211, 0, 0) font:kFontSizeMedium15];
    }
    return _totalAmountLabel;
}

- (UILabel *)totalTitleLabel{
    if (!_totalTitleLabel) {
        _totalTitleLabel = [UILabel lz_labelWithTitle:@"总计:" color:kTextColor102 font:kFontSizeMedium15];
    }
    return _totalTitleLabel;
}

@end
