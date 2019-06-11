//
//  TTMallTemplateHotCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/12.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTMallTemplateHotCollectionViewCell.h"

@implementation TTMallTemplateHotCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kWhiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self lz_setCornerRadius:7.0];
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(5)));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-5));
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    self.titleLabel.textColor = kWhiteColor;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        _titleLabel.numberOfLines = 1;
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
@end
