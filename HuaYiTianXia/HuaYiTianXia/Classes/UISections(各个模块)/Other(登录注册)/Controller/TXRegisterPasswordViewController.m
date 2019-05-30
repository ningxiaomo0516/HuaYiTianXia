//
//  TXRegisterPasswordViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXRegisterPasswordViewController.h"
#import "TXRegisteredTableViewCell.h"
#import "TXRegisterTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXRegisterPasswordViewController.h"

static NSString * const reuseIdentifier = @"TXRegisterTableViewCell";
static NSString * const reuseIdentifiers = @"TXRegisteredTableViewCell";

@interface TXRegisterPasswordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) NSMutableArray *dataArray;
/// 密码
@property (copy, nonatomic) NSString *password;
/// 确认密码
@property (copy, nonatomic) NSString *passwords;
/// 邀请码
@property (copy, nonatomic) NSString *invitationCode;

@end

@implementation TXRegisterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addGesture:self.tableView];
    [self initView];
    self.invitationCode = @"";
}

- (void) initView{
    [self.view addSubview:self.tableView];
    NSInteger count = self.lz_navigationController.lz_viewControllers.count;
    TTLog(@"count = %ld",count);
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
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kWhiteColor;
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
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
    
    kShowMBProgressHUD(self.view);
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.telphone forKey:@"mobile"];
    [parameter setObject:self.password forKey:@"pwd"];
    [parameter setObject:self.passwords forKey:@"confirmpwd"];
    if (self.pageType==0) {
        [parameter setObject:self.invitationCode forKey:@"inviteCode"];
        [self setupPasswordRequest:@"customer/register" parameter:parameter];
    }else{
        [self setupPasswordRequest:@"customer/FindPwd" parameter:parameter];
    }
}

- (void) updatePasswordRequest{
    
}

/// 设置密码
- (void) setupPasswordRequest:(NSString *)URLString parameter:(NSDictionary *)parameter{
    [SCHttpTools postWithURLString:URLString parameter:parameter success:^(id responseObject) {
        if (responseObject){
            id result = responseObject;
            if (result) {
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
        }
        kHideMBProgressHUD(self.view);;
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
        kHideMBProgressHUD(self.view);;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TXGeneralModel *model = self.dataArray[indexPath.row];
    TXRegisterTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.titleLabel.text = model.title;
    tools.textField.placeholder = model.imageText;
    tools.textField.tag = indexPath.row;
    if (indexPath.row != 2) {
        tools.textField.secureTextEntry = YES;
        tools.textField.keyboardType = UIKeyboardTypeDefault;
    }
    [tools.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    return tools;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.pageType==0)?self.dataArray.count:2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return IPHONE6_W(55);
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
        [_saveButton setTitle:@"完成" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_saveButton cornerRadius:45/2.0];
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
        
        NSArray* titleArr = @[@"密码",@"确认密码",@"邀请码"];
        NSArray* classArr = @[@"请输入登录密码",@"请再次输入密码",@"邀请码（选填）"];
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
            self.password = textField.text;
            break;
        case 1:
            self.passwords = textField.text;
            break;
        case 2:
            self.invitationCode = textField.text;
            break;
        default:
            break;
    }
}

@end
