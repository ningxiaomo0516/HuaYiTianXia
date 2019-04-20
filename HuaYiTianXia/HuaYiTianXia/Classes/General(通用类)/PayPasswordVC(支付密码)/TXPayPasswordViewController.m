//
//  TXPayPasswordViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/9.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPayPasswordViewController.h"
#import "TTPasswordView.h"

@interface TXPayPasswordViewController ()
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 资产
@property (nonatomic, strong) UILabel *assetsLabel;
/// 积分
@property (nonatomic, strong) UILabel *integralLabel;
/// 分割线
@property (nonatomic, strong) UIView *linerView;
/// 分割线2
@property (nonatomic, strong) UIView *linerView2;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) TTPasswordView *passView;
@property (nonatomic, copy) NSString *passwordText;
@end

@implementation TXPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(AUTOLAYOUTSIZE((kScreenWidth - 280)/2), 0, AUTOLAYOUTSIZE(280), AUTOLAYOUTSIZE(230));
    [self initView];
    [self.view lz_setCornerRadius:7.0];
    CGFloat left = IPHONE6_W(17);
    CGFloat widht = IPHONE6_W(280) - left * 2;
    CGFloat height = IPHONE6_W(42);
    [_passView lz_setCornerRadius:3.0];
    _passView = [[TTPasswordView alloc] initWithFrame:CGRectMake(left, IPHONE6_W(170), widht, height)];
    [self.view addSubview:_passView];
    MV(weakSelf)
    _passView.passwordBlock = ^(NSString * _Nonnull passwordText) {
        TTLog(@"text = %@",passwordText);
        weakSelf.passwordText = passwordText;
        if (passwordText.length==6) {
            [weakSelf validationTransactionPassword];
            [weakSelf.passView clearUpPassword];
        }
    };
    
    /// 富文本设置字体大小
    NSString *currentText = kStringFormat(self.integralText,self.tipsText);
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:currentText];
    NSInteger length = self.tipsText.length;
    // 后面文字大小
    [attributedStr addAttribute:NSFontAttributeName
                          value:kFontSizeMedium16
                          range:NSMakeRange(currentText.length-length, length)];
    
    self.integralLabel.attributedText = attributedStr;
}

// 去报名按钮
- (void)dismissedPopupView:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissedButtonClicked)]) {
        [self.delegate dismissedButtonClicked];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.height = IPHONE6_W(230);
    self.view.width = IPHONE6_W(280);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/// 验证交易密码
- (void) validationTransactionPassword{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.passwordText forKey:@"tranPwd"];
    [SCHttpTools postWithURLString:kHttpURL(@"customer/TranPwdVerif") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                [self sc_dismissVC];
                TTLog(@"self.pageType -- %ld",self.pageType);
                if (self.pageType == 0 ) {  //// 转出
                    [kNotificationCenter postNotificationName:@"transferRequest" object:nil];
                }else if (self.pageType == 1 ) { //// 复投
                    [kNotificationCenter postNotificationName:@"repeatcCastRequest" object:nil];
                }else if (self.pageType == 2 ) { /// 转换
                    [kNotificationCenter postNotificationName:@"conversionRequest" object:nil];
                }else if(self.pageType == 3 ){ /// 商城余额购买
                    [kNotificationCenter postNotificationName:@"mallBalanceRequest" object:nil];
                }else if(self.pageType == 4 ){ /// 新增机票购买
                    [kNotificationCenter postNotificationName:@"buyTicketRequest" object:nil];
                }else{
                    Toast(@"未知页面");
                }
            }else{
                Toast(@"密码错误");
            }
        }
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
    }];
}

- (void) initView{
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.assetsLabel];
    [self.view addSubview:self.integralLabel];
    [self.view addSubview:self.linerView];
    [self.view addSubview:self.linerView2];
    
    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(0.5));
        make.top.equalTo(@(50));
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.width.equalTo(@(50));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.linerView.mas_top);
    }];
    
    [self.assetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(18);
    }];
    
    [self.integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.assetsLabel.mas_bottom);
    }];
    
    [self.linerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.linerView);
        make.top.equalTo(@(150));
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"请输入支付密码" color:kTextColor102 font:kFontSizeMedium17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)assetsLabel{
    if (!_assetsLabel) {
        _assetsLabel = [UILabel lz_labelWithTitle:@"资产金额" color:kTextColor51 font:kFontSizeMedium16];
    }
    return _assetsLabel;
}

- (UILabel *)integralLabel{
    if (!_integralLabel) {
        _integralLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium34];
    }
    return _integralLabel;
}

- (UIView *)linerView{
    if (!_linerView) {
        _linerView = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView;
}

- (UIView *)linerView2{
    if (!_linerView2) {
        _linerView2 = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView2;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:kGetImage(@"c12_btn_close") forState:UIControlStateNormal];
        MV(weakSelf);
        [_closeButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf dismissedPopupView:weakSelf.closeButton];
        }];
    }
    return _closeButton;
}

@end
