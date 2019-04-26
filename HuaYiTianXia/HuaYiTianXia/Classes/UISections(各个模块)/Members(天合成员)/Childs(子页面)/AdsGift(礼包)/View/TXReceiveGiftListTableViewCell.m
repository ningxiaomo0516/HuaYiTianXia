//
//  TXReceiveGiftListTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXReceiveGiftListTableViewCell.h"

@implementation TXReceiveGiftListTableViewCell

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
        self.titleLabel.text = @"购买记录";
        self.subtitleLabel.text = @"星级纵横矿机";
        self.dateLabel.text = @"2018/12/21";
    }
    return self;
}

- (void)setModel:(NewsRecordsModel *)model{
    self.titleLabel.text = model.pname;
    self.subtitleLabel.text = model.typeName;
//    self.dateLabel.text = model.time;
    self.dateLabel.text = @"2018/12/21";
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.dateLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@(IPHONE6_W(15)));
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-15));
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
    }
    return _dateLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"2DAFF7")  font:kFontSizeMedium13];
    }
    return _subtitleLabel;
}
@end
