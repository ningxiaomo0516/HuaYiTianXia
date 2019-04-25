//
//  TXBecomeVipCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/23.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXBecomeVipCollectionViewCell.h"

@implementation TXBecomeVipCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setChecked:(BOOL)checked isClick:(BOOL)isClick{
//    if (checked && isClick) {
    if (checked){
        [_boxView setBorderColor:HexString(@"#C79538")];
//        if (isClick) {
//            self.titleLabel.textColor = kTextColor51;
//            self.priceLabel.textColor = HexString(@"#C79538");
//        }else{
//            self.titleLabel.textColor = kColorWithRGB(210, 210, 210);
//            self.priceLabel.textColor = kColorWithRGB(210, 210, 210);
//        }
    } else {
        [_boxView setBorderColor:kColorWithRGB(210, 210, 210)];
//        if (isClick) {
//            self.titleLabel.textColor = kColorWithRGB(210, 210, 210);
//            self.priceLabel.textColor = kColorWithRGB(210, 210, 210);
//        }else{
//            self.titleLabel.textColor = kTextColor51;
//            self.priceLabel.textColor = HexString(@"#C79538");
//        }
    }
}

- (void)setupUI {
    [self addSubview:self.boxView];
    
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.priceLabel];
    [self.boxView addSubview:self.identityLabel];
    [self addSubview:self.imagesView];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self);
        make.top.equalTo(@(IPHONE6_W(7)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.boxView);
        make.top.equalTo(@IPHONE6_W(9));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.boxView);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.boxView);
    }];
    [self.identityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.boxView);
        make.bottom.equalTo(self.mas_bottom).offset(-9);
        make.height.equalTo(@(IPHONE6_W(20)));
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"#C79538") font:kFontSizeMedium15];
    }
    return _priceLabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.image = kGetImage(@"c22_btn_超值");
        _imagesView.hidden = YES;
    }
    return _imagesView;
}

- (SCCustomMarginLabel *)identityLabel{
    if (!_identityLabel) {
        _identityLabel = [[SCCustomMarginLabel alloc] init];
        _identityLabel.textColor = kWhiteColor;
        _identityLabel.backgroundColor = HexString(@"#E1C595");
        _identityLabel.font = kFontSizeMedium10;
        [_identityLabel lz_setCornerRadius:IPHONE6_W(10.0)];
        _identityLabel.edgeInsets    = UIEdgeInsetsMake(0.f, 12.f, 0.f, 12.f); // 设置左内边距
    }
    return _identityLabel;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        [_boxView lz_setCornerRadius:10.0];
        [_boxView setBorderColor:kColorWithRGB(210, 210, 210)];
        [_boxView setBorderWidth:1.0];
    }
    return _boxView;
}
@end
