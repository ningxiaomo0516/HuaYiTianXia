//
//  TXPayNBViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/14.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXPayNBViewController.h"
#import "TXShoppingTableViewCell.h"
#import "TXPurchaseQuantityTableViewCell.h"
#import "TXMessageChildTableViewCell.h"
#import "TXSwitchTableViewCell.h"
#import "TXChoosePayTableViewCell.h"
#import "TXPurchaseAgreementViewController.h"
#import "TXWebViewController.h"
#import "AlipayManager.h"

static NSString * const reuseIdentifierShopping = @"TXShoppingTableViewCell";
static NSString * const reuseIdentifierChoosePay = @"TXChoosePayTableViewCell";
static NSString * const reuseIdentifierPurchase = @"TXPurchaseQuantityTableViewCell";
static NSString * const reuseIdentifierMessage = @"TXMessageChildTableViewCell";
static NSString * const reuseIdentifierSwitch = @"TXSwitchTableViewCell";
@interface TXPayNBViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 底部视图
@property (nonatomic, strong) UIView        *footerView;
/// 提交按钮
@property (nonatomic, strong) UIButton      *submitButton;
/// 总金额
@property (nonatomic, strong) UILabel       *totalAmountLabel;
/// 付款方式数组
@property (nonatomic, strong) NSMutableArray *paymentArray;
/// 产品Model
@property (nonatomic, strong) NewsRecordsModel *model;
/// 记录当前是否有选择支付方式
@property (nonatomic, assign) BOOL isSelected;
/// 0:支付宝 1:微信支付 2:余额支付
@property (nonatomic, assign) NSInteger payType;
@end

@implementation TXPayNBViewController
- (instancetype) initNewsRecordsModel:(NewsRecordsModel *)model{
    if ( self = [super init] ){
        self.model = model;
        NSString *text = @"合计:";
        NSString *amountText;
        if (self.model.vrcurrency.integerValue>kUserInfo.vrcurrency.integerValue) {
            amountText = [NSString stringWithFormat:@"%@￥%@",text,model.price];
        }else{
            amountText = [NSString stringWithFormat:@"%@￥%@",text,model.nowprice];
        }
        
        NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:amountText];
        /// 前面文字颜色
        [mutableAttr addAttribute:NSForegroundColorAttributeName
                            value:kTextColor51
                            range:NSMakeRange(0, text.length)];
        // 前面文字大小
        [mutableAttr addAttribute:NSFontAttributeName
                            value:kFontSizeMedium15
                            range:NSMakeRange(0, text.length)];
        self.totalAmountLabel.attributedText = mutableAttr;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付中心";
    self.isSelected = NO;
    [self initView];
    /// 支付成功之后的通知
    [kNotificationCenter addObserver:self selector:@selector(AlipaySuccessful) name:@"AlipaySuccessfull" object:nil];
}

/// 签名成功处理
- (void) AlipaySuccessful{
    /// 跳转支付宝或微信进行支付
    [self.navigationController popToRootViewControllerAnimated:YES];
    //    [self.navigationController.tabBarController setSelectedIndex:4];
    /// 是否跳转成功,未知,没测
    UITabBarController *tab=self.tabBarController;
    if (tab){
        TTLog(@"I have a tab bar");
        [self.tabBarController setSelectedIndex:4];
    } else{
        TTLog(@"I don't have");
    }
}

- (void) submitBtnClick:(UIButton *)sender{
//    self.model.purchaseType = 2;
    
    if (!self.isSelected) {
        Toast(@"请选择支付方式");
        return;
    }else{
        //// 先验证实名认证
        if (kUserInfo.isValidation==2) {
            /// 直接调用微信或者支付宝支付
//            [self GenerateOrderData:self.payType];
            
            [self protocolBtnClick];
            
        }else if(kUserInfo.isValidation==1){
            Toast(@"实名认证审核中,请稍后再试!");
        }else{
            // 立即认证提示
            UIAlertController *alerController = [UIAlertController addAlertReminderText:@"提示"
                                                                                message:@"是否立即实名认证?"
                                                                            cancelTitle:@"好的"
                                                                                doTitle:@"去设置"//去设置
                                                                         preferredStyle:UIAlertControllerStyleAlert
                                                                            cancelBlock:nil doBlock:^{
                                                                                [self jumpSetRealNameRequest];
                                                                            }];
            [self presentViewController:alerController animated:YES completion:nil];
        }
    }
}

