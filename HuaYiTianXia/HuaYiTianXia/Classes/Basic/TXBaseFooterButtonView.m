//
//  TXBaseFooterButtonView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/31.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXBaseFooterButtonView.h"

@implementation TXBaseFooterButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    [self addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self);
        make.height.equalTo(@(IPHONE6_W(45)));
        make.bottom.equalTo(self.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.tag = 2;
        [_saveButton setTitle:@"预约申请" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_saveButton cornerRadius:0];
    }
    return _saveButton;
}
@end
