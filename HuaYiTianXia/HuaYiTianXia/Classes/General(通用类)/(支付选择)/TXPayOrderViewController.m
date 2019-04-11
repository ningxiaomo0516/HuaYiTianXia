//
//  TXPayOrderViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/11.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPayOrderViewController.h"

@interface TXPayOrderViewController ()


@end

@implementation TXPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.priceLabel.text = @"3000";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = HexString(@"#2DACF7");
}


- (void) initView{
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.closeButton];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(10));
        make.height.width.equalTo(@(44));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.centerY.equalTo(self.closeButton);
    }];
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:kGetImage(@"c12_btn_o_close") forState:UIControlStateNormal];
        MV(weakSelf);
        [_closeButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _closeButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"起投金额（元）" color:kWhiteColor font:kFontSizeMedium16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

@end
