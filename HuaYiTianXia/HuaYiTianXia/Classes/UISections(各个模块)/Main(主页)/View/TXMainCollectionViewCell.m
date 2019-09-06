//
//  TXMainCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/9/4.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMainCollectionViewCell.h"

@implementation TXMainCollectionViewCell
/// 方块视图的缓存池标示
+ (NSString *)reuseIdentifier{
    static NSString *reuseIdentifier = @"TXMainCollectionViewCell";
    return reuseIdentifier;
}

//获取方块视图对象
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    TXMainCollectionViewCell *tools=[collectionView dequeueReusableCellWithReuseIdentifier:[TXMainCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    return tools;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void) initView{
    [self lz_setCornerRadius:3.0];
    self.backgroundColor = kWhiteColor;
    self.layer.shadowColor = kColorWithRGB(210, 210, 210).CGColor;
    self.layer.shadowOffset = CGSizeMake(0,2.0f);
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 1.0f;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
    
    
    
    self.imagesPlane.image = kGetImage(@"xy_飞机");
    [self addSubview:self.arvCityLabel];
    [self addSubview:self.depCityLabel];
    [self addSubview:self.imagesPlane];
    [self addSubview:self.imagesView];
    [self addSubview:self.priceLabel];
    [self addSubview:self.datetimeLabel];
    [self addSubview:self.discountLabel];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(88));
    }];
    
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(5));
    }];
    
    [self.imagesPlane mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imagesView.mas_bottom).offset(10);
    }];
    
    [self.depCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imagesPlane.mas_left).offset(-10);
        make.centerY.equalTo(self.imagesPlane);
    }];
    [self.arvCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesPlane.mas_right).offset(10);
        make.centerY.equalTo(self.imagesPlane);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imagesPlane.mas_bottom).offset(2);
    }];
    
    [self.datetimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
}

- (UILabel *)arvCityLabel{
    if (!_arvCityLabel) {
        _arvCityLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _arvCityLabel;
}

- (UILabel *)depCityLabel{
    if (!_depCityLabel) {
        _depCityLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _depCityLabel;
}

- (UIImageView *)imagesPlane{
    if (!_imagesPlane) {
        _imagesPlane = [[UIImageView alloc] init];
    }
    return _imagesPlane;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:kPriceColor font:kFontSizeMedium18];
    }
    return _priceLabel;
}

- (UILabel *)datetimeLabel{
    if (!_datetimeLabel) {
        _datetimeLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
    }
    return _datetimeLabel;
}

- (UILabel *)discountLabel{
    if (!_discountLabel) {
        _discountLabel = [[SCCustomMarginLabel alloc] init];
        _discountLabel.textAlignment = NSTextAlignmentCenter;
        _discountLabel.backgroundColor = kThemeColorHex;
        _discountLabel.textColor = kWhiteColor;
        _discountLabel.font = kFontSizeMedium9;
        _discountLabel.edgeInsets    = UIEdgeInsetsMake(2.f, 4.f, 2.f, 4.f); // 设置左内边距
        [_discountLabel lz_setCornerRadius:3.0];
        [_discountLabel sizeToFit]; // 重新计算尺寸
    }
    return _discountLabel;
}
@end
