//
//  TXTicketInfoTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/17.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTicketInfoTableViewCell.h"

@implementation TXTicketInfoTableViewCell

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
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)setTicketModel:(TicketModel *)ticketModel{
    _ticketModel = ticketModel;

    NSString *formatDate1 = @"MM-dd";               /// 月日
    NSString *formatDate = @"HH:mm";                /// 时分
    /// 出发日期
//    NSString * dep_date= [Utils lz_timeWithTimeIntervalString:ticketModel.arv_time formatter:formatDate1];
//    /// 出发时间
//    NSString * dep_time= [Utils lz_timeWithTimeIntervalString:ticketModel.dep_time formatter:formatDate];
//    /// 出发机场
//    NSString *dep_airpor = kStringFormat(ticketModel.dep_airport, ticketModel.dep_airport_term);//@"双流机场T2";
//    /// 到站机场
//    NSString *arv_airport = kStringFormat(ticketModel.arv_airport, ticketModel.arv_airport_term);// @"旧金山机场";
//    /// 星期几
//    NSString *whatDay = [SCSmallTools tt_dateWeekWithDateString:self.ticketModel.dep_time];
//    self.time_label.text = dep_time;
//    self.date_label.text = dep_date;
//    self.dep_arv_label.text = [NSString stringWithFormat:@"%@-%@",dep_airpor,arv_airport];
//    self.weekend_label.text = whatDay;
//    self.type_label.text = @"经济舱";
}

- (void) initView{
    [self addSubview:self.date_label];
    [self addSubview:self.weekend_label];
    [self addSubview:self.time_label];
    [self addSubview:self.type_label];
    [self addSubview:self.dep_arv_label];
    
    [self.date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.top.equalTo(@(IPHONE6_W(12)));
    }];
    [self.weekend_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.date_label.mas_right).offset(15);
        make.centerY.equalTo(self.date_label);
    }];
    [self.time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekend_label.mas_right).offset(15);
        make.centerY.equalTo(self.date_label);
    }];
    [self.type_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.time_label.mas_right).offset(15);
        make.centerY.equalTo(self.date_label);
    }];
    [self.dep_arv_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.date_label);
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-12));
    }];
}

- (UILabel *)date_label{
    if (!_date_label) {
        _date_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _date_label;
}

- (UILabel *)weekend_label{
    if (!_weekend_label) {
        _weekend_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _weekend_label;
}

- (UILabel *)time_label{
    if (!_time_label) {
        _time_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _time_label;
}

- (UILabel *)type_label{
    if (!_type_label) {
        _type_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _type_label;
}

- (UILabel *)dep_arv_label{
    if (!_dep_arv_label) {
        _dep_arv_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _dep_arv_label;
}


@end
