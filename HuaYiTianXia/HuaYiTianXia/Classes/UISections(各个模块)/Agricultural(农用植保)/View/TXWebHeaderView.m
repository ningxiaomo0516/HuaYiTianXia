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
    }
    return self;
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.saveButton];
    [self addSubview:self.imagesView];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(IPHONE6_W(20)));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE6_W(10));
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(IPHONE6_W(15));
//        make.left.equalTo(@(15));
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.height.equalTo(@(45));
        
        make.centerX.equalTo(self);
        make.height.equalTo(@(IPHONE6_W(45)));
        make.width.equalTo(@(IPHONE6_W(345)));
//        make.left.equalTo(@(15));
//        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(15);

    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self);
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
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kFontSizeMedium15;
        [_saveButton setBackgroundImage:kGetImage(@"c31_denglu") forState:UIControlStateNormal];
    }
    return _saveButton;
}
@end
