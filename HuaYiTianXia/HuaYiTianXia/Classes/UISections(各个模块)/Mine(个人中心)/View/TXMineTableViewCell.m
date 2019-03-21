//
//  TXMineTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMineTableViewCell.h"

@implementation TXMineTableViewCell

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

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.imagesArrow];
    [self addSubview:self.imagesAvatar];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imagesArrow.mas_left).offset(IPHONE6_W(-10));
        make.centerY.equalTo(self);
    }];
    
    [self.imagesArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self);
    }];
    
    [self.imagesAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imagesArrow.mas_left).offset(IPHONE6_W(-10));
        make.width.height.equalTo(@(IPHONE6_W(41)));
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
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor128 font:kFontSizeMedium15];
        _subtitleLabel.hidden = YES;
    }
    return _subtitleLabel;
}

- (UIImageView *)imagesArrow{
    if (!_imagesArrow) {
        _imagesArrow = [[UIImageView alloc] init];
        _imagesArrow.image = kGetImage(@"right_arrow");
    }
    return _imagesArrow;
}

- (UIImageView *)imagesAvatar{
    if (!_imagesAvatar) {
        _imagesAvatar = [[UIImageView alloc] init];
        [_imagesAvatar lz_setCornerRadius:IPHONE6_W(41)/2.0];
        _imagesAvatar.hidden = YES;
    }
    return _imagesAvatar;
}
@end
