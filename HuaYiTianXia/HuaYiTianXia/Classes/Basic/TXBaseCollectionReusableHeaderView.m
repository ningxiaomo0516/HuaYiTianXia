//
//  TXBaseCollectionReusableHeaderView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/15.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXBaseCollectionReusableHeaderView.h"

@implementation TXBaseCollectionReusableHeaderView

#pragma mark getter setter
- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel lz_labelWithTitle:@"会员精选" color:kTextColor51 font:kFontSizeScBold17];
    }
    return _dateLabel;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.center.mas_offset(0);
        make.height.equalTo(@20);
    }];
}
@end
