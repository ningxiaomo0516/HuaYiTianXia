//
//  TXMineHeaderView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMineHeaderView.h"

@implementation TXMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor = kWhiteColor;
        self.imagesViewAvatar.image = kGetImage(@"user1");
        if (kiPhoneX) {
            self.imagesView_BG.image = kGetImage(@"c7_mine_背景_x");
        }else{
            self.imagesView_BG.image = kGetImage(@"c7_mine_背景");
        }
        self.images_level.image = kGetImage(@"c77_黑钻");
    }
    return self;
}

- (void) initView{

    [self addSubview:self.imagesView_BG];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.images_level];
    [self addSubview:self.upgradeButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.numberLabel];
    [self addSubview:self.avatarView];
    [self.avatarView addSubview:self.imagesViewAvatar];
    
    [self.imagesView_BG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.equalTo(@(IPHONE6_W(95)));
        make.top.equalTo(@(IPHONE6_W(62)+kSafeAreaBottomHeight));
    }];
    
    [self.imagesViewAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.avatarView);
        make.width.height.equalTo(@(IPHONE6_W(90)));
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.avatarView.mas_bottom).offset(10);
    }];
    
    [self.images_level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nicknameLabel);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(5);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.numberLabel.mas_right).offset(5);
    }];
    
    [self.upgradeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
}

- (UIImageView *)imagesViewAvatar{
    if (!_imagesViewAvatar) {
        _imagesViewAvatar = [[UIImageView alloc] init];
        [_imagesViewAvatar lz_setCornerRadius:(IPHONE6_W(95))/2.0];
    }
    return _imagesViewAvatar;
}

- (UIView *)avatarView{
    if (!_avatarView) {
        _avatarView = [UIView lz_viewWithColor:[kWhiteColor colorWithAlphaComponent:0.15]];
        [_avatarView lz_setCornerRadius:(IPHONE6_W(90))/2.0];
    }
    return _avatarView;
}

- (UIImageView *)imagesView_BG{
    if (!_imagesView_BG) {
        _imagesView_BG = [[UIImageView alloc] init];
    }
    return _imagesView_BG;
}

- (UIButton *)upgradeButton{
    if (!_upgradeButton) {
        _upgradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_upgradeButton setImage:kGetImage(@"c7_会员升级") forState:UIControlStateNormal];
    }
    return _upgradeButton;
}

- (UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [UILabel lz_labelWithTitle:@"华翼天下" color:kWhiteColor font:kFontSizeMedium16];
    }
    return _nicknameLabel;
}

- (UIImageView *)images_level{
    if (!_images_level) {
        _images_level = [[UIImageView alloc] init];
    }
    return _images_level;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium12];
    }
    return _titleLabel;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium10];
    }
    return _numberLabel;
}


@end
