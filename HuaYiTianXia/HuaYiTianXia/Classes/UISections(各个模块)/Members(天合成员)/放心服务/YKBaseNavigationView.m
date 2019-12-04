//
//  YKBaseNavigationView.m
//  YiKao
//
//  Created by 宁小陌 on 2019/8/22.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKBaseNavigationView.h"

@implementation YKBaseNavigationView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kClearColor;
        [self initView];
    }
    return self;
}

- (void) initView{
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.setupButton];
    [self.boxView addSubview:self.imagesView];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(44));
    }];
    [self.setupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self.boxView);
        make.height.width.equalTo(self.boxView.mas_height);
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.boxView);
    }];
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kClearColor];
    }
    return _boxView;
}

- (UIButton *)setupButton{
    if (!_setupButton) {
        _setupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setupButton setImage:kGetImage(@"all_btn_back_grey") forState:UIControlStateNormal];
        _setupButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _setupButton;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}
@end
