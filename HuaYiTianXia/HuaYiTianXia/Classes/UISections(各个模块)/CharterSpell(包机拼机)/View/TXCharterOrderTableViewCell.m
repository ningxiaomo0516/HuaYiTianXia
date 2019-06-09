//
//  TXCharterOrderTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/1.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterOrderTableViewCell.h"

@implementation TXCharterOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        
        self.dep_terminal_label_t.text = @"航站楼";
        self.arv_terminal_label_t.text = @"航站楼";
        
        self.imagesView.image = kGetImage(@"lv01_btn_飞机");
        
        self.dep_time_label_t.text = @"出发";
        self.dep_datetime_label.text = @"实际  --";
        
        self.arv_time_label_t.text = @"到达";
        self.arv_datetime_label.text = @"实际  --";
    }
    return self;
}

- (void)setOrderModel:(CharterOrderModel *)orderModel{
    _orderModel = orderModel;
    
    self.dep_city_label.text    = self.orderModel.depCity;
    self.dep_airport_label.text = self.orderModel.depAirport;
    self.arv_city_label.text    = self.orderModel.arvCity;
    self.arv_airport_label.text = self.orderModel.arvAirport;
    self.seatLabel.text         = [NSString stringWithFormat:@"%@座",self.orderModel.totalSeats];
    
    self.duration_label.text    = self.orderModel.duration;
    self.models_label.text      = [NSString stringWithFormat:@"机型   %@",self.orderModel.aircraft];
    
    self.dep_terminal_label.text = self.orderModel.depTerminal;
    self.arv_terminal_label.text = self.orderModel.arvTerminal;
    
    self.dep_time_label.text = self.orderModel.depHour;
    self.dep_date_label.text = [NSString stringWithFormat:@"计划 %@",self.orderModel.depDate];
    
    self.arv_time_label.text = self.orderModel.arvHour;
    self.arv_date_label.text = [NSString stringWithFormat:@"计划 %@",self.orderModel.arvDate];
}

