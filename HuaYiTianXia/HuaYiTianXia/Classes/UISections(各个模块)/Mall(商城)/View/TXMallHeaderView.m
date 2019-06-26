//
//  TXMallHeaderView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/26.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMallHeaderView.h"

@interface TXMallHeaderView ()

@end

@implementation TXMallHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void) initView{
    [self addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.top.right.equalTo(self);
        //        make.height.equalTo(@(kNavBarHeight));
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.image = kButtonColorNormal;
    }
    return _imagesView;
}
@end

