//
//  TXConventionSucceViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/15.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXConventionSucceViewController.h"

@interface TXConventionSucceViewController ()
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imagesView;
@property (nonatomic, strong) UILabel *subtitleLabel;
@end

@implementation TXConventionSucceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view lz_setCornerRadius:5.0];
    [self initView];
    [self.closeButton lz_setCornerRadius:5.0];
    self.subtitleLabel.text = @"    感谢您的预约（购买），我们将稍后与您联系，进一步沟通订单详情，请保持电话畅通。";
}

- (void) initView{
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.imagesView];
    [self.view addSubview:self.subtitleLabel];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(41));
        make.left.equalTo(@(15));
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-25);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(30));
        make.top.equalTo(@(10));
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.imagesView.mas_bottom).offset(20);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"重要提示" color:kTextColor102 font:kFontSizeMedium17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _closeButton.titleLabel.font = kFontSizeMedium15;
        [_closeButton setTitle:@"好的" forState:UIControlStateNormal];
        [_closeButton setBackgroundImage:imageHexString(@"#FF4163") forState:UIControlStateNormal];
        MV(weakSelf);
        [_closeButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf sc_dismissVC];
        }];
    }
    return _closeButton;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.image = kGetImage(@"live_btn_客服");
    }
    return _imagesView;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
    }
    return _subtitleLabel;
}
@end