- (void) initView{
    /// 出发城市
    [self.contentView addSubview:self.dep_city_label];
    /// 出发机场
    [self.contentView addSubview:self.dep_airport_label];
    /// 到达城市
    [self.contentView addSubview:self.arv_city_label];
    /// 到达机场
    [self.contentView addSubview:self.arv_airport_label];
    /// 时长
    [self.contentView addSubview:self.duration_label];
    /// 图片
    [self.contentView addSubview:self.imagesView];
    /// 机型
    [self.contentView addSubview:self.models_label];
    /// 座位
    [self.contentView addSubview:self.seatLabel];
    /// 出发时间
    [self.contentView addSubview:self.dep_time_label];
    /// 出发日期(title)
    [self.contentView addSubview:self.dep_time_label_t];
    /// 到达时间
    [self.contentView addSubview:self.arv_time_label];
    /// 到达时间(title)
    [self.contentView addSubview:self.arv_time_label_t];
    /// 出发日期
    [self.contentView addSubview:self.dep_date_label];
    /// 到达日期
    [self.contentView addSubview:self.arv_date_label];
    /// 出发实际日期
    [self.contentView addSubview:self.dep_datetime_label];
    /// 到达实际日期
    [self.contentView addSubview:self.arv_datetime_label];
    /// 出发航站楼
    [self.contentView addSubview:self.dep_terminal_label];
    /// 到达航站楼
    [self.contentView addSubview:self.arv_terminal_label];
    /// 出发航站楼(标题)
    [self.contentView addSubview:self.dep_terminal_label_t];
    /// 到达航站楼(标题)
    [self.contentView addSubview:self.arv_terminal_label_t];
    /// 分割线1
    [self.contentView addSubview:self.liner_1_view];
    /// 分割线2
    [self.contentView addSubview:self.liner_2_view];
    /// 分割线3
    [self.contentView addSubview:self.liner_3_view];
    CGFloat left = 15;
    CGFloat top = 8;
    [self.liner_1_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.height.equalTo(@(0.7));
        make.right.equalTo(self.mas_right).offset(-left);
        make.top.equalTo(@(60));
    }];
    [self.liner_2_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.left.equalTo(self.liner_1_view);
        make.top.equalTo(self.liner_1_view.mas_bottom).offset(40);
    }];
    [self.liner_3_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.left.equalTo(self.liner_1_view);
        make.top.equalTo(self.liner_2_view.mas_bottom).offset(80);
    }];
    
    [self.models_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.top.equalTo(self.liner_1_view.mas_bottom);
        make.bottom.equalTo(self.liner_2_view.mas_top);
    }];
    [self.seatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-left);
        make.centerY.equalTo(self.models_label);
    }];
    
    /// 基本信息
    [self.dep_city_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.top.equalTo(@(top));
    }];
    [self.dep_airport_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_city_label);
        make.bottom.equalTo(self.liner_1_view.mas_top).offset(-top);
    }];
    [self.arv_city_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-left);
        make.centerY.equalTo(self.dep_city_label);
    }];
    [self.arv_airport_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arv_city_label);
        make.centerY.equalTo(self.dep_airport_label);
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.dep_city_label);
    }];
    [self.duration_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.dep_airport_label);
    }];
    
    /// 航站信息
    [self.dep_terminal_label_t mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.top.equalTo(self.liner_3_view.mas_bottom).offset(top);
    }];
    [self.dep_terminal_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.bottom.equalTo(self.mas_bottom).offset(-top);
    }];
    [self.arv_terminal_label_t mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dep_terminal_label_t);
        make.right.equalTo(self.mas_right).offset(-left);
    }];
    [self.arv_terminal_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arv_terminal_label_t);
        make.centerY.equalTo(self.dep_terminal_label);
    }];
    
    /// 出发信息
    [self.dep_time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.top.equalTo(self.liner_2_view.mas_bottom).offset(3);
    }];
    [self.dep_time_label_t mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_time_label.mas_right).offset(5);
        make.bottom.equalTo(self.dep_time_label.mas_bottom).offset(-3);
    }];
    [self.arv_time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-left);
        make.centerY.equalTo(self.dep_time_label);
    }];
    [self.arv_time_label_t mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arv_time_label.mas_left).offset(-5);
        make.bottom.equalTo(self.arv_time_label.mas_bottom).offset(-3);
    }];
    [self.dep_date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_time_label);
        make.top.equalTo(self.dep_time_label.mas_bottom).offset(3);
    }];
    [self.arv_date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-left);
        make.centerY.equalTo(self.dep_date_label);
    }];
    [self.dep_datetime_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_date_label);
        make.top.equalTo(self.dep_date_label.mas_bottom).offset(3);
    }];
    [self.arv_datetime_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-left);
        make.centerY.equalTo(self.dep_datetime_label);
    }];
}

- (UILabel *)dep_city_label{
    if (!_dep_city_label) {
        _dep_city_label = [self createLabelWithColor:kTextColor51 font:kFontSizeMedium17];
    }
    return _dep_city_label;
}
- (UILabel *)dep_airport_label{
    if (!_dep_airport_label) {
        _dep_airport_label = [self createLabelWithColor:kTextColor51 font:kFontSizeMedium12];
    }
    return _dep_airport_label;
}

