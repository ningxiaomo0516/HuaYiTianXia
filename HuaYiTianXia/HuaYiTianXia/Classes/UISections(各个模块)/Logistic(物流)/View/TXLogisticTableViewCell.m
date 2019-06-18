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
        self.imagesView.image = kGetImage(@"发货");
        
        self.date_label.text = @"06-11";
        self.time_label.text = @"05:16";
        self.title_label.text = @"已签收";
        self.subtitle_label.text = @"【成都市】成都市高新区便民服务服务部派件员小何：电话12354565446正在为您派件";
    }
    return self;
}

- (void) initView{
    [self.contentView addSubview:self.date_label];
    [self.contentView addSubview:self.time_label];
    
    [self.contentView addSubview:self.linerView];
    [self.contentView addSubview:self.imagesView];
    
    [self.contentView addSubview:self.title_label];
    [self.contentView addSubview:self.subtitle_label];
    
    
    CGFloat margin = IPHONE6_W(15.0);
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(70)));
        make.top.equalTo(@(margin));
        make.height.width.equalTo(@(35));
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
    }
    return _imagesView;
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
