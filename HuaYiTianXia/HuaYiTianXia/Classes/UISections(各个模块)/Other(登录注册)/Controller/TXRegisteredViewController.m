//
//  TXRegisteredViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXRegisteredViewController.h"
#import "TXRegisteredTableViewCell.h"
#import "TXRegisterTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXRegisterPasswordViewController.h"

static NSString * const reuseIdentifier = @"TXRegisterTableViewCell";
static NSString * const reuseIdentifiers = @"TXRegisteredTableViewCell";

@interface TXRegisteredViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UILabel *titlelabel;
/// 手机号
@property (copy, nonatomic) NSString *telphone;
/// 验证码
@property (copy, nonatomic) NSString *validationCode;
/// 密码
@property (copy, nonatomic) NSString *password;
/// 确认密码
@property (copy, nonatomic) NSString *passwords;
/// 邀请码
@property (copy, nonatomic) NSString *invitationCode;

@end

@implementation TXRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addGesture:self.tableView];
    [self initView];
    [self getIntegral];
    self.invitationCode = @"";
}

- (void) initView{
    [self.view addSubview:self.tableView];
    [self.footerView addSubview:self.saveButton];
    self.tableView.tableFooterView = self.footerView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(30));
        make.left.equalTo(@(IPHONE6_W(15)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-15));
        make.height.equalTo(@(45));
    }];
    
    if (self.pageType==0) {
        [self.footerView addSubview:self.titlelabel];
        [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.saveButton.mas_bottom).offset(16);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kWhiteColor;
}

