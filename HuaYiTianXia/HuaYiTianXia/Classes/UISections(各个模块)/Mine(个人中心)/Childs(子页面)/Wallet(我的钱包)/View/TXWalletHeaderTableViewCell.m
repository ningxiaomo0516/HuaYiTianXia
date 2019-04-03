//
//  TXWalletHeaderTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/3.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXWalletHeaderTableViewCell.h"

@implementation TXWalletHeaderTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void) initView{
    [self addSubview:self.imagesViewBG];
    [self addSubview:self.balanceTipsLabel];
    [self addSubview:self.balanceLabel];
    [self.imagesViewBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(IPHONE6_W(40)));
    }];
    
    [self.balanceTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.balanceLabel);
        make.top.equalTo(self.balanceLabel.mas_bottom).offset(IPHONE6_W(5));
    }];
}

- (UIImageView *)imagesViewBG{
    if (!_imagesViewBG) {
        _imagesViewBG = [[UIImageView alloc] init];
        _imagesViewBG.image = kGetImage(@"mine_bg_images");
    }
    return _imagesViewBG;
}

- (UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium30];
    }
    return _balanceLabel;
}

- (UILabel *)balanceTipsLabel{
    if (!_balanceTipsLabel) {
        _balanceTipsLabel = [UILabel lz_labelWithTitle:@"余额" color:kWhiteColor font:kFontSizeMedium14];
    }
    return _balanceTipsLabel;
}

@end
