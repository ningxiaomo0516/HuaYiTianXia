//
//  TXPayOrderViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/12.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPayOrderViewController.h"
#import "SCCustomMarginLabel.h"
#import "TXPayOrderVC.h"
#import "TXWebViewController.h"
#import "TXChoosePayViewController.h"

@interface TXPayOrderViewController ()
/// 关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
/// 价格
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
/// 规格
@property (weak, nonatomic) IBOutlet UILabel *specLabel;
/// 累加金额
@property (weak, nonatomic) IBOutlet SCCustomMarginLabel *priceLabel;
/// 减少按钮
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
/// 增加按钮
@property (weak, nonatomic) IBOutlet UIButton *increaseBtn;
/// 提交按钮
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
/// 勾选按钮
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
/// 协议按钮
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;
/// 产品Model
@property (strong, nonatomic)  NewsRecordsModel *model;
@end

@implementation TXPayOrderViewController
- (id) initNewsRecordsModel:(NewsRecordsModel *)model{
    if ( self = [super init] ){
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.priceLabel.edgeInsets    = UIEdgeInsetsMake(0.f, 20.f, 0.f, 20.f); // 设置左内边距
    if (self.model.prospec.count>0) {
        self.specLabel.text = self.model.prospec[0];
    }else{
        self.specLabel.text = @"";
    }
    
    
    // 注册通知(支付成功之后的处理)
    [kNotificationCenter addObserver:self selector:@selector(AlipaySuccessfulBlock) name:@"AlipaySuccessful" object:nil];
}

- (void)AlipaySuccessfulBlock{
    [self sc_dismissVC];
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController.tabBarController setSelectedIndex:4];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kWhiteColor;
}

/**
 *  点击关闭按钮
 *
 *  @param sender 当前按钮
 */
- (IBAction)closelBtnClick:(id)sender {
    [self sc_dismissVC];
}

/**
 *  是否同意协议
 *
 @param sender 协议按钮
 */
- (IBAction)agreeProtocolButtonClick:(id)sender {
    self.checkButton.selected = !self.checkButton.selected;
}

/**
 *  点击协议按钮
 *
 *  @param sender 当前按钮
 */
- (IBAction)protocolBtnClick:(id)sender {
    TXWebViewController *vc = [[TXWebViewController alloc] init];
    vc.title = @"农保电子协议";
    vc.webUrl = kAppendH5URL(DomainName, NBElectronicAgreementH5,@"");
    LZNavigationController *navigation = [[LZNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navigation animated:YES completion:^{
        TTLog(@"个人信息修改");
    }];

}

/**
 *  点击增加按钮
 *
 *  @param sender 当前按钮
 */
- (IBAction)increaseBtnClick:(id)sender {
    NSInteger price = [self.priceLabel.text integerValue];
    NSInteger i = 3000*1000;
    NSInteger total = price + i;
    self.priceLabel.text = [NSString stringWithFormat:@"%ld",total];
}

/**
 *  点击减少按钮
 *
 *  @param sender 当前按钮
 */
- (IBAction)minusBtnClick:(id)sender {
    NSInteger price = [self.priceLabel.text integerValue];
    NSInteger i = 3000*1000;
    if (price<=3000) {
        Toast(@"已是最低投保金额");
        return;
    }else{
        NSInteger total = price - i;
        self.priceLabel.text = [NSString stringWithFormat:@"%ld",total];
    }
}

/**
 *  点击提交按钮
 *
 *  @param sender 当前按钮
 */
- (IBAction)saveBtnClick:(id)sender {
    self.model.price = self.priceLabel.text;
//    [self sc_dismissVC];
    int64_t delayInSeconds = 0.5;      // 延迟的时间
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.model.purchaseType = 2;
        TXChoosePayViewController *vc = [[TXChoosePayViewController alloc]initNewsRecordsModel:self.model];
        [self sc_bottomPresentController:vc presentedHeight:IPHONE6_W(400) completeHandle:^(BOOL presented) {

        }];
    });
}

- (void)dealloc{
    [kNotificationCenter removeObserver:self];
}

@end
