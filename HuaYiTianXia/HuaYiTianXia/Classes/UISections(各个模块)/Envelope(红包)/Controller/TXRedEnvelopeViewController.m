//
//  TXRedEnvelopeViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/12.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXRedEnvelopeViewController.h"

@interface TXRedEnvelopeViewController ()
@property (nonatomic, strong) UIImageView   *imagesView;
@property (nonatomic, strong) UIButton      *closeBtn;
@property (nonatomic, strong) UIImageView   *imagesTitle;
@property (nonatomic, strong) UIButton      *linqunBtn;
@property (nonatomic, strong) UILabel       *titlelabel;

@end

@implementation TXRedEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.titlelabel.text = @"5-50VH";
    [self.closeBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self sc_dismissVC];
    }];
    [self.linqunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}

- (void) initView{
    self.view.backgroundColor = [kBlackColor colorWithAlphaComponent:0.4];
    [self.view addSubview:self.imagesView];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.imagesTitle];
    [self.view addSubview:self.titlelabel];
    [self.view addSubview:self.linqunBtn];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(8)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-37));
        make.centerY.equalTo(self.view).offset(-30);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right);
        make.bottom.equalTo(self.imagesView.mas_top).offset(-7);
    }];
    [self.imagesTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imagesView).offset(15);
        make.top.equalTo(self.imagesView.mas_top).offset(99);
    }];
    [self.linqunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imagesView).offset(10);
        make.bottom.equalTo(self.imagesView.mas_bottom).offset(-112);
    }];
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imagesTitle);
        make.top.equalTo(self.imagesTitle.mas_bottom).offset(3);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.image = kGetImage(@"红包背景");
    }
    return _imagesView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:kGetImage(@"live_close_envelope") forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UIButton *)linqunBtn{
    if (!_linqunBtn) {
        _linqunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_linqunBtn setImage:kGetImage(@"live_btn_envelope") forState:UIControlStateNormal];
    }
    return _linqunBtn;
}

- (UIImageView *)imagesTitle{
    if (!_imagesTitle) {
        _imagesTitle = [[UIImageView alloc] init];
        _imagesTitle.image = kGetImage(@"每日领取");
    }
    return _imagesTitle;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"" color:kColorWithRGB(241, 48, 30) font:kFontSizeMedium24];
    }
    return _titlelabel;
}
@end
