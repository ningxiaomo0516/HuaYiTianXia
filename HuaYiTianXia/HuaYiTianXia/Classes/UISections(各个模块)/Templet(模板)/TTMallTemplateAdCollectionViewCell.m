//
//  TTMallTemplateAdCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/12.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTMallTemplateAdCollectionViewCell.h"

@implementation TTMallTemplateAdCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kRandomColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.endAdLabel];
    [self.contentView addSubview:self.imagesViewAd];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(IPHONE6_W(80)));
    }];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(IPHONE6_W(5)));
//        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-5));
//        make.bottom.equalTo(self.subtitleLabel.mas_top).offset(-5);
//    }];
//
//    [self.imagesViewAd mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.imagesView);
//    }];
//
//    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(5));
//        make.right.equalTo(self.mas_right).offset(-5);
//        make.bottom.equalTo(self.mas_bottom).offset(-5);
//    }];
    
    self.imagesView.image = kGetImage(@"活动_____组");
    self.titleLabel.text = @"无人机体验";
    self.subtitleLabel.text = @"1小时无人机操控";
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium12];
        _subtitleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imagesView;
}

- (SCCustomMarginLabel *)endAdLabel{
    if (!_endAdLabel) {
        _endAdLabel = [[SCCustomMarginLabel alloc] init];
        _endAdLabel.hidden = YES;
        _endAdLabel.text = @"1";
        _endAdLabel.textAlignment = NSTextAlignmentCenter;
        _endAdLabel.backgroundColor = kColorWithRGB(248, 248, 248);
        _endAdLabel.textColor = kTextColor102;
        _endAdLabel.font = kFontSizeMedium15;
        _endAdLabel.edgeInsets    = UIEdgeInsetsMake(0.f, 12.f, 0.f, 12.f); // 设置左内边距
        [_endAdLabel lz_setCornerRadius:3.0];
        [_endAdLabel sizeToFit]; // 重新计算尺寸
    }
    return _endAdLabel;
}

- (UIImageView *)imagesViewAd{
    if (!_imagesViewAd) {
        _imagesViewAd = [[UIImageView alloc] init];
    }
    return _imagesViewAd;
}
@end
