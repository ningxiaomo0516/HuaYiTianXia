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
    }
    return self;
}

- (void) initView{

    [self addSubview:self.imagesView_BG];
    [self addSubview:self.footerView];
    [self addSubview:self.imagesViewBox];
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.nicknameLabel];
    [self.boxView addSubview:self.levelLabel];
    [self.boxView addSubview:self.upgradeButton];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.numberLabel];
    [self addSubview:self.imagesViewAvatar_BG];
    [self addSubview:self.imagesViewAvatar];
    
    [self.imagesView_BG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(IPHONE6_W(206)+kSafeAreaBottomHeight));
    }];
    
    [self.imagesViewBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self);
    }];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.imagesViewBox);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-32));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.numberLabel.mas_top).offset(IPHONE6_W(-8));
    }];
    
    [self.upgradeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.titleLabel.mas_top).offset(IPHONE6_W(-8));
    }];
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.upgradeButton.mas_top).offset(IPHONE6_W(-8));
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.levelLabel.mas_top).offset(IPHONE6_W(-8));
    }];

    [self.imagesViewAvatar_BG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.nicknameLabel.mas_top);
    }];
    
    [self.imagesViewAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imagesViewAvatar_BG);
        make.centerY.equalTo(self.imagesViewAvatar_BG).offset(IPHONE6_W(-2));
        make.width.height.equalTo(@(IPHONE6_W(95)));
    }];
    
}

- (UIImageView *)imagesViewAvatar{
    if (!_imagesViewAvatar) {
        _imagesViewAvatar = [[UIImageView alloc] init];
        [_imagesViewAvatar lz_setCornerRadius:(IPHONE6_W(95))/2.0];
    }
    return _imagesViewAvatar;
}

- (UIImageView *)imagesViewAvatar_BG{
    if (!_imagesViewAvatar_BG) {
        _imagesViewAvatar_BG = [[UIImageView alloc] init];
        _imagesViewAvatar_BG.image = kGetImage(@"c7_头像框");
    }
    return _imagesViewAvatar_BG;
}

- (UIImageView *)imagesView_BG{
    if (!_imagesView_BG) {
        _imagesView_BG = [[UIImageView alloc] init];
        _imagesView_BG.image = kGetImage(@"c7_mine_images");
    }
    return _imagesView_BG;
}


- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kWhiteColor];
        _footerView.frame = CGRectMake(0, IPHONE6_W(192)+kSafeAreaBottomHeight, kScreenWidth, 55);
        /// 设置所需的圆角位置以及大小
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_footerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _footerView.bounds;
        maskLayer.path = maskPath.CGPath;
        _footerView.layer.mask = maskLayer;
    }
    return _footerView;
}

- (UIImageView *)imagesViewBox{
    if (!_imagesViewBox) {
        _imagesViewBox = [[UIImageView alloc] init];
        _imagesViewBox.image = kGetImage(@"c7_卡片背景");
    }
    return _imagesViewBox;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kClearColor];
    }
    return _boxView;
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
        _nicknameLabel = [UILabel lz_labelWithTitle:@"华翼天下" color:kTextColor51 font:kFontSizeMedium16];
    }
    return _nicknameLabel;
}

- (UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [UILabel lz_labelWithTitle:@"黄金会员" color:HexString(@"#E2BE84") font:kFontSizeMedium13];
    }
    return _levelLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
    }
    return _titleLabel;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium10];
    }
    return _numberLabel;
}


@end
