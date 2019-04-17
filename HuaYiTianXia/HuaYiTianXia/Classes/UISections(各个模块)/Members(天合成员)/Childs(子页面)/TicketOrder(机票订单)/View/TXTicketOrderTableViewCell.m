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
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)setOrderModel:(TicketOrderModel *)orderModel{
    _orderModel = orderModel;
    self.o_numLabel.text = [NSString stringWithFormat:@"订单号:%ld",(long)self.orderModel.kid];
    self.o_dateLabel.text = [NSString stringWithFormat:@"订单时间:%@",self.orderModel.datetime];
    self.o_nameLabel.text = [NSString stringWithFormat:@"订单人:%@",self.orderModel.username];
    self.o_priceLabel.text = [NSString stringWithFormat:@"订票价格:%@",self.orderModel.price];
    self.dep_airportLabel.text = [NSString stringWithFormat:@"起始地:%@",self.orderModel.origin];
    self.arv_airportLabel.text = [NSString stringWithFormat:@"目的地:%@",self.orderModel.destination];
}

- (void) initView{
    [self addSubview:self.o_numLabel];
    [self addSubview:self.o_dateLabel];
    [self addSubview:self.o_nameLabel];
    [self addSubview:self.o_priceLabel];
    [self addSubview:self.dep_airportLabel];
    [self addSubview:self.arv_airportLabel];
    [self addSubview:self.imagesTo];
    [self addSubview:self.o_statusLabel];
    
    
    [self.o_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.top.equalTo(@(IPHONE6_W(10)));
    }];
    
    [self.o_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.o_numLabel);
        make.centerY.equalTo(self);
    }];
    
    [self.dep_airportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.o_numLabel);
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-10));
    }];
    
    
    [self.imagesTo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dep_airportLabel);
        make.left.equalTo(self.dep_airportLabel.mas_right).offset(3);
    }];
    
    [self.arv_airportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesTo.mas_right).offset(3);
        make.centerY.equalTo(self.imagesTo);
    }];
    
    [self.o_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.o_numLabel);
        make.left.equalTo(self.o_numLabel.mas_right).offset(100);
    }];
    [self.o_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.o_nameLabel);
        make.left.equalTo(self.o_dateLabel);
    }];
    [self.o_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dep_airportLabel);
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
    }];
}

- (UILabel *)o_numLabel{
    if (!_o_numLabel) {
        _o_numLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium11];
    }
    return _o_numLabel;
}

- (UILabel *)o_dateLabel{
    if (!_o_dateLabel) {
        _o_dateLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium11];
    }
    return _o_dateLabel;
}

- (UILabel *)o_nameLabel{
    if (!_o_nameLabel) {
        _o_nameLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium11];
    }
    return _o_nameLabel;
}

- (UILabel *)o_priceLabel{
    if (!_o_priceLabel) {
        _o_priceLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium11];
    }
    return _o_priceLabel;
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

- (UILabel *)o_statusLabel{
    if (!_o_statusLabel) {
        _o_statusLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium11];
    }
    return _o_statusLabel;
}

- (UIImageView *)imagesTo{
    if (!_imagesTo) {
        _imagesTo = [[UIImageView alloc] init];
        _imagesTo.image = kGetImage(@"转");
    }
    return _imagesTo;
}

@end