- (void) jumpSetRealNameRequest{
    
}

/// 显示农保电子协议
- (void)protocolBtnClick{
    TXPurchaseAgreementViewController *vc = [[TXPurchaseAgreementViewController alloc] init];
    vc.amountText = self.model.nowprice;
    MV(weakSelf)
    vc.completionHandler = ^(NSString * _Nonnull imageURL) {
        weakSelf.model.signatureURL = imageURL;
        weakSelf.model.purchaseType = 2;
        [weakSelf GenerateOrderData];
    };
    CGFloat widht = (kScreenWidth - 50);
    [self sc_centerPresentController:vc presentedSize:CGSizeMake(widht, kHeight3to2) completeHandle:nil];
}

//// 生成订单且支付
- (void) GenerateOrderData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    
    //    title    是    String    标题（当purchaseType=0时可传入固定值“会员充值”，purchaseType=6时可传入固定值“天合成员充值”，另外的情况请传入商品标题）
    //    purchaseType    是    int    支付类型 0：充值； 1：无人机商城产品；2：农用植保产品； 3：VR产品 4：纵横矿机产品 5：共享飞行产品; 6：天合成员充值；7：生态农业商城产品（消费）；8：飞机订票订单；9：购机预约订单（只能现金支付）；10：培训预约订单（只能现金支付）；11：体验预约订单（只能现金支付）
    //    priceMoney    是    double    单价金额
    //    number    是    double    产品数量(默认传1)
    //    proID    否    int    产品ID（当purchaseType=0（充值）或=6（天合成员充值）时不传）
    //    addressID    否    int    用户选择的收货地址表ID（当purchaseType=1或7必传）
    //    spec    否    String    用户选择规格
    //    color    否    String    用户选择颜色
    //    remarks    否    String    用户购买备注
    //    payType    是    int    0:支付宝 1:微信 2：余额支付
    //    currency    是    Double    vr币数量
    //    subscribeID    否    int    预约表ID（插入预约表后，必传）
    kShowMBProgressHUD(self.view);
    [parameter setObject:self.model.title forKey:@"title"];
    [parameter setObject:@(self.model.purchaseType) forKey:@"purchaseType"];
    [parameter setObject:@([self.model.price doubleValue]) forKey:@"priceMoney"];
    [parameter setObject:@(1) forKey:@"number"];
    [parameter setObject:@([self.model.kid integerValue]) forKey:@"proID"];
    [parameter setObject:self.model.signatureURL forKey:@"imgurl"];
    [parameter setObject:@"" forKey:@"addressID"];
    [parameter setObject:@"" forKey:@"spec"];
    [parameter setObject:@"" forKey:@"color"];
    [parameter setObject:@"" forKey:@"remarks"];
    [parameter setObject:@(self.payType) forKey:@"payType"];/// 支付方式  0:支付宝 1:微信 2：余额支付
    [parameter setObject:@"" forKey:@"currency"];
    [SCHttpTools postWithURLString:kHttpURL(@"orderform/PayFrom") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000) {
            if (self.payType==0) {/// 支付宝支付
                [AlipayManager doAlipayPay:model];
            }else if(self.payType==1){/// 微信支付
                TTLog(@"str == %@",[Utils lz_dataWithJSONObject:result]);
                [AlipayManager doWechatPay:model];
            }else{
                Toast(@"未知支付");
            }
        }else{
            Toast(model.message);
        }
        kHideMBProgressHUD(self.view);;
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
        kHideMBProgressHUD(self.view);;
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger idx = indexPath.section;
    if(idx==0){
        TXShoppingTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierShopping forIndexPath:indexPath];
        tools.model = self.model;
        return tools;
    }else if(idx==1){
        TXPurchaseQuantityTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPurchase forIndexPath:indexPath];
        tools.reductionBtn.enabled = NO;
        tools.increaseBtn.enabled = NO;
        tools.quantityLabel.enabled = NO;
        return tools;
    }else if(idx==2){
        TXMessageChildTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMessage forIndexPath:indexPath];
        tools.titleLabel.text = @"可用VH积分";
        tools.subtitleLabel.text = kUserInfo.vrcurrency;
        return tools;
    }else if(idx == 3){
        TXSwitchTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSwitch forIndexPath:indexPath];
        tools.titleLabel.text = [NSString stringWithFormat:@"消费积分%@VH",self.model.vrcurrency];
        if (kUserInfo.vrcurrency.integerValue<self.model.vrcurrency.integerValue) {
            [tools showlabel];
            [tools.helpButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                NSString *webURL = kAppendH5URL(DomainName, VHHelpH5, @"");
                TXWebViewController *vc = [[TXWebViewController alloc] init];
                vc.title = @"帮助";
                vc.webUrl = webURL;
                TTPushVC(vc);
            }];
        }
        tools.isSwitch.hidden = YES;
        return tools;
    }else if(idx==4){
        TXGeneralModel *model = self.paymentArray[indexPath.row];
        TXChoosePayTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierChoosePay forIndexPath:indexPath];
        tools.titleLabel.text = model.title;
        tools.imagesView.image = kGetImage(model.imageText);
        tools.linerView.hidden = (indexPath.row!=self.paymentArray.count-1)?NO:YES;
        tools.selectedBtn.hidden = NO;
        return tools;
    }else{
        return [UITableViewCell new];
    }
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==4) return self.paymentArray.count;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) return IPHONE6_W(120);
    return IPHONE6_W(50);
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==4) return 10.0;
    if (section==2||section==3) return 0.7;
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==4) {
        self.isSelected = YES;
        self.payType = indexPath.row;
    }
}

