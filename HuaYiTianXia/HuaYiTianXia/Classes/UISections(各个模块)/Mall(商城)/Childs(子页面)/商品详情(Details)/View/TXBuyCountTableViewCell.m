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
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.buyNumLabel];
    [self.boxView addSubview:self.minusBtn];
    [self.boxView addSubview:self.increaseBtn];
    [self addSubview:self.buyCountLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(IPHONE6_W(15)));
    }];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
    }];
    
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.boxView);
        make.height.width.equalTo(@(25));
    }];
    
    [self.buyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minusBtn.mas_right).offset(5);
        make.centerY.equalTo(self.increaseBtn);
        make.width.equalTo(@(IPHONE6_W(25)));
        make.height.equalTo(@(IPHONE6_W(25)));
    }];
    
    [self.increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buyNumLabel.mas_right).offset(5);
        make.centerY.height.width.equalTo(self.minusBtn);
    }];
    
    [self.buyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self.titleLabel);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"购买数量：" color:kTextColor102  font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (SCCustomMarginLabel *)buyNumLabel{
    if (!_buyNumLabel) {
        _buyNumLabel = [[SCCustomMarginLabel alloc] init];
        _buyNumLabel.text = @"1";
        _buyNumLabel.textAlignment = NSTextAlignmentCenter;
        _buyNumLabel.textColor = kTextColor51;
        _buyNumLabel.font = kFontSizeMedium15;
        _buyNumLabel.backgroundColor = kTextColor227;
        _buyNumLabel.edgeInsets    = UIEdgeInsetsMake(2.f, 2.f, 2.f, 2.f); // 设置左内边距
        _buyNumLabel.borderColor = kTextColor227;
        _buyNumLabel.borderWidth = 0.5f;
        [_buyNumLabel lz_setCornerRadius:3.0];
        [_buyNumLabel sizeToFit]; // 重新计算尺寸
    }
    return _buyNumLabel;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
        _boxView.hidden = YES;
    }
    return _boxView;
}

- (SCCustomMarginLabel *)buyCountLabel{
    if (!_buyCountLabel) {
        _buyCountLabel = [[SCCustomMarginLabel alloc] init];
        _buyCountLabel.hidden = YES;
        _buyCountLabel.text = @"1";
        _buyCountLabel.textAlignment = NSTextAlignmentCenter;
        _buyCountLabel.backgroundColor = kColorWithRGB(248, 248, 248);
        _buyCountLabel.textColor = kTextColor102;
        _buyCountLabel.font = kFontSizeMedium15;
        _buyCountLabel.edgeInsets    = UIEdgeInsetsMake(6.f, 20.f, 6.f, 20.f); // 设置左内边距
        [_buyCountLabel lz_setCornerRadius:3.0];
        [_buyCountLabel sizeToFit]; // 重新计算尺寸
    }
    return _buyCountLabel;
}

- (UIButton *)minusBtn{
    if (!_minusBtn) {
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_minusBtn setImage:kGetImage(@"c11_btn_minus") forState:UIControlStateNormal];
//        [_minusBtn setImage:kGetImage(@"mine_btn_reduction") forState:UIControlStateNormal];
        [_minusBtn setBackgroundImage:kGetImage(@"mine_btn_reduction") forState:UIControlStateNormal];
        _minusBtn.tag = 1;
    }
    return _minusBtn;
}

- (UIButton *)increaseBtn{
    if (!_increaseBtn) {
        _increaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_increaseBtn setImage:kGetImage(@"mine_btn_increase") forState:UIControlStateNormal];
        [_increaseBtn setBackgroundImage:kGetImage(@"mine_btn_increase") forState:UIControlStateNormal];
        _increaseBtn.tag = 0;
    }
    return _increaseBtn;
}
@end
