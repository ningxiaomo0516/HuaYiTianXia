//
//  TXLogisticTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/14.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXLogisticTableViewCell.h"

@implementation TXLogisticTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.linerView.backgroundColor = kTextColor153;
    // Configure the view for the selected state
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.linerView.backgroundColor = kTextColor153;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)setTracesModel:(TracesList *)tracesModel{
    _tracesModel = tracesModel;
    /// 物流状态：2-在途中,3-已签收,4-问题件（0时不显示状态轴）
    /// 1-已揽收，
    /// 2-在途中， 201-到达派件城市， 202-派件中， 211-已放入快递柜或驿站，
    /// 3-已签收， 311-已取出快递柜或驿站，
    /// 4-问题件， 401-发货无信息， 402-超时未签收， 403-超时未更新， 404-拒收（退件）， 412-快递柜或驿站超时未取
    /** 发货,发货中,揽件,揽件中,派送,派送中,签收,运输,运输中 */
    self.imagesView.hidden = NO;
    switch (tracesModel.state) {
        case 0:
            Toast(@"不需要显示时间轴");
            break;
        case 1:
            self.imagesView.image = kGetImage(@"揽件");
            self.title_label.text = @"已揽件";
            break;
        case 2:
            self.title_label.text = @"运输中";
            self.imagesView.image = kGetImage(@"运输");
//            self.imagesView_s.image = kGetImage(@"运输中");
            break;
        case 3:
            self.title_label.text = @"已签收";
            self.imagesView.image = kGetImage(@"签收");
            break;
        case 4:
        {
            if (tracesModel.Action==401) {
                Toast(@"发货无信息");
            }else if(tracesModel.Action==402){
                self.imagesView.image = kGetImage(@"签收");
                self.title_label.text = @"超时未签收";
            }else if(tracesModel.Action==403){
                self.title_label.text = @"超时未更新";
                self.imagesView.image = kGetImage(@"签收");
            }else if(tracesModel.Action==404){
                self.title_label.text = @"拒收(退件)";
                self.imagesView.image = kGetImage(@"签收");
            }else if(tracesModel.Action==412){
                self.title_label.text = @"快递柜或驿站超时未取";
                self.imagesView.image = kGetImage(@"签收");
            }
        }
            break;
        default:
            Toast(@"物流状态出错了!");
            break;
    }
    /// 时分
    NSString *formatTime = @"HH:mm";
    /// 月日
    NSString *formatDate = @"MM-dd";
    /// 得到时间戳
    NSInteger timestamp = [Utils lz_getDateTimeWithTimetamp:self.tracesModel.AcceptTime];
    NSString *timestamp_str = [NSString stringWithFormat:@"%ld",timestamp];
    /// 得到时间
    NSString * time= [Utils lz_timeWithTimeIntervalString:timestamp_str formatter:formatTime];
    /// 得到日期
    NSString * date= [Utils lz_timeWithTimeIntervalString:timestamp_str formatter:formatDate];
    
    self.date_label.text = date;
    self.time_label.text = time;
    self.subtitle_label.text = self.tracesModel.AcceptStation;
}

- (void) initView{
    [self.contentView addSubview:self.date_label];
    [self.contentView addSubview:self.time_label];
    
    [self.contentView addSubview:self.linerView];
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.imagesView_s];
    
    [self.contentView addSubview:self.title_label];
    [self.contentView addSubview:self.subtitle_label];
    
    
    CGFloat margin = IPHONE6_W(15.0);
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(70)));
        make.top.equalTo(@(margin));
        make.height.width.equalTo(@(35));
    }];
    [self.imagesView_s mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.width.height.equalTo(self.imageView);
    }];
    [self.date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(IPHONE6_W(70)));
        make.top.equalTo(self.imagesView.mas_top).offset(-3);
    }];
    [self.time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.date_label);
        make.bottom.equalTo(self.imagesView.mas_bottom).offset(3);
    }];

    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(0.5));
        make.centerX.equalTo(self.imagesView);
    }];
    
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right).offset(10);
        make.centerY.equalTo(self.imagesView);
        make.right.equalTo(self.contentView.mas_right).offset(-(margin));
    }];
    [self.subtitle_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_label);
        make.top.equalTo(self.imagesView.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-(margin));
        make.right.equalTo(self.contentView.mas_right).offset(-(margin));
    }];
}

- (UILabel *)date_label{
    if (!_date_label) {
        _date_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        _date_label.textAlignment = NSTextAlignmentCenter;
    }
    return _date_label;
}

- (UILabel *)time_label{
    if (!_time_label) {
        _time_label = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
        _time_label.textAlignment = NSTextAlignmentCenter;
    }
    return _time_label;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.hidden = YES;
    }
    return _imagesView;
}

- (UIImageView *)imagesView_s{
    if (!_imagesView_s) {
        _imagesView_s = [[UIImageView alloc] init];
        _imagesView_s.hidden = YES;
    }
    return _imagesView_s;
}

- (UILabel *)title_label{
    if (!_title_label) {
        _title_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _title_label;
}

- (UILabel *)subtitle_label{
    if (!_subtitle_label) {
        _subtitle_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _subtitle_label;
}

- (UIView *)linerView{
    if (!_linerView) {
        _linerView = [UIView lz_viewWithColor:kTextColor153];
    }
    return _linerView;
}

@end
