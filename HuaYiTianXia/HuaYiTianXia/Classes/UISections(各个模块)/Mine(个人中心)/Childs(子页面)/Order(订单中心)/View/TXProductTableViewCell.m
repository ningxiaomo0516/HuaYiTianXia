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
        self.imagesView.image = kGetImage(@"test_work");
        self.titleLabel.text = @"星际纵横矿机 ";
        self.contentLabel.text = @"型号4T A0055型号4T A0055型号4T 型号4T型号4T型号4T型号4T型号4T";;
        self.priceLabel.text = @"￥500000";
        self.dateTimeLabel.text = @"2018/12/21 12:50:10";
    }
    return self;
}

- (void)setOrderModel:(OrderModel *)orderModel{
    _orderModel = orderModel;
    [self.imagesView sd_setImageWithURL:kGetImageURL(self.orderModel.coverimg)
                       placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    self.titleLabel.text = self.orderModel.title;
    self.contentLabel.text = self.orderModel.spec;
    self.priceLabel.text = kStringFormat(@"￥", self.orderModel.totalMoney);
    self.dateTimeLabel.text = self.orderModel.time;
}

- (void) initView{
    [self addSubview:self.imagesView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.dateTimeLabel];
    
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(IPHONE6_W(85)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right).offset(13);
        make.top.equalTo(@(IPHONE6_W(17)));
        make.height.equalTo(@(15));
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
    }];
    [self.dateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-15));
        make.left.equalTo(self.titleLabel);
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
        _contentLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium12];
        _contentLabel.numberOfLines = 1;
    }
    return _contentLabel;
}

- (UILabel *)dateTimeLabel{
    if (!_dateTimeLabel) {
        _dateTimeLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium12];
    }
    return _dateTimeLabel;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"2DAFF7") font:kFontSizeMedium12];
    }
    return _priceLabel;
}

@end
