//
//  TXLoginViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXLoginViewController.h"
#import "TXRegisteredViewController.h"
#import "TTUserModel.h"
#import "TXWebViewController.h"

@interface TXLoginViewController ()
@property (nonatomic, strong) IBOutlet UIButton *registerBtn;
@property (nonatomic, strong) IBOutlet UIButton *forgetBtn;
@property (nonatomic, strong) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) IBOutlet UITextField *telTextField;
@property (nonatomic, strong) IBOutlet UITextField *pwdTextField;
/// 用户协议点击
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;
@end

@implementation TXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    [self initView];
    [self.registerBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        TXRegisteredViewController *vc = [[TXRegisteredViewController alloc] init];
        vc.title = @"注册";
        vc.pageType=0;
        TTPushVC(vc);
    }];
    MV(weakSelf)
    [self.loginBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self tapGesture];
        [weakSelf loginBtnClick:weakSelf.loginBtn];
    }];
    
    [self.forgetBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self tapGesture];
        TXRegisteredViewController *vc = [[TXRegisteredViewController alloc] init];
        vc.title = @"找回密码";
        vc.pageType = 1;                                                                                
        TTPushVC(vc);
    }];
    
    [self.protocolButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
       TXWebViewController *vc = [[TXWebViewController alloc] init];
        vc.title = @"华翼天下服务协议";
        vc.webUrl = kAppendH5URL(DomainName, UserAgreeH5,@"");
        TTPushVC(vc);
    }];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"all_btn_close_grey")
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(didTapPopButton:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void) initView{
    [Utils lz_setButtonWithBGImage:self.loginBtn cornerRadius:self.loginBtn.height/2.0];
    [self.registerBtn setBackgroundImage:imageColor(kClearColor) forState:UIControlStateNormal];
    [self.registerBtn setBorderColor:kThemeColorHex];
    [self.registerBtn lz_setCornerRadius:self.registerBtn.height/2.0];
    [self.registerBtn setTitleColor:kThemeColorHex forState:UIControlStateNormal];
    [self.forgetBtn setTitleColor:kThemeColorHex forState:UIControlStateNormal];
}

- (void) loginBtnClick:(UIButton *)sender{
    
    if (self.telTextField.text.length == 0) {
        Toast(@"请输入电话号码");
        return;
    }
    
    if (![SCSmallTools checkTelNumber:self.telTextField.text]) {
        Toast(@"请输入正确的电话号码");
        return;
    }
    if (self.pwdTextField.text.length == 0) {
        Toast(@"请输入登录密码");
        return;
    }
    
    NSString *registerid = [kUserDefaults objectForKey:@"registerid"];
    kShowMBProgressHUD(self.view);
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.telTextField.text forKey:@"mobile"];
    [parameter setObject:self.pwdTextField.text forKey:@"pwd"];
    [parameter setObject:registerid forKey:@"jg_deviceID"];
    
    [SCHttpTools postWithURLString:@"customer/login" parameter:parameter success:^(id responseObject) {
        if (responseObject){
            id result = responseObject;
            if (result) {
                TTUserDataModel *model = [TTUserDataModel mj_objectWithKeyValues:result];
                if (model.errorcode == 20000) {
                    TTLog(@"登录成功过数据集 -- %@",[Utils lz_dataWithJSONObject:[result lz_objectForKey:@"obj"]]);
                    TTUserModel *userModel = [TTUserModel shared];
                    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                    NSDictionary *dataDic = [result lz_objectForKey:@"obj"];
                    NSArray *dictKeysArray = [[result lz_objectForKey:@"obj"] allKeys];
                    [dictionary setObject:model.data.userid forKey:@"userid"];
                    [dictionary setObject:model.data.account forKey:@"account"];
                    [dictionary setObject:model.data.username forKey:@"username"];
                    [dictionary setObject:model.data.realname forKey:@"realname"];
                    [dictionary setObject:model.data.avatar forKey:@"avatar"];
                    [dictionary setObject:model.data.registertime forKey:@"registertime"];
                    [dictionary setObject:model.data.idnumber forKey:@"idnumber"];
                    [dictionary setObject:model.data.totalAssets forKey:@"totalAssets"];
                    [dictionary setObject:@(model.data.isValidation) forKey:@"isValidation"];
                    for (int i = 0; i<dictKeysArray.count; i++) {
                        NSString *key = dictKeysArray[i];
                        NSString *obj = [dataDic objectForKey:key];
                        NSArray *keyArray = @[@"id",@"mobile",@"nickName",@"name",@"headImg",@"time",@"code",@"assets",@"type"];
                        for (NSString *keyArrStr in keyArray) {
                            if ([key isEqualToString:keyArrStr]) {
                                break ;
                            }else{
                                [dictionary setObject:obj forKey:key];
                            }
                        }
                    }
                    [userModel yy_modelSetWithDictionary:dictionary];
                    [userModel dump];
                    [kNotificationCenter postNotificationName:@"reloadMineData" object:nil];
                    [self didTapPopButton:nil];
                    Toast(@"登录成功");
                }else{
                    Toast(model.message);
                }
            }
        }
        kHideMBProgressHUD(self.view);
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
        kHideMBProgressHUD(self.view);
    }];
}

- (void)didTapPopButton:(UIBarButtonItem *)barButtonItem {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kWhiteColor;
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
