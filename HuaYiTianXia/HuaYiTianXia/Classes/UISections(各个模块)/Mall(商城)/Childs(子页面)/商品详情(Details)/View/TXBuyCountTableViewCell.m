//
//  TXBuyCountTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXBuyCountTableViewCell.h"

@implementation TXBuyCountTableViewCell

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

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(IPHONE6_W(15)));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self.titleLabel);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"购买数量：" color:kTextColor102  font:kFontSizeMedium13];
    }
    return _titleLabel;
}

- (SCCustomMarginLabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [[SCCustomMarginLabel alloc] init];
        _subtitleLabel.text = @"1";
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.backgroundColor = kColorWithRGB(248, 248, 248);
        _subtitleLabel.textColor = kTextColor102;
        _subtitleLabel.font = kFontSizeMedium15;
        _subtitleLabel.edgeInsets    = UIEdgeInsetsMake(6.f, 20.f, 6.f, 20.f); // 设置左内边距
        [_subtitleLabel lz_setCornerRadius:3.0];
        [_subtitleLabel sizeToFit]; // 重新计算尺寸
    }
    return _subtitleLabel;
}
@end
