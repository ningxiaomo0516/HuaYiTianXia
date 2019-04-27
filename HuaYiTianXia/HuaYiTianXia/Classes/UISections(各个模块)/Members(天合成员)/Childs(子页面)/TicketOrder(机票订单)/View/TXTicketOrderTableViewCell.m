//
//  TXTicketOrderTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/17.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTicketOrderTableViewCell.h"

@implementation TXTicketOrderTableViewCell

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
        self.contentView.backgroundColor = kViewColorNormal;
        [self initView];
    }
    return self;
}

- (void)setOrderModel:(TicketOrderModel *)orderModel{
    _orderModel = orderModel;
    self.o_numLabel.text = [NSString stringWithFormat:@"订单号:%@",self.orderModel.orderNumber];
    self.o_dateLabel.text = [NSString stringWithFormat:@"订单时间:%@",self.orderModel.datetime];
    self.o_nameLabel.text = [NSString stringWithFormat:@"订单人:%@",self.orderModel.username];
    NSString *o_price = [NSString stringWithFormat:@"￥%@",self.orderModel.price];
    self.dep_airportLabel.text = self.orderModel.origin;
    self.arv_airportLabel.text = self.orderModel.destination;
    self.o_statusLabel.text = self.orderModel.typeName;
    
    self.o_priceLabel.attributedText = [SCSmallTools setupTextColor:HexString(@"#FE881C") currentText:o_price index:1 endIndex:o_price.length-1];

    self.dep_city_label.text = @"成都";
    self.arv_city_label.text = @"广州";
}

- (void) initView{
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.linerView];
    [self.boxView addSubview:self.o_numLabel];
    
    [self.boxView addSubview:self.dep_city_label];
    [self.boxView addSubview:self.dep_arv_liner_h];
    [self.boxView addSubview:self.arv_city_label];
    
    [self.boxView addSubview:self.dep_airportLabel];
    [self.boxView addSubview:self.dep_arv_liner_v];
    [self.boxView addSubview:self.arv_airportLabel];
    [self.boxView addSubview:self.imagesViewPlane];
    
    [self.boxView addSubview:self.o_numLabel];
    [self.boxView addSubview:self.o_dateLabel];
    [self.boxView addSubview:self.o_nameLabel];
    [self.boxView addSubview:self.o_priceLabel];
    [self.boxView addSubview:self.dep_airportLabel];
    [self.boxView addSubview:self.arv_airportLabel];
    [self.boxView addSubview:self.o_statusLabel];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.top.bottom.equalTo(self);
    }];
    
    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.boxView);
        make.top.equalTo(@(IPHONE6_W(35)));
        make.height.equalTo(@(0.5));
    }];
    
    [self.o_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.top.equalTo(self.boxView);
        make.bottom.equalTo(self.linerView);
    }];
    
    [self.dep_city_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.o_numLabel);
        make.top.equalTo(self.linerView.mas_bottom).offset(IPHONE6_W(10));
    }];
    
    [self.dep_arv_liner_h mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_city_label.mas_right).offset(5);
        make.centerY.equalTo(self.dep_city_label);
        make.height.equalTo(@(2));
        make.width.equalTo(@(10));
    }];
    
    [self.arv_city_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_arv_liner_h.mas_right).offset(5);
        make.centerY.equalTo(self.dep_arv_liner_h);
    }];
    
    [self.o_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dep_city_label);
        make.right.equalTo(self.boxView.mas_right).offset(IPHONE6_W(-15));
    }];
    
    [self.imagesViewPlane mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.o_numLabel);
        make.top.equalTo(self.dep_city_label.mas_bottom).offset(IPHONE6_W(10));
    }];
    
    [self.dep_airportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.o_numLabel);
//        make.top.equalTo(self.linerView.mas_bottom).offset(IPHONE6_W(10));
        make.bottom.equalTo(self.boxView.mas_bottom).offset(IPHONE6_W(-10));
    }];
    [self.dep_arv_liner_v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_airportLabel.mas_right).offset(5);
        make.centerY.equalTo(self.dep_airportLabel);
        make.height.equalTo(@(2));
        make.width.equalTo(@(10));
    }];
    
    [self.arv_airportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_arv_liner_v.mas_right).offset(5);
        make.centerY.equalTo(self.dep_airportLabel);
    }];
    
    
    
    
//    [self.o_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.o_numLabel);
//        make.centerY.equalTo(self);
//    }];
//
//    [self.dep_airportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.o_numLabel);
//        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-10));
//    }];
//
//
//    [self.o_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.o_numLabel);
//        make.centerX.equalTo(self).offset(IPHONE6_W(80));
//    }];
//    [self.o_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.o_nameLabel);
//        make.left.equalTo(self.o_dateLabel);
//    }];
//    [self.o_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.dep_airportLabel);
//        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
//    }];
}

- (UILabel *)o_numLabel{
    if (!_o_numLabel) {
        _o_numLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
    }
    return _o_numLabel;
}

- (UILabel *)o_dateLabel{
    if (!_o_dateLabel) {
        _o_dateLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
    }
    return _o_dateLabel;
}

- (UILabel *)o_nameLabel{
    if (!_o_nameLabel) {
        _o_nameLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
    }
    return _o_nameLabel;
}

- (UILabel *)o_priceLabel{
    if (!_o_priceLabel) {
        _o_priceLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"#FE881C") font:kFontSizeMedium13];
    }
    return _o_priceLabel;
}

- (UILabel *)o_statusLabel{
    if (!_o_statusLabel) {
        _o_statusLabel = [UILabel lz_labelWithTitle:@"" color:kThemeColor font:kFontSizeMedium13];
    }
    return _o_statusLabel;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
        [_boxView lz_setCornerRadius:10.0f];
    }
    return _boxView;
}

- (UIView *)linerView{
    if (!_linerView) {
        _linerView = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView;
}

- (UILabel *)dep_city_label{
    if (!_dep_city_label) {
        _dep_city_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _dep_city_label;
}

- (UIView *)dep_arv_liner_h{
    if (!_dep_arv_liner_h) {
        _dep_arv_liner_h = [UIView lz_viewWithColor:kTextColor51];
    }
    return _dep_arv_liner_h;
}

- (UILabel *)arv_city_label{
    if (!_arv_city_label) {
        _arv_city_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _arv_city_label;
}



- (UILabel *)dep_airportLabel{
    if (!_dep_airportLabel) {
        _dep_airportLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium15];
    }
    return _dep_airportLabel;
}

- (UILabel *)arv_airportLabel{
    if (!_arv_airportLabel) {
        _arv_airportLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium15];
    }
    return _arv_airportLabel;
}

- (UIView *)dep_arv_liner_v{
    if (!_dep_arv_liner_v) {
        _dep_arv_liner_v = [UIView lz_viewWithColor:kTextColor102];
    }
    return _dep_arv_liner_v;
}

- (UIImageView *)imagesViewPlane{
    if (!_imagesViewPlane) {
        _imagesViewPlane = [[UIImageView alloc] init];
        _imagesViewPlane.image = kGetImage(@"c41_plane");
    }
    return _imagesViewPlane;
}
@end
