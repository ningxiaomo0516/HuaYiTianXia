//
//  TXPurchaseQuantityTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/27.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPurchaseQuantityTableViewCell.h"

@implementation TXPurchaseQuantityTableViewCell

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
    [self addSubview:self.reductionBtn];
    [self addSubview:self.quantityLabel];
    [self addSubview:self.increaseBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(IPHONE6_W(15)));
    }];
    
    [self.increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
    }];
    
    [self.quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.increaseBtn.mas_left).offset(IPHONE6_W(-10));
        make.width.equalTo(@(IPHONE6_W(60)));
        make.height.equalTo(@(IPHONE6_W(27)));
        make.centerY.equalTo(self);
    }];
    
    [self.reductionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.quantityLabel.mas_left).offset(IPHONE6_W(-10));
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"购买数量" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (SCCustomMarginLabel *)quantityLabel{
    if (!_quantityLabel) {
        _quantityLabel = [[SCCustomMarginLabel alloc] init];
        _quantityLabel.text = @"1";
        _quantityLabel.textAlignment = NSTextAlignmentCenter;
        _quantityLabel.textColor = kTextColor51;
        _quantityLabel.font = kFontSizeMedium15;
        _quantityLabel.edgeInsets    = UIEdgeInsetsMake(6.f, 12.f, 6.f, 12.f); // 设置左内边距
        _quantityLabel.borderColor = kThemeColor;
        _quantityLabel.borderWidth = 0.5f;
        [_quantityLabel lz_setCornerRadius:3.0];
        [_quantityLabel sizeToFit]; // 重新计算尺寸
    }
    return _quantityLabel;
}

- (UIButton *)reductionBtn {
    if (!_reductionBtn) {
        _reductionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reductionBtn setImage:kGetImage(@"mine_btn_reduction") forState:UIControlStateNormal];
    }
    return _reductionBtn;
}

- (UIButton *)increaseBtn{
    if (!_increaseBtn) {
        _increaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_increaseBtn setImage:kGetImage(@"mine_btn_increase") forState:UIControlStateNormal];
    }
    return _increaseBtn;
}
@end
