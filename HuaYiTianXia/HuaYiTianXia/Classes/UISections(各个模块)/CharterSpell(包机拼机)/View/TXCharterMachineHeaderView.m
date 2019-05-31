//
//  TXCharterMachineHeaderView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/31.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterMachineHeaderView.h"

@implementation TXCharterMachineHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void) initView{
    [self addSubview:self.headerView];
    [self addSubview:self.headerNavView];
    
    [self.headerNavView addSubview:self.backButton];
    [self.headerNavView addSubview:self.titlelabel];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(kNavBarHeight));
    }];
    
    [self.headerNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.headerView);
        make.height.equalTo(@(kNavBarHeight-kSafeAreaBottomHeight));
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerNavView);
        make.width.equalTo(self.headerNavView.mas_height);
        make.top.bottom.equalTo(self.headerNavView);
    }];
    
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.headerNavView);
    }];
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _headerView;
}

- (UIView *)headerNavView{
    if (!_headerNavView) {
        _headerNavView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _headerNavView;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:kGetImage(@"all_btn_back_grey") forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium16];
    }
    return _titlelabel;
}
@end
