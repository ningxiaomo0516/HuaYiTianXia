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
/// 手机号
@property (copy, nonatomic) NSString *telphone;
/// 验证码
@property (copy, nonatomic) NSString *validationCode;

@end

@implementation TXRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addGesture:self.tableView];
    [self initView];
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
        make.left.equalTo(@(15));
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(45));
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kWhiteColor;
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
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
        [self checkCodeisCorrect:@"customer/SMSContrast"];
    }else if(self.pageType==1){
        [self checkCodeisCorrect:@"customer/FindPwdSMS"];
    }
}

- (void) checkCodeisCorrect:(NSString *)URLString{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.telphone forKey:@"mobile"];
    [parameter setObject:self.validationCode forKey:@"smsCode"];
    [SCHttpTools postWithURLString:URLString parameter:parameter success:^(id responseObject) {
        if (responseObject){
            id result = responseObject;
            if (result) {
//                [MBProgressHUD hideHUDForView:self.view];
                TXGeneralModel *generalModel = [TXGeneralModel mj_objectWithKeyValues:result];
                if (generalModel.errorcode == 20000) {
                    TXRegisterPasswordViewController *vc = [[TXRegisterPasswordViewController alloc] init];
                    vc.pageType = self.pageType;
                    vc.telphone = self.telphone;
                    if (self.pageType==0) {
                        vc.title = @"设置密码";
                    }else{
                        vc.title = @"设置密码";
                    }
                    TTPushVC(vc);
                }else{
                    Toast(generalModel.message);
                }
            }
        }
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
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
    if (self.pageType==0) {
        [parameter setObject:@"0" forKey:@"type"];
    }else{
        [parameter setObject:@"1" forKey:@"type"];
    }
//    [MBProgressHUD showMessage:@"" toView:self.view];
    kShowMBProgressHUD(self.view);
    [SCHttpTools postWithURLString:@"customer/sendSMS" parameter:parameter success:^(id responseObject) {
        if (responseObject){
            id result = responseObject;
            if (result) {
//                [MBProgressHUD hideHUDForView:self.view];
                TXGeneralModel *generalModel = [TXGeneralModel mj_objectWithKeyValues:result];
                if (generalModel.errorcode == 20000) {
                    Toast(@"验证码已发送至您的手机,请注意查收!");
                    [SCSmallTools countdown:sender];
                }else{
                    Toast(generalModel.message);
                }
            }
        }
        kHideMBProgressHUD(self.view);;
    } failure:^(NSError *error) {
        
//        [MBProgressHUD hideHUDForView:self.view];
        Toast(@"验证码发送失败");
        TTLog(@"error --- %@",error);
        kHideMBProgressHUD(self.view);;
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TXGeneralModel *model = self.dataArray[indexPath.row];
    if (indexPath.row==0) {
        TXRegisterTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.titleLabel.text = model.title;
        tools.textField.placeholder = model.imageText;
        tools.textField.tag = indexPath.row;
        [tools.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        return tools;
    }else{
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
    }
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
        _tableView.backgroundColor = kClearColor;
    }
    return _tableView;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kFontSizeMedium15;
        [_saveButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:kGetImage(@"c31_denglu") forState:UIControlStateNormal];
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

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
        NSArray* titleArr = @[@"手机号",@"验证码"];
        NSArray* classArr = @[@"请输入手机号码",@"请输入验证码"];
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
        default:
            break;
    }
}
@end
