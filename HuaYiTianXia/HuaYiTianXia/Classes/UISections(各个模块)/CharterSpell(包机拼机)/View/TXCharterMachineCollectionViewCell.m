//
//  TXCharterMachineCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/31.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterMachineCollectionViewCell.h"

@implementation TXCharterMachineCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kWhiteColor;
        [self.contentView lz_setCornerRadius:5.0];
        [self initView];
//        self.dep_airport_label.text = @"科威特国际机场";
//        self.dep_city_label.text = @"科威特";
//        self.arv_airport_label.text = @"尼斯蓝色海岸国际机场";
//        self.arv_city_label.text = @"尼斯";
//        self.challengerLabel.text = @"挑战者250";
//        self.durationLabel.text = @"6h3min";
//        self.priceLabel.text = @"￥250000";
        self.imagesView.image = kGetImage(@"c49_飞机");
    }
    return self;
}

- (void)setMachineModel:(CharterMachineModel *)machineModel{
    _machineModel = machineModel;

    self.dep_airport_label.text = self.machineModel.depAirport;
    self.dep_city_label.text = self.machineModel.depCity;
    self.arv_airport_label.text = self.machineModel.arvAirport;
    self.arv_city_label.text = self.machineModel.arvCity;
    self.challengerLabel.text = self.machineModel.aircraft;
    self.durationLabel.text = self.machineModel.duration;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.machineModel.price];
}


- (void) initView{
    [self.contentView addSubview:self.liner_l_view];
    [self.contentView addSubview:self.liner_r_view];
    [self.contentView addSubview:self.dep_city_label];
    [self.contentView addSubview:self.dep_airport_label];
    [self.contentView addSubview:self.arv_city_label];
    [self.contentView addSubview:self.arv_airport_label];
    [self.contentView addSubview:self.challengerLabel];
    [self.contentView addSubview:self.durationLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.imagesView];
    CGFloat top = IPHONE6_W(8);
    CGFloat left = IPHONE6_W(15);
    [self.dep_airport_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.top.equalTo(@(top));
    }];
    [self.arv_airport_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dep_airport_label);
        make.right.equalTo(self.mas_right).offset(-left);
    }];
    [self.dep_city_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_airport_label);
        make.top.equalTo(self.dep_airport_label.mas_bottom).offset(top);
    }];
    
    [self.arv_city_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dep_city_label);
        make.right.equalTo(self.arv_airport_label);
    }];
    [self.challengerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_airport_label);
        make.bottom.equalTo(self.durationLabel.mas_top).offset(-top);
    }];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_airport_label);
        make.bottom.equalTo(self.mas_bottom).offset(-top);
    }];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.dep_city_label);
    }];
    
    [self.liner_l_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imagesView);
        make.right.equalTo(self.imagesView.mas_left).offset(-top);
        make.height.equalTo(@(0.5));
        make.width.equalTo(@(60));
    }];
    [self.liner_r_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imagesView);
        make.left.equalTo(self.imagesView.mas_right).offset(top);
        make.height.width.equalTo(self.liner_l_view);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arv_airport_label);
        make.bottom.equalTo(self.mas_bottom).offset(-left);
    }];
    
    [self.priceLabel lz_setCornerRadius:CGRectGetHeight(self.priceLabel.frame)/2];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UIView *)liner_l_view{
    if (!_liner_l_view) {
        _liner_l_view = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _liner_l_view;
}

- (UIView *)liner_r_view{
    if (!_liner_r_view) {
        _liner_r_view = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _liner_r_view;
}

- (UILabel *)dep_city_label{
    if (!_dep_city_label) {
        _dep_city_label = [self createLabelWithColor:kTextColor51 font:kFontSizeScBold15];
        _dep_city_label.font = [UIFont boldSystemFontOfSize:15];
    }
    return _dep_city_label;
}

- (UILabel *)dep_airport_label{
    if (!_dep_airport_label) {
        _dep_airport_label = [self createLabelWithColor:kTextColor153 font:kFontSizeScBold10];
        _dep_airport_label.font = [UIFont boldSystemFontOfSize:11];
    }
    return _dep_airport_label;
}

- (UILabel *)arv_city_label{
    if (!_arv_city_label) {
        _arv_city_label = [self createLabelWithColor:kTextColor51 font:kFontSizeScBold15];
        _arv_city_label.font = [UIFont boldSystemFontOfSize:15];
    }
    return _arv_city_label;
}

- (UILabel *)arv_airport_label{
    if (!_arv_airport_label) {
        _arv_airport_label = [self createLabelWithColor:kTextColor153 font:kFontSizeScBold10];
        _arv_airport_label.font = [UIFont boldSystemFontOfSize:11];
    }
    return _arv_airport_label;
}

- (UILabel *)challengerLabel{
    if (!_challengerLabel) {
        _challengerLabel = [self createLabelWithColor:kTextColor102 font:kFontSizeScBold13];
        _challengerLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _challengerLabel;
}

- (UILabel *)durationLabel{
    if (!_durationLabel) {
        _durationLabel = [self createLabelWithColor:kTextColor102 font:kFontSizeScBold13];
        _durationLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _durationLabel;
}

- (SCCustomMarginLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[SCCustomMarginLabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.backgroundColor = kThemeColorHex;
        _priceLabel.textColor = kWhiteColor;
        _priceLabel.font = kFontSizeMedium13;
        _priceLabel.edgeInsets    = UIEdgeInsetsMake(2.f, 4.f, 2.f, 4.f); // 设置左内边距
        [_priceLabel lz_setCornerRadius:3.0];
        [_priceLabel sizeToFit]; // 重新计算尺寸
    }
    return _priceLabel;
}

- (UILabel *)createLabelWithColor:(UIColor *)color font:(UIFont *)font{
    UILabel *label = [UILabel lz_labelWithTitle:@"" color:color font:font];
    return label;
}
@end
