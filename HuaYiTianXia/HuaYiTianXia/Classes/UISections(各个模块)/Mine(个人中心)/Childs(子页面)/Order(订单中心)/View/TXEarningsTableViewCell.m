//
//  TXEarningsTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXEarningsTableViewCell.h"

@implementation TXEarningsTableViewCell

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
        self.titleLabel.text = @"纵横矿机 ";
        self.priceLabel.text = @"50.40";
        self.dateLabel.text = @"2018/12/21";
    }
    return self;
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.dateLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.top.equalTo(@(IPHONE6_W(10)));
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-10));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeScBold15];
    }
    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium12];
    }
    return _dateLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"2DAFF7") font:kFontSizeMedium20];
    }
    return _priceLabel;
}

@end
