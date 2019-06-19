//
//  TXProductTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXProductTableViewCell.h"

@implementation TXProductTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        self.image_coin.image = kGetImage(@"c9_btn_coin");
    }
    return self;
}

- (void)setOrderModel:(OrderModel *)orderModel{
    _orderModel = orderModel;
    [self.imagesView sd_setImageWithURL:kGetImageURL(self.orderModel.coverimg)
                       placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    self.titleLabel.text = self.orderModel.title;
    self.contentLabel.text = self.orderModel.synopsis;
    self.priceLabel.text = kStringFormat(@"￥", self.orderModel.totalMoney);
    self.dateTimeLabel.text = self.orderModel.time;
    self.attributedText.text = self.orderModel.totalCurrency;
    if (self.orderModel.logisticsNo.length==0) {
        self.lookLogisticBtn.hidden = YES;
        [self.lookContractBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
        }];
    }
}

- (void) initView{
    [self addSubview:self.imagesView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.dateTimeLabel];
    [self addSubview:self.lookContractBtn];
    [self addSubview:self.attributedText];
    [self addSubview:self.image_coin];
    [self addSubview:self.lookLogisticBtn];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(IPHONE6_W(85)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right).offset(13);
        make.top.equalTo(self.imagesView.mas_top);
        make.height.equalTo(@(15));
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.equalTo(self.lookContractBtn.mas_left).offset(-15);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.dateTimeLabel.mas_top).offset(-1);
    }];
    [self.dateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-10));
        make.left.equalTo(self.titleLabel);
    }];
    CGFloat top = self.height/2;
    [self.lookContractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-top);
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.height.equalTo(@(IPHONE6_W(27)));
        make.width.equalTo(@(IPHONE6_W(65)));
    }];
    
    [self.lookLogisticBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.height.width.equalTo(self.lookContractBtn);
        make.centerY.equalTo(self).offset(top);
    }];
    [self.image_coin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(10);
        make.centerY.equalTo(self.priceLabel);
    }];
    [self.attributedText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image_coin.mas_right).offset(3);
        make.centerY.equalTo(self.priceLabel);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        [_imagesView lz_setCornerRadius:5.0];
    }
    return _imagesView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeScBold15];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
        _contentLabel.numberOfLines = 1;
    }
    return _contentLabel;
}

- (UILabel *)dateTimeLabel{
    if (!_dateTimeLabel) {
        _dateTimeLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
    }
    return _dateTimeLabel;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:kPriceColor font:kFontSizeMedium15];
    }
    return _priceLabel;
}

- (UILabel *)attributedText{
    if (!_attributedText) {
        _attributedText = [UILabel lz_labelWithTitle:@"" color:kPriceColor font:kFontSizeMedium15];
    }
    return _attributedText;
}

- (UIButton *)lookContractBtn{
    if (!_lookContractBtn) {
        _lookContractBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_lookContractBtn setTitleColor:kThemeColorHex forState:UIControlStateNormal];
        [_lookContractBtn setTitle:@"查看合同" forState:UIControlStateNormal];
        _lookContractBtn.titleLabel.font = kFontSizeMedium12;
        [_lookContractBtn setBorderColor:kThemeColorHex];
        [_lookContractBtn setBorderWidth:0.7];
        [_lookContractBtn lz_setCornerRadius:IPHONE6_W(5.0)];
    }
    return _lookContractBtn;
}

- (UIButton *)lookLogisticBtn{
    if (!_lookLogisticBtn) {
        _lookLogisticBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_lookLogisticBtn setTitleColor:kThemeColorHex forState:UIControlStateNormal];
        [_lookLogisticBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        _lookLogisticBtn.titleLabel.font = kFontSizeMedium12;
        [_lookLogisticBtn setBorderColor:kThemeColorHex];
        [_lookLogisticBtn setBorderWidth:0.7];
        [_lookLogisticBtn lz_setCornerRadius:IPHONE6_W(5.0)];
    }
    return _lookLogisticBtn;
}

- (UIImageView *)image_coin{
    if (!_image_coin) {
        _image_coin = [[UIImageView alloc] init];
    }
    return _image_coin;
}

@end
