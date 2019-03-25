//
//  TXLoginViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXLoginViewController.h"
#import "TXRegisteredViewController.h"

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
    [self.registerBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        TXRegisteredViewController *vc = [[TXRegisteredViewController alloc] init];
        vc.title = @"注册";
        vc.pageType=0;
        TTPushVC(vc);
    }];
    
    [self.loginBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.forgetBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        TXRegisteredViewController *vc = [[TXRegisteredViewController alloc] init];
        vc.title = @"找回密码";
        vc.pageType = 1;                                                                                
        TTPushVC(vc);
    }];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"all_btn_close_grey")
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(didTapPopButton:)];
    self.navigationItem.leftBarButtonItem = leftItem;
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