- (UILabel *)arv_city_label{
    if (!_arv_city_label) {
        _arv_city_label = [self createLabelWithColor:kTextColor51 font:kFontSizeMedium17];
    }
    return _arv_city_label;
}
- (UILabel *)arv_airport_label{
    if (!_arv_airport_label) {
        _arv_airport_label = [self createLabelWithColor:kTextColor51 font:kFontSizeMedium12];
    }
    return _arv_airport_label;
}
- (UILabel *)models_label{
    if (!_models_label) {
        _models_label = [self createLabelWithColor:kTextColor51 font:kFontSizeMedium12];
    }
    return _models_label;
}
- (UILabel *)duration_label{
    if (!_duration_label) {
        _duration_label = [self createLabelWithColor:kTextColor102 font:kFontSizeMedium12];
    }
    return _duration_label;
}
- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}
- (UILabel *)seatLabel{
    if (!_seatLabel) {
        _seatLabel = [self createLabelWithColor:kTextColor51 font:kFontSizeMedium12];;
    }
    return _seatLabel;
}
- (UILabel *)dep_time_label{
    if (!_dep_time_label) {
        _dep_time_label = [self createLabelWithColor:kTextColor51 font:kFontSizeMedium20];
    }
    return _dep_time_label;
}
- (UILabel *)dep_time_label_t{
    if (!_dep_time_label_t) {
        _dep_time_label_t = [self createLabelWithColor:kTextColor153 font:kFontSizeMedium12];
    }
    return _dep_time_label_t;
}
- (UILabel *)arv_time_label{
    if (!_arv_time_label) {
        _arv_time_label = [self createLabelWithColor:kTextColor51 font:kFontSizeMedium20];
    }
    return _arv_time_label;
}
- (UILabel *)arv_time_label_t{
    if (!_arv_time_label_t) {
        _arv_time_label_t = [self createLabelWithColor:kTextColor153 font:kFontSizeMedium12];
    }
    return _arv_time_label_t;
}
- (UILabel *)dep_date_label{
    if (!_dep_date_label) {
        _dep_date_label = [self createLabelWithColor:kTextColor102 font:kFontSizeMedium12];
    }
    return _dep_date_label;
}
- (UILabel *)arv_date_label{
    if (!_arv_date_label) {
        _arv_date_label = [self createLabelWithColor:kTextColor102 font:kFontSizeMedium12];
    }
    return _arv_date_label;
}
- (UILabel *)dep_datetime_label{
    if (!_dep_datetime_label) {
        _dep_datetime_label = [self createLabelWithColor:kTextColor102 font:kFontSizeMedium12];
    }
    return _dep_datetime_label;
}
- (UILabel *)arv_datetime_label{
    if (!_arv_datetime_label) {
        _arv_datetime_label = [self createLabelWithColor:kTextColor102 font:kFontSizeMedium12];
    }
    return _arv_datetime_label;
}

- (UILabel *)dep_terminal_label{
    if (!_dep_terminal_label) {
        _dep_terminal_label = [self createLabelWithColor:kTextColor51 font:kFontSizeRegular15];
    }
    return _dep_terminal_label;
}
- (UILabel *)arv_terminal_label{
    if (!_arv_terminal_label) {
        _arv_terminal_label = [self createLabelWithColor:kTextColor51 font:kFontSizeRegular15];
    }
    return _arv_terminal_label;
}
- (UILabel *)dep_terminal_label_t{
    if (!_dep_terminal_label_t) {
        _dep_terminal_label_t = [self createLabelWithColor:kTextColor51 font:kFontSizeRegular12];
    }
    return _dep_terminal_label_t;
}
- (UILabel *)arv_terminal_label_t{
    if (!_arv_terminal_label_t) {
        _arv_terminal_label_t = [self createLabelWithColor:kTextColor51 font:kFontSizeRegular12];
    }
    return _arv_terminal_label_t;
}
- (UIView *)liner_1_view{
    if (!_liner_1_view) {
        _liner_1_view = [UIView lz_viewWithColor:kTextColor170];
    }
    return _liner_1_view;
}
- (UIView *)liner_2_view{
    if (!_liner_2_view) {
        _liner_2_view = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _liner_2_view;
}
- (UIView *)liner_3_view{
    if (!_liner_3_view) {
        _liner_3_view = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _liner_3_view;
}

- (UILabel *)createLabelWithColor:(UIColor *)color font:(UIFont *)font{
    UILabel *label = [UILabel lz_labelWithTitle:@"" color:color font:font];
    return label;
}
@end
