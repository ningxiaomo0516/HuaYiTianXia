//
//  YKTicketQueryBoxView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/8.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKTicketQueryBoxView.h"

@implementation YKTicketQueryBoxView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kWhiteColor;
        [self lz_setCornerRadius:5.0];
        [self initView];
    }
    return self;
}

- (void) initView{
    self.childlabel.text = @"2-12岁";
    self.babylabel.text = @"14天-2岁";
    self.imagesView.image = kGetImage(@"zx_live_plane");
    /// 图标
    [self addSubview:self.imagesView];
    /// 出发城市
    [self addSubview:self.dep_citylabel];
    /// 抵达城市
    [self addSubview:self.arv_citylabel];
    /// 出发日期
    [self addSubview:self.dep_datelabel];
    /// 出发日期
    [self addSubview:self.dep_titlelabel];
    /// 当前日期星期几
    [self addSubview:self.dep_weeklabel];
    /// 仓位选择
    [self addSubview:self.dep_seatlabel];
    
    /// 分割线
    [self addSubview:self.linerView_t];
    [self addSubview:self.linerView_b];
    
    [self addSubview:self.childButton];
    [self addSubview:self.babyButtton];
    [self addSubview:self.childlabel];
    [self addSubview:self.babylabel];
    
    /// 搜索按钮
    [self addSubview:self.searchButton];
    [self addSubview:self.payButton];
    [self addSubview:self.serviceBtn];
    
    [self addSubview:self.dep_seat_btn];
    [self addSubview:self.dep_city_btn];
    [self addSubview:self.arv_city_btn];
    [self addSubview:self.date_select_btn];
     
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(23));
    }];
    
    [self.dep_citylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imagesView);
        make.left.equalTo(@(45));
    }];
    [self.arv_citylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imagesView);
        make.right.equalTo(self.mas_right).offset(-45);
    }];
    
    [self.linerView_t mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.height.equalTo(@(0.5));
        make.top.equalTo(self.imagesView.mas_bottom).offset(20);
        make.right.equalTo(self.mas_right).offset(-15);
    }];

    [self.linerView_b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.linerView_t);
        make.top.equalTo(self.linerView_t.mas_bottom).offset(60);
    }];
    
    [self.dep_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(self.linerView_t.mas_bottom);
        make.bottom.equalTo(self.linerView_b.mas_top);
    }];
    
    [self.dep_datelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_titlelabel.mas_right).offset(25);
        make.centerY.equalTo(self.dep_titlelabel);
    }];
    [self.dep_weeklabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_datelabel.mas_right).offset(25);
        make.centerY.equalTo(self.dep_datelabel);
    }];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@(40));
        make.bottom.equalTo(self.payButton.mas_top).offset(-15);
    }];
    
    [self.dep_seatlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(self.linerView_b.mas_bottom).offset(20);
    }];
    
    [self.babyButtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.dep_seatlabel);
    }];
    [self.childButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.babyButtton.mas_left).offset(-10);
        make.centerY.equalTo(self.babyButtton);
    }];
    
    [self.childlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.childButton.mas_bottom);
        make.centerX.equalTo(self.childButton);
    }];
    [self.babylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.childlabel);
        make.centerX.equalTo(self.babyButtton);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.bottom.equalTo(self.mas_bottom).offset(-15);
    }];
    [self.serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payButton.mas_right).offset(15);
        make.centerY.equalTo(self.payButton);
    }];
    
    [self.dep_seat_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_seatlabel);
        make.centerY.equalTo(self.dep_seatlabel).offset(10);
        make.height.equalTo(@(60));
        make.width.equalTo(@(120));
    }];
    
    [self.dep_city_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.arv_citylabel);
        make.width.equalTo(self.arv_city_btn);
        make.height.equalTo(@(40));
        make.left.equalTo(self);
    }];
    [self.arv_city_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.width.equalTo(self.dep_city_btn);
        make.left.equalTo(self.dep_city_btn.mas_right).offset(50);
        make.height.equalTo(@(40));
        make.right.equalTo(self);
    }];
    
    [self.date_select_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(100));
        make.right.equalTo(self);
        make.top.equalTo(self.linerView_t.mas_bottom);
        make.bottom.equalTo(self.linerView_b.mas_top);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UILabel *)dep_citylabel{
    if (!_dep_citylabel) {
        _dep_citylabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium20];
    }
    return _dep_citylabel;
}

- (UILabel *)arv_citylabel{
    if (!_arv_citylabel) {
        _arv_citylabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium20];
    }
    return _arv_citylabel;
}

