//
//  TXTicketBookingTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/17.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTicketBookingTableViewCell.h"

@implementation TXTicketBookingTableViewCell

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
        self.taxPriceLabel.text = @"含税总价";
        self.priceLabel.text = @"公务舱：￥1632";
    }
    return self;
}

- (void)selectAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(selectRowStr:indexPath:)]) {
//        [_delegate selectRowStr:self.ticketModel.airline indexPath:self.selectedIndexPath];
    }
}

- (void)setTicketModel:(TicketModel *)ticketModel{
    _ticketModel = ticketModel;
    
//    NSString *formatDate0 = @"yyyy-MM-dd HH:mm:ss"; /// 年月日
//    NSString *formatDate = @"HH:mm";                /// 时分
//    NSString *formatDate1 = @"MM-dd";               /// 月日
//    /// 出发时间
//    NSString * dep_time= [Utils lz_timeWithTimeIntervalString:ticketModel.dep_time formatter:formatDate];
//    NSString * dep_times= [Utils lz_timeWithTimeIntervalString:ticketModel.dep_time formatter:formatDate0];
//    /// 到达时间
//    NSString * arv_time= [Utils lz_timeWithTimeIntervalString:ticketModel.arv_time formatter:formatDate];
//    NSString * arv_times= [Utils lz_timeWithTimeIntervalString:ticketModel.arv_time formatter:formatDate0];
//    
//    /// 出发日期
//    NSString * dep_date= [Utils lz_timeWithTimeIntervalString:ticketModel.arv_time formatter:formatDate1];
//    
//    self.dep_timeLabel.text =  dep_time;//@"09:00";
//    self.dep_airportLabel.text = kStringFormat(ticketModel.dep_airport, ticketModel.dep_airport_term);//@"双流机场T2";
//    self.arv_timeLabel.text = arv_time;//@"11:10";
//    self.arv_airportLabel.text = kStringFormat(ticketModel.arv_airport, ticketModel.arv_airport_term);// @"旧金山机场";
//    self.airlineLabel.text = ticketModel.airline;//@"中国东方航空";
//    self.modelLabel.text = ticketModel.model;//@"空中客车 A320";
//
//    self.timerLabel.text = [self pleaseInsertStarTimeo:dep_times andInsertEndTime:arv_times] ;;//@"约2时23分";
//    self.dateLabel.text = dep_date;
}



- (NSString *)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2{
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
    TTLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", (long)cmps.year, (long)cmps.month, (long)cmps.day, (long)cmps.hour, (long)cmps.minute, (long)cmps.second);
    return [NSString stringWithFormat:@"约%ld时%ld分",(long)cmps.hour,(long)cmps.minute];
}

- (void) initView{
    [self addSubview:self.dep_timeLabel];
    [self addSubview:self.arv_timeLabel];
    [self addSubview:self.imagesTo];
    [self addSubview:self.dep_airportLabel];
    [self addSubview:self.arv_airportLabel];
    
    [self addSubview:self.modelLabel];
    
    [self addSubview:self.airlineLabel];
    [self addSubview:self.imagesTime];
    [self addSubview:self.timerLabel];
    
    [self addSubview:self.dateLabel];
    [self addSubview:self.priceLabel];
    
    [self addSubview:self.taxPriceLabel];
    
    [self addSubview:self.imagesSelected];
    [self addSubview:self.buttonSelected];
    
    [self.dep_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.top.equalTo(@(IPHONE6_W(10)));
    }];
    [self.dep_airportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_timeLabel);
        make.top.equalTo(self.dep_timeLabel.mas_bottom).offset(IPHONE6_W(2));
    }];
    [self.arv_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(112)));
        make.centerY.equalTo(self.dep_timeLabel);
    }];
    [self.arv_airportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arv_timeLabel);
        make.centerY.equalTo(self.dep_airportLabel);
    }];
    [self.imagesTo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(IPHONE6_W(20)));
        make.left.equalTo(self.dep_timeLabel.mas_right).offset(IPHONE6_W(15));
    }];
    
    [self.modelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_timeLabel);
        make.bottom.equalTo(self.airlineLabel.mas_top).offset(-IPHONE6_W(2));
    }];
    
    [self.airlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_timeLabel);
        make.bottom.equalTo(self.mas_bottom).offset(-(IPHONE6_W(12)));
    }];
    
    [self.imagesTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.airlineLabel);
        make.left.equalTo(self.airlineLabel.mas_right).offset(IPHONE6_W(3));
    }];
    
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imagesTime);
        make.left.equalTo(self.imagesTime.mas_right).offset(IPHONE6_W(3));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.top.equalTo(@(IPHONE6_W(25)));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(IPHONE6_W(30));
        make.centerY.equalTo(self);
    }];
    
    [self.taxPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W((-15)));
        make.bottom.equalTo(self.mas_bottom).offset(-IPHONE6_W(25));
    }];
    
    [self.imagesSelected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
    }];
    
    [self.buttonSelected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
    }];
}


- (UILabel *)dep_timeLabel{
    if (!_dep_timeLabel) {
        _dep_timeLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _dep_timeLabel;
}

- (UILabel *)arv_timeLabel{
    if (!_arv_timeLabel) {
        _arv_timeLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _arv_timeLabel;
}

- (UILabel *)dep_airportLabel{
    if (!_dep_airportLabel) {
        _dep_airportLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium11];
    }
    return _dep_airportLabel;
}

- (UILabel *)arv_airportLabel{
    if (!_arv_airportLabel) {
        _arv_airportLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium11];
    }
    return _arv_airportLabel;
}

- (UILabel *)modelLabel{
    if (!_modelLabel) {
        _modelLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"#FC6244") font:kFontSizeMedium11];
    }
    return _modelLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _priceLabel;
}

- (UILabel *)airlineLabel{
    if (!_airlineLabel) {
        _airlineLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium11];
    }
    return _airlineLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium11];
    }
    return _dateLabel;
}

- (UILabel *)timerLabel{
    if (!_timerLabel) {
        _timerLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium11];
    }
    return _timerLabel;
}

- (UILabel *)taxPriceLabel{
    if (!_taxPriceLabel) {
        _taxPriceLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium11];
    }
    return _taxPriceLabel;
}

- (UIImageView *)imagesTo{
    if (!_imagesTo) {
        _imagesTo = [[UIImageView alloc] init];
        _imagesTo.image = kGetImage(@"转");
    }
    return _imagesTo;
}

- (UIImageView *)imagesTime{
    if (!_imagesTime) {
        _imagesTime = [[UIImageView alloc] init];
        _imagesTime.image = kGetImage(@"mine_btn_timer");
    }
    return _imagesTime;
}

- (UIImageView *)imagesSelected{
    if (!_imagesSelected) {
        _imagesSelected = [[UIImageView alloc] init];
    }
    return _imagesSelected;
}

- (UIButton *)buttonSelected{
    if (!_buttonSelected) {
        _buttonSelected = [UIButton buttonWithType:UIButtonTypeCustom];
        MV(weakSelf)
        [_buttonSelected lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf selectAction:weakSelf.buttonSelected];
        }];
    }
    return _buttonSelected;
}

@end
