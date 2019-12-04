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
        self.imagesViewBottom.image = kGetImage(@"live_banner_bottom");
        self.imagesPlane.image = kGetImage(@"lv28_btn_到达飞机");
        self.freshLabel_s.text = @"执飞";
        self.dateLabel_s.text = @"日期";
        self.timeLabel_s.text = @"时间";
        self.flightTimeLabel_s.text = @"时长";
        self.charterLabel.text = @"包机价格：";
    }
    return self;
}

- (void)setMachineModel:(CharterMachineModel *)machineModel{
    _machineModel = machineModel;
    self.depCityLabel.text  = self.machineModel.depCity;//@"出发城市";
    self.arvCityLabel.text  = self.machineModel.arvCity;//@"到达城市";
    self.freshLabel.text    = self.machineModel.holdFly;//@"36小时后";
    self.dateLabel.text     = self.machineModel.flyDate;//@"05-21";
    self.timeLabel.text     = self.machineModel.flyTime;//@"11:00前";
    self.flightTimeLabel.text = self.machineModel.duration;//@"6h25m";
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.machineModel.price];//@"￥70000";
    [self.imagesView sd_setImageWithURL:kGetImageURL(self.machineModel.aircraftImg) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
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
    
    
    [self.contentView addSubview:self.freshLabel_s];
    [self.contentView addSubview:self.freshLabel];
    [self.contentView addSubview:self.dateLabel_s];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.timeLabel_s];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.flightTimeLabel_s];
    [self.contentView addSubview:self.flightTimeLabel];
    
    
    [self.contentView addSubview:self.linerView];
    [self.contentView addSubview:self.charterLabel];
    [self.contentView addSubview:self.priceLabel];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(IPHONE6_W(150)));
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
        make.right.equalTo(self.imagesPlane.mas_left).offset(-5);
        make.centerY.equalTo(self.imagesViewBottom);
    }];
    [self.imagesPlane mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arvCityLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.imagesViewBottom);
    }];
    [self.arvCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.imagesViewBottom);
    }];
    
    
    
    [self.freshLabel_s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.boxView.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.width.equalTo(self.dateLabel_s);
    }];
    
    [self.freshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.freshLabel_s);
        make.bottom.equalTo(self.linerView.mas_top).offset(-10);
    }];
    
    [self.dateLabel_s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.freshLabel_s);
        make.left.equalTo(self.freshLabel_s.mas_right);
        make.width.equalTo(self.timeLabel_s);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.dateLabel_s);
        make.centerY.equalTo(self.freshLabel);
    }];
    
    [self.timeLabel_s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.freshLabel_s);
        make.left.equalTo(self.dateLabel_s.mas_right);
        make.width.equalTo(self.flightTimeLabel_s);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.timeLabel_s);
        make.centerY.equalTo(self.freshLabel);
    }];
    
    [self.flightTimeLabel_s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.freshLabel_s);
        make.left.equalTo(self.timeLabel_s.mas_right);
        make.right.equalTo(self);
    }];
    
    [self.flightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.flightTimeLabel_s);
        make.centerY.equalTo(self.freshLabel);
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
        make.left.equalTo(self.charterLabel.mas_right);
        make.centerY.equalTo(self.charterLabel).offset(-2);
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
        _youhuiLabel = [self createLabelColor:kWhiteColor font:kFontSizeScBold20];
    }
    return _youhuiLabel;
}

- (UILabel *)arvCityLabel{
    if (!_arvCityLabel) {
        _arvCityLabel = [self createLabelColor:kWhiteColor font:kFontSizeMedium12];
    }
    return _arvCityLabel;
}

- (UILabel *)depCityLabel{
    if (!_depCityLabel) {
        _depCityLabel = [self createLabelColor:kWhiteColor font:kFontSizeMedium12];
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
        _charterLabel = [self createLabelColor:kTextColor51 font:kFontSizeMedium13];
    }
    return _charterLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [self createLabelColor:kPriceColor font:kFontSizeScBold22];
        _priceLabel.font = [UIFont boldSystemFontOfSize:22.0];
    }
    return _priceLabel;
}

- (UILabel *)freshLabel_s{
    if (!_freshLabel_s) {
        _freshLabel_s = [self createLabelColor:kTextColor51 font:kFontSizeMedium14];
    }
    return _freshLabel_s;
}

- (UILabel *)freshLabel{
    if (!_freshLabel) {
        _freshLabel = [self createLabelColor:kTextColor102 font:kFontSizeMedium13];
    }
    return _freshLabel;
}

- (UILabel *)dateLabel_s{
    if (!_dateLabel_s) {
        _dateLabel_s = [self createLabelColor:kTextColor51 font:kFontSizeMedium14];
    }
    return _dateLabel_s;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [self createLabelColor:kTextColor102 font:kFontSizeMedium13];
    }
    return _dateLabel;
}

- (UILabel *)timeLabel_s{
    if (!_timeLabel_s) {
        _timeLabel_s = [self createLabelColor:kTextColor51 font:kFontSizeMedium14];
    }
    return _timeLabel_s;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [self createLabelColor:kTextColor102 font:kFontSizeMedium13];
    }
    return _timeLabel;
}

- (UILabel *)flightTimeLabel_s{
    if (!_flightTimeLabel_s) {
        _flightTimeLabel_s = [self createLabelColor:kTextColor51 font:kFontSizeMedium14];
    }
    return _flightTimeLabel_s;
}

- (UILabel *)flightTimeLabel{
    if (!_flightTimeLabel) {
        _flightTimeLabel = [self createLabelColor:kTextColor102 font:kFontSizeMedium13];
    }
    return _flightTimeLabel;
}


- (UILabel *) createLabelColor:(UIColor *)color font:(UIFont *)font{
    UILabel *label = [UILabel lz_labelWithTitle:@"" color:color font:font];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
@end
