//
//  TXCharterBaseInfoTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/1.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterBaseInfoTableViewCell.h"

@implementation TXCharterBaseInfoTableViewCell

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
        self.contentView.backgroundColor = kWhiteColor;
        [self initView];
        self.titleLabel.text = @"请选择发票抬头";
        self.subtitleLabel.text = @"￥150000";
    }
    return self;
}

- (void) initView{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.imagesArrow];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerY.equalTo(self);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
    }];
    [self.imagesArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        _subtitleLabel.hidden = YES;
    }
    return _subtitleLabel;
}

- (UIImageView *)imagesArrow{
    if (!_imagesArrow) {
        _imagesArrow = [[UIImageView alloc] init];
        _imagesArrow.image = kGetImage(@"mine_btn_enter");
        _imagesArrow.hidden = YES;
    }
    return _imagesArrow;
}

@end
