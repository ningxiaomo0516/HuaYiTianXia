//
//  TXShareToolsCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXShareToolsCollectionViewCell.h"

@implementation TXShareToolsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kClearColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.imagesView];
    [self addSubview:self.titleLabel];
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.width.equalTo(@(IPHONE6_W(55)));
        make.top.equalTo(@(IPHONE6_W(15)));
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.boxView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-15));
    }];
}

#pragma mark -- setter getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor12 font:kFontSizeMedium12];
    }
    return _titleLabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
        [_boxView lz_setCornerRadius:10.0];
    }
    return _boxView;
}

@end