- (UIView *)linerView_t{
    if (!_linerView_t) {
        _linerView_t = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView_t;
}

- (UIView *)linerView_b{
    if (!_linerView_b) {
        _linerView_b = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView_b;
}

- (UILabel *)dep_datelabel{
    if (!_dep_datelabel) {
        _dep_datelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium20];
    }
    return _dep_datelabel;
}

- (UILabel *)dep_weeklabel{
    if (!_dep_weeklabel) {
        _dep_weeklabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular14];
    }
    return _dep_weeklabel;
}

- (UILabel *)dep_titlelabel{
    if (!_dep_titlelabel) {
        _dep_titlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular14];
    }
    return _dep_titlelabel;
}

- (UILabel *)dep_seatlabel{
    if (!_dep_seatlabel) {
        _dep_seatlabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeRegular15];
    }
    return _dep_seatlabel;
}

- (UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_searchButton isRadius:YES];
    }
    return _searchButton;
}

- (UIButton *)childButton{
    if (!_childButton) {
        _childButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_childButton setTitle:@"携带儿童" forState:UIControlStateNormal];
        [_childButton setImage:kGetImage(@"zx_btn_normal") forState:UIControlStateNormal];
        [_childButton setImage:kGetImage(@"zx_btn_selected") forState:UIControlStateSelected];
        [Utils lz_setButtonTitleWithImageEdgeInsets:_childButton postition:kMVImagePositionLeft spacing:3.0];
        [_childButton setTitleColor:kTextColor51 forState:UIControlStateNormal];
        _childButton.titleLabel.font = kFontSizeRegular13;
    }
    return _childButton;
}

- (UIButton *)babyButtton{
    if (!_babyButtton) {
        _babyButtton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_babyButtton setTitle:@"携带婴儿" forState:UIControlStateNormal];
        [_babyButtton setImage:kGetImage(@"zx_btn_normal") forState:UIControlStateNormal];
        [_babyButtton setImage:kGetImage(@"zx_btn_selected") forState:UIControlStateSelected];
        [Utils lz_setButtonTitleWithImageEdgeInsets:_babyButtton postition:kMVImagePositionLeft spacing:3.0];
        [_babyButtton setTitleColor:kTextColor51 forState:UIControlStateNormal];
        _babyButtton.titleLabel.font = kFontSizeRegular13;
    }
    return _babyButtton;
}

- (UILabel *)childlabel{
    if (!_childlabel) {
        _childlabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular11];
    }
    return _childlabel;
}

- (UILabel *)babylabel{
    if (!_babylabel) {
        _babylabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular11];
    }
    return _babylabel;
}

- (UIButton *)payButton{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"支付安全" forState:UIControlStateNormal];
        [_payButton setImage:kGetImage(@"zx_btn_pay") forState:UIControlStateNormal];
        [Utils lz_setButtonTitleWithImageEdgeInsets:_payButton postition:kMVImagePositionLeft spacing:5.0];
        [_payButton setTitleColor:kTextColor153 forState:UIControlStateNormal];
        _payButton.titleLabel.font = kFontSizeRegular11;
    }
    return _payButton;
}
- (UIButton *)serviceBtn{
    if (!_serviceBtn) {
        _serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_serviceBtn setTitle:@"服务保障" forState:UIControlStateNormal];
        [_serviceBtn setImage:kGetImage(@"zx_btn_service") forState:UIControlStateNormal];
        [Utils lz_setButtonTitleWithImageEdgeInsets:_serviceBtn postition:kMVImagePositionLeft spacing:5.0];
        [_serviceBtn setTitleColor:kTextColor153 forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = kFontSizeRegular11;
    }
    return _serviceBtn;
}

- (UIButton *)dep_seat_btn{
    if (!_dep_seat_btn) {
        _dep_seat_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dep_seat_btn setBackgroundColor:kClearColor];
    }
    return _dep_seat_btn;
}

- (UIButton *)dep_city_btn{
    if (!_dep_city_btn) {
        _dep_city_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dep_city_btn.tag = 100;
        [_dep_city_btn setBackgroundColor:kClearColor];
    }
    return _dep_city_btn;
}

- (UIButton *)arv_city_btn{
    if (!_arv_city_btn) {
        _arv_city_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _arv_city_btn.tag = 200;
        [_arv_city_btn setBackgroundColor:kClearColor];
    }
    return _arv_city_btn;
}

- (UIButton *)date_select_btn{
    if (!_date_select_btn) {
        _date_select_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _date_select_btn.tag = 300;
        [_date_select_btn setBackgroundColor:kClearColor];
    }
    return _date_select_btn;
}
@end