/// 获取注册成功即送298VH
- (void) getIntegral{
    [SCHttpTools getWithURLString:@"upload/regVHIntegral" parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXGeneralModel *generalModel = [TXGeneralModel mj_objectWithKeyValues:result];
        if (generalModel.errorcode==20000) {
            NSAttributedString *attributedText;
            attributedText = [SCSmallTools sc_initImageWithText:generalModel.obj
                                                      imageName:@"live_btn_marks"
                                                   fontWithSize:kFontSizeMedium15];
            self.titlelabel.attributedText = attributedText;
        }else{
            Toast(generalModel.message);
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    /// 0:注册 1:找回密码
    if (self.telphone.length == 0) {
        Toast(@"请输入电话号码");
        return;
    }
    if (![SCSmallTools checkTelNumber:self.telphone]) {
        Toast(@"请输入正确的电话号码");
        return;
    }
    
    if (self.validationCode.length == 0) {
        Toast(@"请输入验证码");
        return;
    }

    if (self.pageType==0) {
        if (self.password.length == 0) {
            Toast(@"请输入登录密码");
            return;
        }
        if (self.password.length < 6) {
            Toast(@"登录密码不能少于6位");
            return;
        }
        if (self.passwords.length == 0) {
            Toast(@"请输入确认密码");
            return;
        }
        if (self.passwords != self.password) {
            Toast(@"确认密码与密码不一致");
            return;
        }
        if (self.invitationCode.length==0) {
            Toast(@"请填写邀请码");
            return;
        }
    }
    
    kShowMBProgressHUD(self.view);
    /// 先校验验证码再修改密码
    if (self.pageType==0) {
        [self checkCodeisCorrect:@"customer/SMSContrast"];
    }else if(self.pageType==1){
        [self checkCodeisCorrect:@"customer/FindPwdSMS"];
    }
}

/// 设置密码
- (void) setupPasswordRequest:(NSString *)URLString parameter:(NSDictionary *)parameter{
    [SCHttpTools postWithURLString:URLString parameter:parameter success:^(id responseObject) {
        if (responseObject){
            NSDictionary *result = responseObject;
            TXGeneralModel *generalModel = [TXGeneralModel mj_objectWithKeyValues:result];
            if (generalModel.errorcode == 20000) {
                if (self.pageType==0) {
                    TTLog(@"密码设置成功");
                }else if(self.pageType==1){
                    TTLog(@"新密码密码设置成功");
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            Toast(generalModel.message);
        }
        kHideMBProgressHUD(self.view);;
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
        kHideMBProgressHUD(self.view);;
    }];
}

- (void) checkCodeisCorrect:(NSString *)URLString{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.telphone forKey:@"mobile"];
    [parameter setObject:self.validationCode forKey:@"smsCode"];
    [SCHttpTools postWithURLString:URLString parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXGeneralModel *generalModel = [TXGeneralModel mj_objectWithKeyValues:result];
        if (generalModel.errorcode == 20000) {
            if (self.pageType==0) {
                NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
                [parameter setObject:self.telphone forKey:@"mobile"];
                [parameter setObject:self.password forKey:@"pwd"];
                [parameter setObject:self.passwords forKey:@"confirmpwd"];
                if (self.invitationCode.length !=0) {
                    [parameter setObject:self.invitationCode forKey:@"inviteCode"];
                }
                [self setupPasswordRequest:@"customer/register" parameter:parameter];
            }else{
                TXRegisterPasswordViewController *vc = [[TXRegisterPasswordViewController alloc] init];
                vc.pageType = self.pageType;
                vc.telphone = self.telphone;
                vc.title = @"设置密码";
                TTPushVC(vc);
            }
        }else{
            Toast(generalModel.message);
        }
        kHideMBProgressHUD(self.view);
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
        kHideMBProgressHUD(self.view);
    }];
}

/**
 *  点击获取验证码
 *
 *  @param sender 当前按钮
 */
- (IBAction)obtainVerificationCode:(id)sender {
    if (self.telphone.length == 0) {
        Toast(@"请输入电话号码");
        return;
    }
    if (![SCSmallTools checkTelNumber:self.telphone]) {
        Toast(@"请输入正确的电话号码");
        return;
    }
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.telphone forKey:@"mobile"];
    /// 0:注册 1:找回密码
    if (self.pageType==0) {
        [parameter setObject:@"0" forKey:@"type"];
    }else{
        [parameter setObject:@"1" forKey:@"type"];
    }
    kShowMBProgressHUD(self.view);
    [SCHttpTools postWithURLString:@"customer/sendSMS" parameter:parameter success:^(id responseObject) {
        if (responseObject){
            id result = responseObject;
            TXGeneralModel *generalModel = [TXGeneralModel mj_objectWithKeyValues:result];
            if (generalModel.errorcode == 20000) {
                Toast(@"验证码已发送至您的手机,请注意查收!");
                [SCSmallTools countdown:sender];
            }else{
                Toast(generalModel.message);
            }
        }
        kHideMBProgressHUD(self.view);;
    } failure:^(NSError *error) {
        Toast(@"验证码发送失败");
        TTLog(@"error --- %@",error);
        kHideMBProgressHUD(self.view);;
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TXGeneralModel *model = self.dataArray[indexPath.row];
    if (indexPath.row==1) {
        TXRegisteredTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifiers forIndexPath:indexPath];
        TXGeneralModel *model = self.dataArray[indexPath.row];
        tools.titleLabel.text = model.title;
        tools.textField.placeholder = model.imageText;
        tools.textField.tag = indexPath.row;
        tools.codeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        MV(weakSelf)
        [tools.codeBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf obtainVerificationCode:tools.codeBtn];
        }];
        [tools.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        return tools;
    }else{
        TXRegisterTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.titleLabel.text = model.title;
        tools.textField.placeholder = model.imageText;
        tools.textField.tag = indexPath.row;
        if (indexPath.row==2||indexPath.row==3) {
            tools.textField.secureTextEntry = YES;
        }
        [tools.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        return tools;
    }
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /// 0:注册 1:找回密码
    if (self.pageType==0) {
        return self.dataArray.count;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return IPHONE6_W(55);
}

//// 现在code最大长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag==1) {
        if (range.location + string.length > 4) {
            return NO;
        }
    }
    return YES;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TXRegisterTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXRegisteredTableViewCell class] forCellReuseIdentifier:reuseIdentifiers];
        // 拖动tableView时收起键盘
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
    }
    return _tableView;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"下一步" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_saveButton isRadius:YES];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf saveBtnClick:self.saveButton];
        }];
    }
    return _saveButton;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kClearColor];
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    }
    return _footerView;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"" color:kThemeColorRGB font:kFontSizeMedium15];
    }
    return _titlelabel;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@"手机号",@"验证码",@"密码",@"确认密码",@"邀请码"];
        NSArray* classArr = @[@"请输入手机号码",@"请输入验证码",@"请输入登录密码",@"请再次输入密码",@"邀请码（必填）"];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:j];
            generalModel.imageText = [classArr lz_safeObjectAtIndex:j];
            [_dataArray addObject:generalModel];
        }
    }
    return _dataArray;
}

- (void)textFieldWithText:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
            self.telphone = textField.text;
            break;
        case 1:
            self.validationCode = textField.text;
            break;
        case 2:
            self.password = textField.text;
            break;
        case 3:
            self.passwords = textField.text;
            break;
        case 4:
            self.invitationCode = textField.text;
            break;
        default:
            break;
    }
}
@end
