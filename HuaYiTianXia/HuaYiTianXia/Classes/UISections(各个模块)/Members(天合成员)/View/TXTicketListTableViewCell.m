//
//  TXTicketListTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTicketListTableViewCell.h"

@implementation TXTicketListTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)setTicketModel:(TicketModel *)ticketModel{
    _ticketModel = ticketModel;
    NSArray *depTime = [ticketModel.depTime componentsSeparatedByString:@" "];
    NSArray *arrTime = [ticketModel.arrTime componentsSeparatedByString:@" "];
    self.dep_timeLabel.text = depTime.count>1?depTime[1]:@"00:00";
    self.arv_timeLabel.text = arrTime.count>1?arrTime[1]:@"00:00";
    NSMutableArray *priceArray = [[NSMutableArray alloc] init];
    for (SeatItems *seatItem in ticketModel.seatItems) {
        for (PricesModel *priceModel in seatItem.policys.priceDatas) {
            [priceArray addObject:priceModel.price];
        }
    }
    
//    CGFloat maxPrice = [[priceArray valueForKeyPath:@"@max.floatValue"] floatValue];
    NSNumber *minPrice = [priceArray valueForKeyPath:@"@min.floatValue"];

    NSString *text = @"￥";
    NSString *amountText =  [NSString stringWithFormat:@"%@%@",text,minPrice];
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:amountText];
    /// 前面文字大小
    [mutableAttr addAttribute:NSFontAttributeName value:kFontSizeMedium12 range:NSMakeRange(0, text.length)];
    self.priceLabel.attributedText = mutableAttr;
    
    self.dep_airportLabel.text = [NSString stringWithFormat:@"%@%@",ticketModel.depName,ticketModel.depJetquay];
    self.arv_airportLabel.text = [NSString stringWithFormat:@"%@%@",ticketModel.arrName,ticketModel.arrJetquay];
    self.flightNoLabel.text = [NSString stringWithFormat:@"%@ |",ticketModel.flightNo];
    self.planeTypeLabel.text = [NSString stringWithFormat:@"%@ |",ticketModel.planeType];
    self.timelabel.text = [self pleaseInsertStarTimeo:ticketModel.depTime andInsertEndTime:ticketModel.arrTime];
}



- (NSString *)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2{
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
    TTLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    return [NSString stringWithFormat:@"约%ld时%ld分",cmps.hour,cmps.minute];
}

- (void) initView{
    [self addSubview:self.boxView];
    [self.boxView lz_setCornerRadius:10.0];
    [self.boxView addSubview:self.dep_timeLabel];
    [self.boxView addSubview:self.arv_timeLabel];
    [self.boxView addSubview:self.imagesView];
    [self.boxView addSubview:self.dep_airportLabel];
    [self.boxView addSubview:self.arv_airportLabel];
    
    [self.boxView addSubview:self.priceLabel];
    [self.boxView addSubview:self.planeTypeLabel];
    [self.boxView addSubview:self.flightNoLabel];
    [self.boxView addSubview:self.timelabel];
    [self.boxView addSubview:self.imagesTime];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [self.dep_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boxView.mas_left).offset(15);
        make.top.equalTo(@(10));
    }];
    [self.dep_airportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_timeLabel);
        make.centerY.equalTo(self.boxView);
    }];
    [self.arv_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.boxView);
        make.centerY.equalTo(self.dep_timeLabel);
    }];
    [self.arv_airportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arv_timeLabel);
        make.centerY.equalTo(self.dep_airportLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.boxView.mas_right).offset(-15);
        make.centerY.equalTo(self.dep_timeLabel);
    }];
    
    [self.flightNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_timeLabel);
        make.bottom.equalTo(self.boxView.mas_bottom).offset(-10);
    }];
    
    [self.planeTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flightNoLabel.mas_right).offset(5);
        make.centerY.equalTo(self.flightNoLabel);
    }];
    
    [self.imagesTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.flightNoLabel);
        make.left.equalTo(self.planeTypeLabel.mas_right).offset(5);
    }];
    
    [self.timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesTime.mas_right).offset(5);
        make.centerY.equalTo(self.imagesTime);
    }];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dep_timeLabel);
        CGFloat width = (kScreenWidth-20)/5;
        make.centerX.equalTo(self.boxView).offset(-width);
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
        _dep_airportLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular14];
    }
    return _dep_airportLabel;
}

- (UILabel *)arv_airportLabel{
    if (!_arv_airportLabel) {
        _arv_airportLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular14];
    }
    return _arv_airportLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:kColorWithRGB(244, 78, 68) font:kFontSizeMedium18];
    }
    return _priceLabel;
}

- (UILabel *)flightNoLabel{
    if (!_flightNoLabel) {
        _flightNoLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular13];
    }
    return _flightNoLabel;
}

- (UILabel *)planeTypeLabel{
    if (!_planeTypeLabel) {
        _planeTypeLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular13];
    }
    return _planeTypeLabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.image = kGetImage(@"k98_转");
    }
    return _imagesView;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _boxView;
}

- (UILabel *)timelabel{
    if (!_timelabel) {
        _timelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular13];
    }
    return _timelabel;
}

- (UIImageView *)imagesTime{
    if (!_imagesTime) {
        _imagesTime = [[UIImageView alloc] init];
        _imagesTime.image = kGetImage(@"mine_btn_timer");
    }
    return _imagesTime;
}
@end
