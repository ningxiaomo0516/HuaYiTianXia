//
//  TXMessageChildHeaderView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/30.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMessageChildHeaderView.h"

@implementation TXMessageChildHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor = kWhiteColor;
        self.imagesViewAvatar.image = kGetImage(@"test_work");
        self.nicknameLabel.text = @"华谊会员";
        self.amountLabel.text = @"-100";
        self.statusLabel.text = @"交易成功";
    }
    return self;
}

- (void) initView{
    [self addSubview:self.imagesViewAvatar];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.amountLabel];
    [self addSubview:self.statusLabel];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(IPHONE6_W(30)/2);
        make.top.equalTo(@(IPHONE6_W(30)));
    }];
    [self.imagesViewAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nicknameLabel.mas_left).offset(IPHONE6_W(-5));
        make.centerY.equalTo(self.nicknameLabel);
        make.height.width.equalTo(@(IPHONE6_W(30)));
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(IPHONE6_W(10));
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.amountLabel.mas_bottom).offset(IPHONE6_W(5));
    }];
}

- (UIImageView *)imagesViewAvatar{
    if (!_imagesViewAvatar) {
        _imagesViewAvatar = [[UIImageView alloc] init];
        [_imagesViewAvatar lz_setCornerRadius:(IPHONE6_W(30))/2.0];
    }
    return _imagesViewAvatar;
}

- (UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium15];
    }
    return _nicknameLabel;
}

- (UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium19];
        _amountLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
    }
    return _amountLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium15];
    }
    return _statusLabel;
}

@end
