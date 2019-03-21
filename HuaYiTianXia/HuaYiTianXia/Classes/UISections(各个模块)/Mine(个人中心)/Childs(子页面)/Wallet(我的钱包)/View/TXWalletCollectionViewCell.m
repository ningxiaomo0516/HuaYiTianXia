//
//  TXWalletCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXWalletCollectionViewCell.h"

@implementation TXWalletCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kWhiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.imagesView];
    [self addSubview:self.titleLabel];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(IPHONE6_W(20)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imagesView.mas_bottom).offset(IPHONE6_W(9));
    }];
    
    UIView *horLineView = [[UIView alloc] init];
    horLineView.backgroundColor = kColorWithRGB(237, 237, 237);
    [self.contentView addSubview:horLineView];
    [horLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.bottom.and.trailing.equalTo(@(0));
        make.height.equalTo(@0.5);
    }];
    
    UIView *verLineView = [[UIView alloc] init];
    verLineView.backgroundColor = kColorWithRGB(237, 237, 237);
    [self.contentView addSubview:verLineView];
    [verLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.trailing.equalTo(@(0));
        make.width.equalTo(@0.5);
    }];
}

#pragma mark -- setter getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium14];
    }
    return _titleLabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}
@end
