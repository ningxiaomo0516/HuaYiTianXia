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
        self.avatarView.image = kGetImage(@"我的_头像_背景");
        if (kiPhoneX) {
            self.imagesView_BG.image = kGetImage(@"c7_mine_背景_x");
        }else{
            self.imagesView_BG.image = kGetImage(@"c7_mine_背景");
        }
    }
    return self;
}

- (void) initView{
    [self.imagesViewAvatar lz_setCornerRadius:(IPHONE6_W(70))/2.0];
    self.titleLabel.hidden = YES;
    [self addSubview:self.imagesView_BG];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.images_level];
    [self addSubview:self.upgradeButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.avatarView];
    [self.avatarView addSubview:self.imagesViewAvatar];
    
    [self.imagesView_BG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(kNavBarHeight));
    }];
    
    [self.imagesViewAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.avatarView);
        make.width.height.equalTo(@(IPHONE6_W(70)));
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.avatarView.mas_bottom).offset(IPHONE6_W(7));
    }];
    
    [self.images_level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nicknameLabel);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(IPHONE6_W(4));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(IPHONE6_W(4));
    }];
    
    [self.upgradeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(IPHONE6_W(8));
    }];
    
}

- (UIImageView *)imagesViewAvatar{
    if (!_imagesViewAvatar) {
        _imagesViewAvatar = [[UIImageView alloc] init];
    }
    return _imagesViewAvatar;
}

- (UIImageView *)avatarView{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
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
        _nicknameLabel = [UILabel lz_labelWithTitle:@"杨美玲" color:kWhiteColor font:kFontSizeRegular16];
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

@end
