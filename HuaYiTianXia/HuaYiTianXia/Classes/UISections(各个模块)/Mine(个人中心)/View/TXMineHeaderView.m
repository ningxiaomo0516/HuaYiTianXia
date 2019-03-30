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
        self.imagesViewAvatar.image = kGetImage(@"user1");
    }
    return self;
}

- (void) initView{
    [self addSubview:self.imagesView];
    [self addSubview:self.boxView];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@(IPHONE6_W(44)));
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(kNavBarHeight));
    }];
    [self.boxView addSubview:self.imagesViewAvatar];
    [self.boxView addSubview:self.nickNameLabel];
    [self.boxView addSubview:self.kidLabel];
    [self.boxView addSubview:self.levelLabel];
    [self.imagesViewAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(IPHONE6_W(36)));
        make.left.equalTo(@(15));
        make.centerY.equalTo(self.boxView);
    }];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagesViewAvatar.mas_top);
        make.left.equalTo(self.imagesViewAvatar.mas_right).offset(12);
    }];
    [self.kidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel);
        make.bottom.equalTo(self.boxView.mas_bottom);
    }];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.boxView);
    }];
    
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.image = kGetImage(@"main_header_bg");
    }
    return _imagesView;
}

- (UIImageView *)imagesViewAvatar{
    if (!_imagesViewAvatar) {
        _imagesViewAvatar = [[UIImageView alloc] init];
        [_imagesViewAvatar lz_setCornerRadius:(IPHONE6_W(36))/2.0];
    }
    return _imagesViewAvatar;
}

- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel lz_labelWithTitle:@"华翼天下" color:kWhiteColor font:kFontSizeMedium14];
    }
    return _nickNameLabel;
}

- (UILabel *)kidLabel{
    if (!_kidLabel) {
        _kidLabel = [UILabel lz_labelWithTitle:@"ID:12345" color:kWhiteColor font:kFontSizeMedium14];
    }
    return _kidLabel;
}

- (UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [UILabel lz_labelWithTitle:@"普通会员" color:kWhiteColor font:kFontSizeMedium12];
    }
    return _levelLabel;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kClearColor];
    }
    return _boxView;
}

@end
