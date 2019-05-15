//
//  TXMallUAVAdCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMallUAVAdCollectionViewCell.h"

@implementation TXMallUAVAdCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
        self.imagesView.image = kGetImage(@"base_deprecated_activity");
        self.titleLabel.text = @"无人机体验";
        self.subtitleLabel.text = @"1小时无人机操控";
    }
    return self;
}

- (void)setModel:(MallUAVListModel *)model{
    _model = model;
    self.titleLabel.text = self.model.title;
    self.subtitleLabel.text = self.model.synopsis;
    [self.imagesView sd_setImageWithURL:kGetImageURL(self.model.coverimg) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
}

- (void)setupUI {
    [self lz_setCornerRadius:5.0];
    
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.imagesViewAd];
    [self.contentView addSubview:self.endAdLabel];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.mas_bottom).offset(-50);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagesView.mas_bottom).offset(6);
        make.right.equalTo(self);
        make.left.equalTo(@(5));
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-6);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    [self.imagesViewAd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.imagesView);
    }];
    [self.endAdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imagesView.mas_bottom).offset(-3);
        make.right.equalTo(self.imagesView.mas_right).offset(-3);
    }];
    self.titleLabel.textColor = kTextColor51;
    self.subtitleLabel.textColor = kTextColor102;
    self.subtitleLabel.text = self.model.synopsis;
    self.endAdLabel.text = @"活动结束";
}


#pragma mark -- setter getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium14];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.contentMode = UIViewContentModeScaleAspectFill;
        _imagesView.clipsToBounds = YES;
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

- (UIImageView *)imagesViewAd{
    if (!_imagesViewAd) {
        _imagesViewAd = [[UIImageView alloc] init];
        _imagesViewAd.image = kGetImage(@"c22_mall_hot");
    }
    return _imagesViewAd;
}

- (SCCustomMarginLabel *)endAdLabel{
    if (!_endAdLabel) {
        _endAdLabel = [[SCCustomMarginLabel alloc] init];
        _endAdLabel.text = @"1";
        _endAdLabel.textAlignment = NSTextAlignmentCenter;
        _endAdLabel.backgroundColor = [kBlackColor colorWithAlphaComponent:0.4];
        _endAdLabel.textColor = kWhiteColor;
        _endAdLabel.font = kFontSizeMedium10;
        _endAdLabel.edgeInsets    = UIEdgeInsetsMake(2.f, 6.f, 2.f, 6.f); // 设置左内边距
        [_endAdLabel lz_setCornerRadius:9.0];
        [_endAdLabel sizeToFit]; // 重新计算尺寸
    }
    return _endAdLabel;
}
@end
