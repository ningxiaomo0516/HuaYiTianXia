//
//  TXPayOrderVC.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/12.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPayOrderVC.h"
#import "TXChoosePayViewController.h"

@interface TXPayOrderVC ()

@end

@implementation TXPayOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.totalPriceLabel.text = @"3000";
    self.priceLabel.text = @"3000";
    self.specLabel.text = @"4T";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kWhiteColor;
}


- (void) onClick:(UIButton *)sender{
    if (sender.tag==0) {
        
    }else if (sender.tag==1){
        
    }else if (sender.tag==2){
        TXChoosePayViewController *vc = [[TXChoosePayViewController alloc] init];
        [self sc_bottomPresentController:vc presentedHeight:IPHONE6_W(kiPhoneX_T(230)) completeHandle:^(BOOL presented) {
            if (presented) {
                [self sc_dismissVC];
                TTLog(@"弹出了");
            }else{
                TTLog(@"消失了");
            }
        }];
    }else{
        Toast(@"未知按钮的点击");
    }
}


- (void) initView{
    [self.view addSubview:self.boxView];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.closeButton];
    [self.boxView addSubview:self.totalPriceLabel];
    
    [self.view addSubview:self.specTipsLabel];
    [self.view addSubview:self.specLabel];
    
    [self.view addSubview:self.priceTipsLabel];
    [self.view addSubview:self.priceLabel];
    
    [self.view addSubview:self.minusBtn];
    [self.view addSubview:self.increaseBtn];
    
    [self.view addSubview:self.linerView1];
    [self.view addSubview:self.linerView2];
    
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.tipsLabel];
    
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(IPHONE6_W(105)));
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(10));
        make.height.width.equalTo(@(44));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.boxView);
        make.centerY.equalTo(self.closeButton);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@(IPHONE6_W(55)));
    }];
    
    [self.linerView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(0.5));
        make.top.equalTo(self.boxView.mas_bottom).offset(IPHONE6_W(50));
    }];
    
    [self.specTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.top.equalTo(self.boxView.mas_bottom);
        make.bottom.equalTo(self.linerView1);
    }];
    
    [self.specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.specTipsLabel);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    
    [self.linerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.right.left.equalTo(self.linerView1);
        make.top.equalTo(self.linerView1.mas_bottom).offset(IPHONE6_W(50));
    }];
    
    [self.priceTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.specTipsLabel);
        make.top.equalTo(self.linerView1.mas_bottom);
        make.bottom.equalTo(self.linerView2);
    }];
    
    [self.increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.specLabel);
        make.centerY.equalTo(self.priceTipsLabel);
        make.height.width.equalTo(@(30));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.increaseBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.increaseBtn);
    }];
    
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.priceLabel);
        make.height.width.equalTo(self.increaseBtn);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.linerView2.mas_bottom).offset(12);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(IPHONE6_W(45)));
        make.left.equalTo(@(IPHONE6_W(15)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-15));
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(15);
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

- (UILabel *)totalPriceLabel{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium16];
        _totalPriceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalPriceLabel;
}

- (UILabel *)specTipsLabel{
    if (!_specTipsLabel) {
        _specTipsLabel = [UILabel lz_labelWithTitle:@"商品规格" color:kTextColor51 font:kFontSizeMedium14];
    }
    return _specTipsLabel;
}

- (UILabel *)priceTipsLabel{
    if (!_priceTipsLabel) {
        _priceTipsLabel = [UILabel lz_labelWithTitle:@"加入货币" color:kTextColor51 font:kFontSizeMedium14];
    }
    return _priceTipsLabel;
}

- (UILabel *)specLabel{
    if (!_specLabel) {
        _specLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium14];
    }
    return _specLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium14];
    }
    return _priceLabel;
}

- (UIButton *)minusBtn{
    if (!_minusBtn) {
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusBtn setImage:kGetImage(@"c11_btn_minus") forState:UIControlStateNormal];
        _minusBtn.tag = 0;
        MV(weakSelf);
        [_minusBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf onClick:weakSelf.minusBtn];
        }];
        
    }
    return _minusBtn;
}

- (UIButton *)increaseBtn{
    if (!_increaseBtn) {
        _increaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_increaseBtn setImage:kGetImage(@"c11_btn_increase") forState:UIControlStateNormal];
        _increaseBtn.tag = 1;
        MV(weakSelf);
        [_increaseBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf onClick:weakSelf.increaseBtn];
        }];
        
    }
    return _increaseBtn;
}

- (UIView *)linerView1{
    if (!_linerView1) {
        _linerView1 = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView1;
}

- (UIView *)linerView2 {
    if (!_linerView2) {
        _linerView2 = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView2;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.tag = 2;
        [_saveButton setTitle:@"下一步" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_saveButton isRadius:YES];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf onClick:self.saveButton];
        }];
    }
    return _saveButton;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor204 font:kFontSizeMedium14];
        _tipsLabel.text = @"最低起投金额3000元,每次追加或减少1000的倍数";
    }
    return _tipsLabel;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:HexString(@"#2DACF7")];
    }
    return _boxView;
}
@end
