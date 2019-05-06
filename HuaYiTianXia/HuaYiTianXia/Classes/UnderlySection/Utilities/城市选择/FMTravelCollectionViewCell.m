//
//  FMTravelCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/6.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "FMTravelCollectionViewCell.h"

@implementation FMTravelCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self lz_setCornerRadius:3.0];
    [self addSubview:self.cityLabel];
}

#pragma mark -- setter getter

- (UILabel *)cityLabel{
    if (!_cityLabel) {
        _cityLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium13];
        _cityLabel.hidden = YES;
    }
    return _cityLabel;
}

@end
