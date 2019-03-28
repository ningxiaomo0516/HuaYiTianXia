//
//  TXMallCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMallCollectionViewCell.h"

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
    self.marketPriceLabel.text = [NSString stringWithFormat:@"￥%@.0",recordsModel.price];
    self.currentPriceLabel.text = @"";
}

- (void)setupUI {
    [self addSubview:self.imagesView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.marketPriceLabel];
    [self addSubview:self.currentPriceLabel];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.centerX.equalTo(self);
        make.height.equalTo(@(IPHONE6_W(134)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(7));
        make.centerX.equalTo(self);
        make.top.equalTo(self.imagesView.mas_bottom).offset(8);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.mas_right).offset(-7);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
    }];
    [self.marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.titleLabel);
    }];
    [self.currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-7);
        make.centerY.equalTo(self.marketPriceLabel);
    }];
}

#pragma mark -- setter getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeScBold13];
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
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
        _subtitleLabel.numberOfLines = 2;
    }
    return _subtitleLabel;
}

- (UILabel *)marketPriceLabel{
    if (!_marketPriceLabel) {
//        _marketPriceLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
        _marketPriceLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"#2DAFF7") font:kFontSizeMedium13];
    }
    return _marketPriceLabel;
}

- (UILabel *)currentPriceLabel{
    if (!_currentPriceLabel) {
        _currentPriceLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"#2DAFF7") font:kFontSizeMedium13];
    }
    return _currentPriceLabel;
}
@end
