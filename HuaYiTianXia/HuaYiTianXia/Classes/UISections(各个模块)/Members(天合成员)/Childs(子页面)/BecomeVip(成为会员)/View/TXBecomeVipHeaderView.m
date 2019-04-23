//
//  TXBecomeVipHeaderView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXBecomeVipHeaderView.h"

@implementation TXBecomeVipHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void) initView{
    [self addSubview:self.imagesViewAds];
    [self addSubview:self.imagesViewVip];
    [self.imagesViewAds mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
    }];
    [self.imagesViewVip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}

- (UIImageView *)imagesViewAds{
    if (!_imagesViewAds) {
        _imagesViewAds = [[UIImageView alloc] init];
        _imagesViewAds.image = kGetImage(@"c22_btn_ads");
    }
    return _imagesViewAds;
}

- (UIImageView *)imagesViewVip{
    if (!_imagesViewVip) {
        _imagesViewVip = [[UIImageView alloc] init];
        _imagesViewVip.image = kGetImage(@"c22_btn_vip");
    }
    return _imagesViewVip;
}

@end
