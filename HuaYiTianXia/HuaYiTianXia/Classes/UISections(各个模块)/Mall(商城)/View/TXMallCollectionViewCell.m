//
//  TXMallCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMallCollectionViewCell.h"
#import "SCDeleteLineLabel.h"

@implementation TXMallCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kWhiteColor;
        [self setupUI];
        [self lz_setCornerRadius:5.0];
    }
    return self;
}

- (void)setRecordsModel:(NewsRecordsModel *)recordsModel{
    _recordsModel = recordsModel;
    [self.imagesView sd_setImageWithURL:[NSURL URLWithString:recordsModel.coverimg]
                       placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    self.titleLabel.text = recordsModel.title;
    self.subtitleLabel.text = recordsModel.synopsis;
    self.marketPriceLabel.text = [NSString stringWithFormat:@"￥%@",recordsModel.price];
    NSArray *priceArray = [recordsModel.price componentsSeparatedByString:@"."];
    if (priceArray.count>1) {
        if ([Utils isNull:recordsModel.vrcurrency]) {
            
        }
        NSString *x_price = priceArray[0];
        NSInteger hybridPrice = x_price.integerValue - [Utils isNull:recordsModel.vrcurrency].integerValue;
        NSString *h_price = [NSString stringWithFormat:@"￥%ld.%@ + %@VH",hybridPrice,priceArray[1],[Utils isNull:recordsModel.vrcurrency]];
        self.currentPriceLabel.text = h_price;
    }
}

- (void)setupUI {
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.marketPriceLabel];
    [self.contentView addSubview:self.currentPriceLabel];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.centerX.equalTo(self);
        make.height.equalTo(@(IPHONE6_W(145)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(7));
        make.right.equalTo(self.mas_right).offset(-7);
        make.top.equalTo(self.imagesView.mas_bottom).offset(6);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
    }];
    [self.currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.marketPriceLabel.mas_top);
    }];
    [self.marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.titleLabel);
    }];
}

#pragma mark -- setter getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeScBold13];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
        _subtitleLabel.numberOfLines = 1;
    }
    return _subtitleLabel;
}

- (SCDeleteLineLabel *)marketPriceLabel{
    if (!_marketPriceLabel) {
        _marketPriceLabel = [[SCDeleteLineLabel alloc] init];
        _marketPriceLabel.textColor = kTextColor153;
        _marketPriceLabel.font = kFontSizeMedium12;
        _marketPriceLabel.numberOfLines = 1;
    }
    return _marketPriceLabel;
}

- (UILabel *)currentPriceLabel{
    if (!_currentPriceLabel) {
        _currentPriceLabel = [UILabel lz_labelWithTitle:@"" color:kPriceColor font:kFontSizeMedium15];
        _currentPriceLabel.numberOfLines = 1;
    }
    return _currentPriceLabel;
}
@end
