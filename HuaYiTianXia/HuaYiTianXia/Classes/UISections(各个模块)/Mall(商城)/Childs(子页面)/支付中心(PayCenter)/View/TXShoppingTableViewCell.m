//
//  TXShoppingTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXShoppingTableViewCell.h"

@implementation TXShoppingTableViewCell

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
//        self.titleLabel.text = @"法国进口红酒 传奇波尔多干葡萄";
//        self.imagesView.image = kGetImage(@"test_work");
//        self.specLabel.text = @"规格:苏哈相机";
//        self.subtitleLabel.text = @"Mavic 2带屏升级版火爆销售中，5.5寸高亮屏，高清图片上传会员减免优币抵现";
//        self.priceLabel.text = @"¥399.00";
    }
    return self;
}

- (void)setModel:(NewsRecordsModel *)model{
    _model = model;
    [self.imagesView sd_setImageWithURL:[NSURL URLWithString:self.model.coverimg]
                       placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    
    self.titleLabel.text = self.model.title;
    [self.imagesView sd_setImageWithURL:[NSURL URLWithString:self.model.coverimg]
                        placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    if (self.model.prospec.count>0) {
        self.specLabel.text =  self.model.prospec[0];
    }else{
        self.specLabel.hidden = YES;
    }
    
    self.subtitleLabel.text = self.model.synopsis;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    NSString *icon = @"￥";
    NSString *amountText = [NSString stringWithFormat:@"%@ + %@VH",model.nowprice,model.vrcurrency];
    NSString *str = [NSString stringWithFormat:@"%@%@",icon,amountText];
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:str];
    // 前面文字大小
    [mutableAttr addAttribute:NSFontAttributeName
                        value:kFontSizeMedium15
                        range:NSMakeRange(0, icon.length)];
    self.currentPriceLabel.attributedText = mutableAttr;
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.imagesView];
    [self addSubview:self.specLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.currentPriceLabel];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(IPHONE6_W(100)));
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right).offset(IPHONE6_W(15));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.top.equalTo(self.imagesView.mas_top).offset(-3);
    }];
    
    [self.specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE6_W(3));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.specLabel.mas_bottom).offset(IPHONE6_W(3));
    }];
    [self.currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.priceLabel.mas_top);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.imagesView.mas_bottom).offset(3);
    }];
}

- (UIImageView *)imagesView {
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

#pragma mark -- setter getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UILabel *)specLabel{
    if (!_specLabel) {
        _specLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
    }
    return _specLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
        _subtitleLabel.numberOfLines = 2;
    }
    return _subtitleLabel;
}

- (UILabel *)currentPriceLabel{
    if (!_currentPriceLabel) {
        _currentPriceLabel = [UILabel lz_labelWithTitle:@"" color:kPriceColor font:kFontSizeMedium17];
    }
    return _currentPriceLabel;
}

- (SCDeleteLineLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[SCDeleteLineLabel alloc] init];
        _priceLabel.font = kFontSizeMedium13;
        _priceLabel.textColor = kTextColor153;
    }
    return _priceLabel;
}
@end
