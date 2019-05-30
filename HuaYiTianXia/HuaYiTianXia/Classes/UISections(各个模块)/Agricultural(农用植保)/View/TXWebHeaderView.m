//
//  TXWebHeaderView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/8.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXWebHeaderView.h"

@implementation TXWebHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kClearColor;
        [self initView];
        TTLog(@" -- %f",self.width);
    }
    return self;
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.saveButton];
    [self addSubview:self.imagesView];
    [self addSubview:self.receiveBtn];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(IPHONE6_W(20)));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE6_W(10));
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(IPHONE6_W(15));
        make.left.equalTo(@(IPHONE6_W(15)));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.height.equalTo(@(IPHONE6_W(45)));
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self);
    }];
    [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imagesView);
        make.right.equalTo(self.imagesView.mas_right).offset(IPHONE6_W(-20));
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium34];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _subtitleLabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.tag = 100;
        [Utils lz_setButtonWithBGImage:_saveButton cornerRadius:45/2.0];
    }
    return _saveButton;
}

- (UIButton *)receiveBtn{
    if (!_receiveBtn) {
        _receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _receiveBtn.tag = 200;
    }
    return _receiveBtn;
}
@end
