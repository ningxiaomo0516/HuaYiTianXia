//
//  YKTicketBookingHeaderView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/7.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKTicketBookingHeaderView.h"

@implementation YKTicketBookingHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor = kClearColor;
        
        self.boxView.layer.shadowColor      = kColorWithRGB(210, 210, 210).CGColor;
        self.boxView.layer.shadowOffset     = CGSizeMake(0,2.0f);
        self.boxView.layer.shadowRadius     = 2.0f;
        self.boxView.layer.shadowOpacity    = 1.0f;
        self.boxView.layer.masksToBounds    = NO;
        self.boxView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.boxView.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    }
    return self;
}

- (void) initView{
//    self.dep_timeLabel.text = @"07:40";
//    self.arv_timeLabel.text = @"10:30";
//    self.arv_airportLabel.text = @"上海 浦东 T2";
//    self.dep_airportLabel.text = @"成都 双流 T1";
//    
//    self.flightNoLabel.text = @"川航3U8961";
//    self.planeTypeLabel.text = @"空客A350-900";
//    self.distanceLabel.text = @"里程1390km";
//    self.mealLabel.text = @"无餐食";
    
    [self.circleView_t lz_setCornerRadius:2.5];
    [self.circleView_t setBorderColor:kTextColor102];
    [self.circleView_t setBorderWidth:0.5];
    [self.circleView_b lz_setCornerRadius:2.5];
    [self.circleView_b setBorderColor:kTextColor102];
    [self.circleView_b setBorderWidth:0.5];
    
    [self.boxView lz_setCornerRadius:10.0f];
    
    [self addSubview:self.boxView];
    
    [self.boxView addSubview:self.dep_timeLabel];
    [self.boxView addSubview:self.arv_timeLabel];
    [self.boxView addSubview:self.dep_airportLabel];
    [self.boxView addSubview:self.arv_airportLabel];
    [self.boxView addSubview:self.circleView_t];
    [self.boxView addSubview:self.circleView_b];
    [self.boxView addSubview:self.linerView];
    
    
    [self.boxView addSubview:self.flightNoLabel];
    [self.boxView addSubview:self.planeTypeLabel];
    [self.boxView addSubview:self.distanceLabel];
    [self.boxView addSubview:self.mealLabel];
    [self.boxView addSubview:self.linerView1];
    [self.boxView addSubview:self.linerView2];
    [self.boxView addSubview:self.linerView3];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.bottom.centerX.equalTo(self);
        make.width.equalTo(@(kScreenWidth-20));
    }];
    
    [self.dep_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.boxView).offset(15);
    }];
    [self.arv_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_timeLabel);
        make.top.equalTo(self.dep_timeLabel.mas_bottom).offset(30);
    }];
    
    [self.circleView_t mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_timeLabel.mas_right).offset(30);
        make.centerY.equalTo(self.dep_timeLabel);
        make.width.height.equalTo(@(5));
    }];
    
    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.circleView_t);
        make.width.equalTo(@(0.5));
        make.top.equalTo(self.circleView_t.mas_bottom);
        make.bottom.equalTo(self.circleView_b.mas_top);
    }];
    
    [self.circleView_b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(self.circleView_t);
        make.centerY.equalTo(self.arv_timeLabel);
    }];
    
    [self.dep_airportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.circleView_t);
        make.left.equalTo(self.circleView_t.mas_right).offset(30);
    }];
    
    [self.arv_airportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_airportLabel);
        make.centerY.equalTo(self.circleView_b);
    }];
    
    
    CGFloat left = 7;
    [self.flightNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_timeLabel);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    [self.linerView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flightNoLabel.mas_right).offset(left);
        make.centerY.equalTo(self.flightNoLabel);
        make.height.equalTo(@(10));
        make.width.equalTo(@(1));
    }];
    [self.planeTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.linerView1.mas_right).offset(left);
        make.centerY.equalTo(self.linerView1);
    }];
    [self.linerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.planeTypeLabel.mas_right).offset(left);
        make.centerY.height.width.equalTo(self.linerView1);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.linerView2);
        make.left.equalTo(self.linerView2.mas_right).offset(left);
    }];
    [self.linerView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.distanceLabel.mas_right).offset(left);
        make.centerY.height.width.equalTo(self.linerView1);
    }];
    [self.mealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.linerView3.mas_right).offset(left);
        make.centerY.equalTo(self.linerView3);
    }];
}

- (UILabel *)dep_timeLabel{
    if (!_dep_timeLabel) {
        _dep_timeLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium18];
    }
    return _dep_timeLabel;
}

- (UILabel *)arv_timeLabel{
    if (!_arv_timeLabel) {
        _arv_timeLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium18];
    }
    return _arv_timeLabel;
}

- (UILabel *)dep_airportLabel{
    if (!_dep_airportLabel) {
        _dep_airportLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium16];
    }
    return _dep_airportLabel;
}

- (UILabel *)arv_airportLabel{
    if (!_arv_airportLabel) {
        _arv_airportLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium16];
    }
    return _arv_airportLabel;
}

- (UIView *)circleView_t{
    if (!_circleView_t) {
        _circleView_t = [UIView lz_viewWithColor:kClearColor];
    }
    return _circleView_t;
}

- (UIView *)circleView_b{
    if (!_circleView_b) {
        _circleView_b = [UIView lz_viewWithColor:kClearColor];
    }
    return _circleView_b;
}

- (UIView *)linerView{
    if (!_linerView) {
        _linerView = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _boxView;
}

- (UILabel *)flightNoLabel{
    if (!_flightNoLabel) {
        _flightNoLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeRegular13];
    }
    return _flightNoLabel;
}

- (UILabel *)planeTypeLabel{
    if (!_planeTypeLabel) {
        _planeTypeLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeRegular13];
    }
    return _planeTypeLabel;
}

- (UILabel *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeRegular13];
    }
    return _distanceLabel;
}

- (UILabel *)mealLabel{
    if (!_mealLabel) {
        _mealLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeRegular13];
    }
    return _mealLabel;
}

- (UIView *)linerView1{
    if (!_linerView1) {
        _linerView1 = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView1;
}

- (UIView *)linerView2{
    if (!_linerView2) {
        _linerView2 = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView2;
}

- (UIView *)linerView3{
    if (!_linerView3) {
        _linerView3 = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView3;
}
@end
