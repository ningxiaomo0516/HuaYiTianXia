//
//  TXCharterSpellMachineCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterSpellMachineCollectionViewCell.h"

@implementation TXCharterSpellMachineCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kWhiteColor;
        [self.contentView lz_setCornerRadius:5.0];
        [self setupUI];
        self.youhuiLabel.text = @"特惠包机";
        self.arvCityLabel.text = @"出发城市";
        self.depCityLabel.text = @"到达城市";
        self.imagesViewBottom.image = kGetImage(@"live_banner_bottom");
        self.imagesPlane.image = kGetImage(@"lv28_btn_到达飞机");
        self.imagesView.image = kGetImage(@"lv28_btn_tu6");
        
        self.charterLabel.text = @"包机价格：";
        self.priceLabel.text = @"￥70000";
    }
    return self;
}

- (void) setupUI{
    [self.contentView addSubview:self.boxView];
    [self.boxView addSubview:self.imagesView];
    [self.boxView addSubview:self.imagesRank];
    [self.boxView addSubview:self.imagesViewBottom];
    [self.boxView addSubview:self.youhuiLabel];
    [self.boxView addSubview:self.arvCityLabel];
    [self.boxView addSubview:self.depCityLabel];
    [self.boxView addSubview:self.imagesPlane];
    
    
    [self.contentView addSubview:self.linerView];
    [self.contentView addSubview:self.charterLabel];
    [self.contentView addSubview:self.priceLabel];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(IPHONE6_W(100)));
    }];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.boxView);
    }];
    [self.imagesRank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self);
    }];
    
    [self.imagesViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.boxView);
        make.height.equalTo(@(35));
    }];
    [self.youhuiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imagesViewBottom);
        make.left.equalTo(@(15));
    }];
    [self.depCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.imagesViewBottom);
    }];
    [self.imagesPlane mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.depCityLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.imagesViewBottom);
    }];
    [self.arvCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imagesPlane.mas_left).offset(-5);
        make.centerY.equalTo(self.imagesViewBottom);
    }];
    
    
    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(self.mas_bottom).offset(-40);
    }];
    [self.charterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.bottom.equalTo(self);
        make.top.equalTo(self.linerView.mas_bottom);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.charterLabel.mas_right).offset(5);
        make.centerY.equalTo(self.charterLabel);
    }];
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _boxView;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UIImageView *)imagesRank{
    if (!_imagesRank) {
        _imagesRank = [[UIImageView alloc] init];
    }
    return _imagesRank;
}

- (UIImageView *)imagesViewBottom{
    if (!_imagesViewBottom) {
        _imagesViewBottom = [[UIImageView alloc] init];
    }
    return _imagesViewBottom;
}

- (UILabel *)youhuiLabel{
    if (!_youhuiLabel) {
        _youhuiLabel = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeScBold20];
    }
    return _youhuiLabel;
}

- (UILabel *)arvCityLabel{
    if (!_arvCityLabel) {
        _arvCityLabel = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium12];
    }
    return _arvCityLabel;
}

- (UILabel *)depCityLabel{
    if (!_depCityLabel) {
        _depCityLabel = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium12];
    }
    return _depCityLabel;
}

- (UIImageView *)imagesPlane{
    if (!_imagesPlane) {
        _imagesPlane = [[UIImageView alloc] init];
    }
    return _imagesPlane;
}

- (UIView *)linerView{
    if (!_linerView) {
        _linerView = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView;
}

- (UILabel *)charterLabel{
    if (!_charterLabel) {
        _charterLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium13];
    }
    return _charterLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"#EDD08E") font:kFontSizeMedium13];
    }
    return _priceLabel;
}
@end
