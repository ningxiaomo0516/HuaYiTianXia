//
//  TXForgetTradingViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/4.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXForgetTradingViewController.h"
#import "TXRegisteredTableViewCell.h"
#import "TXRegisterTableViewCell.h"
#import "TXResetTradingViewController.h"

static NSString * const reuseIdentifier = @"TXRegisterTableViewCell";
static NSString * const reuseIdentifiers = @"TXRegisteredTableViewCell";

@interface TXForgetTradingViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) IBOutlet UITableViewCell *realnameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *idnumberCell;

@property (strong, nonatomic) IBOutlet UITextField *realnameTextField;
@property (strong, nonatomic) IBOutlet UITextField *idnumberTextField;
/// 验证码
@property (copy, nonatomic) NSString *validationCode;

@end

@implementation TXForgetTradingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}
/** 确认修改密码 */
- (void) saveBtnClick:(UIButton *) sender{
    NSString *realname = self.realnameTextField.text;
    NSString *idnumber = self.idnumberTextField.text;
    if (self.validationCode.length == 0) {
        Toast(@"请输入验证码");
        return;
    }
    
    if (realname.length==0) {
        Toast(@"请输入真实姓名");
    }
    
    if (idnumber.length==0) {
        Toast(@"请输入身份证号");
        return;
    }
    
    if (![SCSmallTools tt_simpleVerifyIdentityCardNum:idnumber]) {
        Toast(@"请输入正确的身份证号码");
        return;
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:realname forKey:@"name"];
    [parameter setObject:idnumber forKey:@"code"];
    [parameter setObject:self.validationCode forKey:@"smsCode"];
    [self validationIdentityInfo:parameter];
}


/**
 *  点击获取验证码
 *
 *  @param sender 当前按钮
 */
- (IBAction)obtainVerificationCode:(id)sender {
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:kUserInfo.account forKey:@"mobile"];
    [parameter setObject:@"1" forKey:@"type"];
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
        kHideMBProgressHUD(self.view);;
        //        [MBProgressHUD hideHUDForView:self.view];
        Toast(@"验证码发送失败");
        TTLog(@"error --- %@",error);
        
    }];
}

/// 验证身份信息和Code验证码
- (void) validationIdentityInfo:(NSMutableDictionary *)parameter{
    kShowMBProgressHUD(self.view);
    [SCHttpTools postWithURLString:kHttpURL(@"customer/ForgetTranPwd") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                Toast(@"身份验证成功");
                TXResetTradingViewController *vc = [[TXResetTradingViewController alloc] init];
                vc.pageType = 0;
                TTPushVC(vc);
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"身份验证失败");
        }
        kHideMBProgressHUD(self.view);;
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        kHideMBProgressHUD(self.view);;
    }];
}

- (void) initView{
    [self addGesture:self.tableView];
    [Utils lz_setExtraCellLineHidden:self.tableView];
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

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TXGeneralModel *model = self.dataArray[indexPath.row];
    if (indexPath.row==0) {
        TXRegisterTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.titleLabel.text = model.title;
        tools.textField.enabled = NO;
        tools.textField.text = model.imageText;
        tools.textField.tag = indexPath.row;
        [tools.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        return tools;
    }else if(indexPath.row==1){
        TXRegisteredTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifiers forIndexPath:indexPath];
        TXGeneralModel *model = self.dataArray[indexPath.row];
        tools.titleLabel.text = model.title;
        tools.textField.placeholder = model.imageText;
        tools.textField.tag = indexPath.row;
        MV(weakSelf)
        [tools.codeBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf obtainVerificationCode:tools.codeBtn];
        }];
        [tools.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        return tools;
    }else if (indexPath.row == 2) {
        _realnameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _realnameCell;
    }else if (indexPath.row == 3) {
        _idnumberCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _idnumberCell;
    }
    return [UITableViewCell new];
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/// 返回多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return IPHONE6_W(55);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/// 现在Code最大输出长度位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag==1) {
        if (range.location + string.length > 4) {
            return NO;
        }
    }
    return YES;
}

#pragma mark ---- UITextFieldDelegate
/// 控制键盘是否回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)textFieldWithText:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
            self.validationCode = textField.text;
            break;
        default:
            break;
    }
}

#pragma mark ----- getter/setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_tableView registerClass:[TXRegisterTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXRegisteredTableViewCell class] forCellReuseIdentifier:reuseIdentifiers];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kClearColor];
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    }
    return _footerView;
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

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@"手机号",@"验证码",@"真实姓名",@"身份证"];
        NSArray* subtitleArr = @[kUserInfo.phone,@"请输入验证码",@"请输入身份证姓名",@"请输入身份证号"];
        for (int i=0; i<titleArr.count; i++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:i];
            generalModel.imageText = [subtitleArr lz_safeObjectAtIndex:i];
            [_dataArray addObject:generalModel];
        }
    }
    return _dataArray;
}

@end
