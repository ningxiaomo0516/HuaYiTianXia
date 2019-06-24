//
//  TXClubChildRecommendedTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXClubChildRecommendedTableViewCell.h"

@implementation TXClubChildRecommendedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kWhiteColor;
        [self initView];
        self.titleLabel.text = @"ROBINSON R44";
        self.priceLabel.text = @"￥4,200,000.00";
        self.paymentNumLabel.text = @"256人付款";
    }
    return self;
}

- (void)setDataModel:(RecommendChildModel *)dataModel{
    _dataModel = dataModel;
    self.titleLabel.text = self.dataModel.title;
    self.paymentNumLabel.text = [NSString stringWithFormat:@"已有%@人购买",self.dataModel.signup];
    NSString *icon = @"￥";
    NSString *amountText11 = [NSString stringWithFormat:@"%@%@",icon,self.dataModel.startPrice];
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:amountText11];
    // 前面文字大小
    [mutableAttr addAttribute:NSFontAttributeName
                        value:kFontSizeMedium15
                        range:NSMakeRange(0, icon.length)];
    self.priceLabel.attributedText = mutableAttr;
}

- (void) initView{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.paymentNumLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.left.equalTo(@(15));
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    [self.paymentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(5);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"#FC9B33") font:[UIFont boldSystemFontOfSize:20.0]];
    }
    return _priceLabel;
}

- (UILabel *)paymentNumLabel{
    if (!_paymentNumLabel) {
        _paymentNumLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium15];
    }
    return _paymentNumLabel;
}
@end