#pragma mark ---- 界面布局设置
- (void)initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [self.footerView addSubview:self.submitButton];
    [self.footerView addSubview:self.totalAmountLabel];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(kTabBarHeight));
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat height = IPHONE6_W(35);
        CGFloat top = (kTabBarHeight-height-kSafeAreaBottomHeight)/2;
        make.right.equalTo(self.footerView.mas_right).offset(IPHONE6_W(-15));
        make.height.equalTo(@(height));
        make.width.equalTo(@(IPHONE6_W(85)));
        make.top.equalTo(@(top));
    }];
    
    [self.totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.submitButton.mas_left).offset(-15);
        make.centerY.equalTo(self.submitButton);
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXShoppingTableViewCell class] forCellReuseIdentifier:reuseIdentifierShopping];
        [_tableView registerClass:[TXChoosePayTableViewCell class] forCellReuseIdentifier:reuseIdentifierChoosePay];
        [_tableView registerClass:[TXPurchaseQuantityTableViewCell class] forCellReuseIdentifier:reuseIdentifierPurchase];
        [_tableView registerClass:[TXMessageChildTableViewCell class] forCellReuseIdentifier:reuseIdentifierMessage];
        [_tableView registerClass:[TXSwitchTableViewCell class] forCellReuseIdentifier:reuseIdentifierSwitch];
        
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
    }
    return _tableView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _footerView;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _submitButton.titleLabel.font = kFontSizeMedium15;
        [_submitButton setTitle:@"立即支付" forState:UIControlStateNormal];
        UIImage *image = [UIImage lz_imageWithColor:kThemeColorHex];
        [_submitButton setBackgroundImage:image forState:UIControlStateNormal];
        [_submitButton lz_setCornerRadius:3.0];
        MV(weakSelf);
        [_submitButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf submitBtnClick:self.submitButton];
        }];
    }
    return _submitButton;
}

- (UILabel *)totalAmountLabel{
    if (!_totalAmountLabel) {
        _totalAmountLabel = [UILabel lz_labelWithTitle:@"" color:kPriceColor font:kFontSizeMedium24];
    }
    return _totalAmountLabel;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)paymentArray{
    if (!_paymentArray) {
        _paymentArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@"支付宝",@"微信支付"];
        NSArray* classArr = @[@"c31_btn_zfb",@"c31_btn_wxzf"];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:j];
            generalModel.imageText = [classArr lz_safeObjectAtIndex:j];
            [_paymentArray addObject:generalModel];
        }
    }
    return _paymentArray;
}

@end
