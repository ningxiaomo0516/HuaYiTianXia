//
//  TXMembersbleCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMembersbleCollectionViewCell.h"

@implementation TXMembersbleCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kClearColor;
        [self setupUI];
        [self lz_setCornerRadius:5.0];
    }
    return self;
}
- (void) setupUI{
    [self addSubview:self.imagesView];
    [self addSubview:self.titleLabel];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom .equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.imagesView);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeScBold17];
    }
    return _titleLabel;
}
@end
