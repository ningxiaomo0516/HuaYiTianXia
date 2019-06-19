//
//  TXMallClubSectionView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMallClubSectionView.h"

@implementation TXMallClubSectionView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void) initView{
    [self addSubview:self.headerIcon];
    [self addSubview:self.headerTitle];
    [self.headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerY.equalTo(self);
    }];
    [self.headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIcon.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = [UILabel lz_labelWithTitle:@"" color:kThemeColorHex font:kFontSizeScBold17];
    }
    return _headerTitle;
}

- (UIImageView *)headerIcon{
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc] init];
    }
    return _headerIcon;
}
@end
