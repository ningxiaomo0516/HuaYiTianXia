//
//  TXMallGoodsDetailsTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMallGoodsDetailsTableViewCell.h"

@implementation TXMallGoodsDetailsTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)setModel:(NewsRecordsModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.synopsis;
    self.marketPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    NSString *icon = @"￥";
    NSString *amountText = [NSString stringWithFormat:@"%@ + %@VH",model.nowprice,model.vrcurrency];//@"12859 + 600VH";
    NSString *str = [NSString stringWithFormat:@"%@%@",icon,amountText];
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:str];
    // 前面文字大小
    [mutableAttr addAttribute:NSFontAttributeName
                        value:kFontSizeMedium15
                        range:NSMakeRange(0, icon.length)];
    self.priceLabel.attributedText = mutableAttr;
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.marketPriceLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.top.equalTo(@(IPHONE6_W(10)));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.subtitleLabel.mas_bottom);
    }];
    [self.marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.priceLabel.mas_bottom);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51  font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor204  font:kFontSizeMedium13];
        _subtitleLabel.numberOfLines = 1;
    }
    return _subtitleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:kPriceColor  font:kFontSizeMedium25];
    }
    return _priceLabel;
}

- (SCDeleteLineLabel *)marketPriceLabel{
    if (!_marketPriceLabel) {
        _marketPriceLabel = [[SCDeleteLineLabel alloc] init];
        _marketPriceLabel.textColor = kTextColor153;
    }
    return _marketPriceLabel;
}
@end
