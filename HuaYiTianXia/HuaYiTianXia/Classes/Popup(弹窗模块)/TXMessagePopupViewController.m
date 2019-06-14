//
//  TXMessagePopupViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/13.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMessagePopupViewController.h"

@interface TXMessagePopupViewController ()
@end

@implementation TXMessagePopupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self.view lz_setCornerRadius:5.0];
//    self.contentLable.text = @"尊敬的会员，您属于西南地区请进入西南地区购买。";
    [self.cancelButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self sc_dismissVC];
    }];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void) initView{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.contentLable];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.enterButton];
    
    CGFloat margin = IPHONE6_W(15);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(IPHONE6_W(55)));
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(margin));
        make.bottom.equalTo(self.view.mas_bottom).offset(-margin);
        make.width.equalTo(self.enterButton);
        make.height.equalTo(@(IPHONE6_W(45)));
        make.right.equalTo(self.enterButton.mas_left).offset(IPHONE6_W(-10));
    }];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-margin);
        make.height.centerY.equalTo(self.cancelButton);
    }];
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(margin));
        make.right.equalTo(self.enterButton);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(-margin);
        make.bottom.equalTo(self.enterButton.mas_top);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"提示"
                                           color:kTextColor51
                                            font:kFontSizeMedium17
                                       alignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UILabel *)contentLable{
    if (!_contentLable) {
        _contentLable = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium15];
    }
    return _contentLable;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton lz_setCornerRadius:5.0];
        _cancelButton.titleLabel.font = kFontSizeMedium15;
        [_cancelButton setTitleColor:kThemeColorRGB  forState:UIControlStateNormal];
        [_cancelButton setBorderColor:kThemeColorRGB];
        [_cancelButton setBorderWidth:1.0];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIButton *)enterButton{
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"立即前往" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_enterButton isRadius:YES];
    }
    return _enterButton;
}
@end
