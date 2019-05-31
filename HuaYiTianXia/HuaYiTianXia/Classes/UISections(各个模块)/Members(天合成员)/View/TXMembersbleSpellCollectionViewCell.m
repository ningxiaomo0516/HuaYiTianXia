//
//  TXMembersbleSpellCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/31.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMembersbleSpellCollectionViewCell.h"

@implementation TXMembersbleSpellCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kWhiteColor;
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.spellButton];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(IPHONE6_W(10)));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-10));
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-10));
    }];
    [self.spellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imagesView.mas_right).offset(-5);
        make.centerY.equalTo(self);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.image = kGetImage(@"c49_我要拼机");
    }
    return _imagesView;
}

- (UIButton *)spellButton{
    if (!_spellButton) {
        _spellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_spellButton setBackgroundImage:kGetImage(@"我要拼机按钮键") forState:UIControlStateNormal];
    }
    return _spellButton;
}

@end
