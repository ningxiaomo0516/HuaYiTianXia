//
//  TXResetTradingViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/4.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXResetTradingViewController.h"
#import "TTPasswordView.h"
#import "TXSetupViewController.h"

@interface TXResetTradingViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;
/// 标题
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *subtitleLabel;
@property (strong, nonatomic) UIButton  *saveButton;
@property (nonatomic, strong) TTPasswordView *passView;
/// 第二次输入的密码
@property (nonatomic, copy) NSString *passwords;
@end

@implementation TXResetTradingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"交易密码";
    [self initView];
    
    CGFloat left = IPHONE6_W(35);
    CGFloat widht = kScreenWidth - left * 2;
    CGFloat height = IPHONE6_W(50);
    _passView = [[TTPasswordView alloc] initWithFrame:CGRectMake(left, IPHONE6_W(185), widht, height)];
    [self.scrollView addSubview:_passView];
    MV(weakSelf)
    _passView.passwordBlock = ^(NSString * _Nonnull passwordText) {
        TTLog(@"text = %@",passwordText);
        if (self.pageType==0) {
            if (passwordText.length==6) {
                [weakSelf.passView clearUpPassword];
                TXResetTradingViewController *vc = [[TXResetTradingViewController alloc] init];
                vc.subtitleLabel.text = @"请再次填写确认。";
                vc.saveButton.hidden = NO;
                vc.password = passwordText;
                vc.pageType = 1;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }else if(self.pageType==1){
            weakSelf.passwords = passwordText;
        }
    };
}

/** 确认修改密码 */
- (void) saveBtnClick:(UIButton *) sender{
    if (self.passwords.length==0) {
        Toast(@"请输入确认密码");
        return;
    }

    if (self.passwords != self.password) {
        Toast(@"两次交易密码不一致");
        return;
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.password forKey:@"tranPwd"];
    [parameter setObject:self.passwords forKey:@"confirmpwd"];
    [SCHttpTools postWithURLString:kHttpURL(@"customer/AddTranPwd") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                kUserInfo.tranPwd = 1;
                [kUserInfo dump];
                /// 返回指定的VC
                [self.navigationController popToRootViewControllerAnimated:YES];
//                for (UIViewController *tempVC in self.navigationController.viewControllers) {
//                    if ([tempVC isKindOfClass:[TXSetupViewController class]]) {
//                        [self.navigationController popToViewController:tempVC animated:YES];
//                    }
//                }
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"交易密码设置失败");
        }
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
    }];
}



- (void) initView{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.subtitleLabel];
    [self.scrollView addSubview:self.saveButton];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(IPHONE6_W(65));
        make.centerX.mas_equalTo(self.view);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(IPHONE6_W(25));
        make.centerX.mas_equalTo(self.view);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(150);
        make.left.equalTo(@(15));
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(45));
    }];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-kNavBarHeight+1);
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _scrollView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium27];
        _titleLabel.text = @"设置交易密码";
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        _subtitleLabel.text = @"请设置交易密码，用于交易严重。";
    }
    return _subtitleLabel;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kFontSizeMedium15;
        [_saveButton setTitle:@"完成" forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:kGetImage(@"c31_denglu") forState:UIControlStateNormal];
        _saveButton.hidden = YES;
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf saveBtnClick:self.saveButton];
        }];
    }
    return _saveButton;
}

@end
