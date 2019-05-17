//
//  TXSubmitOrderViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXSubmitOrderViewController.h"
#import "TXReceiveAddressTableViewCell.h"
#import "TXShoppingTableViewCell.h"
#import "TXChoosePayTableViewCell.h"
#import "TXPurchaseQuantityTableViewCell.h"
#import "TXMessageChildTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXAddressViewController.h"
#import "TXAddressModel.h"
#import "TXChoosePayViewController.h"
#import "TXPayPasswordViewController.h"
#import "AlipayManager.h"

static NSString * const reuseIdentifierReceiveAddress = @"TXReceiveAddressTableViewCell";
static NSString * const reuseIdentifierShopping = @"TXShoppingTableViewCell";
static NSString * const reuseIdentifierChoosePay = @"TXChoosePayTableViewCell";
static NSString * const reuseIdentifierPurchase = @"TXPurchaseQuantityTableViewCell";
static NSString * const reuseIdentifierMessage = @"TXMessageChildTableViewCell";

@interface TXSubmitOrderViewController ()<UITableViewDelegate,UITableViewDataSource,TTPopupViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 底部视图
@property (nonatomic, strong) UIView        *footerView;
/// 提交按钮
@property (nonatomic, strong) UIButton      *submitButton;
/// 提交按钮
@property (nonatomic, strong) UILabel       *totalTitleLabel;
/// 提交按钮
@property (nonatomic, strong) UILabel       *totalAmountLabel;
/// 付款方式数组
@property (nonatomic, strong) NSMutableArray *paymentArray;
@property (nonatomic, strong) AddressModel  *addressModel;
@property (nonatomic, assign) NSInteger  addressNum;
/// 产品Model
@property (nonatomic, strong)  NewsRecordsModel *model;
/// 单选,当前选中的行
@property (nonatomic, assign) NSIndexPath *selectedIndexPath;
/// 记录当前是否有选择支付方式
@property (nonatomic, assign) BOOL isSelected;
/// 0:支付宝 1:微信支付 2:余额支付
@property (nonatomic, assign) NSInteger payType;

@end

@implementation TXSubmitOrderViewController
- (id) initNewsRecordsModel:(NewsRecordsModel *)model{
    if ( self = [super init] ){
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付中心";
    [self initView];
    _isSelected = NO;
    self.addressModel = [[AddressModel alloc] init];
    NSInteger totalAmount = self.model.buyCount*[self.model.price integerValue];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%ld.00",(long)totalAmount];
    /// 通知得到默认收货地址
//    [kNotificationCenter postNotificationName:@"reloadAddressData" object:nil];
    [self getAddressModel];
    // 注册通知
    [kNotificationCenter addObserver:self selector:@selector(dealwithNotice) name:@"mallBalanceRequest" object:nil];
}

- (void) dealwithNotice{
    [self dismissedButtonClicked];
    [self GenerateOrderData:self.payType];
}

- (void) submitBtnClick:(UIButton *)sender{
    self.model.purchaseType = 2;
    //// 先验证实名认证
    if (kUserInfo.isValidation==2) {
        /// 接着验证是否有选择支付方式
        if (!_isSelected) {
            Toast(@"请选择支付方式");
            return;
        }
        if (self.payType==2) {  /// 如果选择的余额支付调起支付密码界面
            TXPayPasswordViewController *viewController = [[TXPayPasswordViewController alloc] init];
            viewController.pageType = 3;
            viewController.tipsText = @"";
            viewController.integralText = kUserInfo.balance;
            viewController.delegate = self;
            [self presentPopupViewController:viewController animationType:TTPopupViewAnimationFade];
        }else{                  /// 直接调用微信或者支付宝支付
            [self GenerateOrderData:self.payType];
        }
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

- (void) jumpSetRealNameRequest{
    
}

/// 生成订单且支付
- (void) GenerateOrderData:(NSInteger) idx{
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
    [parameter setObject:@"" forKey:@"addressID"];
    [parameter setObject:@"" forKey:@"spec"];
    [parameter setObject:@"" forKey:@"color"];
    [parameter setObject:@"" forKey:@"remarks"];
    [parameter setObject:@(self.payType) forKey:@"payType"];/// 支付方式  0:支付宝 1:微信 2：余额支付
    [parameter setObject:@"" forKey:@"currency"];
    [SCHttpTools postWithURLString:kHttpURL(@"orderform/PayFrom") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                if (idx==0) {/// 支付宝支付
                    [AlipayManager doAlipayPay:model];
                }else if(idx==1){/// 微信支付
                    NSString *str = [Utils lz_dataWithJSONObject:result];
                    TTLog(@"str == %@",str);
                    [AlipayManager doWechatPay:model];
                }else if(idx==2){
                    Toast(@"支付成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    Toast(@"未知支付");
                }
            }else{
                Toast(model.message);
            }
        }
        kHideMBProgressHUD(self.view);;
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
        kHideMBProgressHUD(self.view);;
    }];
}

/// 关闭当前交易密码弹出的窗口
- (void)dismissedButtonClicked{
    [self dismissPopupViewControllerWithanimationType:TTPopupViewAnimationFade];
}

- (void) getAddressModel{
    [SCHttpTools getWithURLString:kHttpURL(@"address/GetAddress") parameter:nil success:^(id responseObject) {
        NSDictionary *results = responseObject;
        if ([results isKindOfClass:[NSDictionary class]]) {
            TXAddressModel *addressModel = [TXAddressModel mj_objectWithKeyValues:results];
            if (addressModel.errorcode == 20000) {
                self.addressNum = addressModel.data.count;
                for (AddressModel *model in addressModel.data) {
                    if (model.isDefault) {
                        self.addressModel = model;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
                    }
                }
                [self.tableView reloadData];
            }else{
                Toast(addressModel.message);
            }
        }
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
    }];
}

#pragma mark ---- 界面布局设置
- (void)initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [self.footerView addSubview:self.submitButton];
    [self.footerView addSubview:self.totalTitleLabel];
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
    
    [self.totalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalAmountLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.submitButton);
    }];
}

/**
 *  点击增加按钮
 *  tag:0 增加 tag:1 减少
 *  @param sender 当前按钮
 */
- (void)onClickBtn:(UIButton *)sender {
    if (sender.tag==0) {
        self.model.buyCount += 1;
    }else{
        self.model.buyCount = (self.model.buyCount<2) ? 1 : (self.model.buyCount-= 1);
    }
    NSInteger totalAmount = self.model.buyCount*[self.model.price integerValue];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%ld.00",(long)totalAmount];
    self.model.totalPrice = [NSString stringWithFormat:@"%ld",(long)totalAmount];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            TXReceiveAddressTableViewCell*tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiveAddress forIndexPath:indexPath];
            tools.nicknameLabel.text = self.addressModel.username;//@"李阿九";
            tools.telphoneLabel.text = self.addressModel.telphone;//@"13566667888";
            tools.addressLabel.text = self.addressModel.address;//@"四川 成都 高新区 环球中心W6区 1518室";
            tools.addButton.userInteractionEnabled = NO;
            if ((self.addressNum==0)&&(!self.addressModel.isDefault)) {
                tools.imagesView.hidden = YES;
                tools.imagesView.hidden = NO;
            }
            return tools;
        }
            break;
        case 1: {
            TXShoppingTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierShopping forIndexPath:indexPath];
            tools.model = self.model;
            return tools;
        }
            break;
        case 2: {
            TXPurchaseQuantityTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPurchase forIndexPath:indexPath];
            MV(weakSelf)
            [tools.reductionBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                [weakSelf onClickBtn:tools.reductionBtn];
            }];
            [tools.increaseBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                [weakSelf onClickBtn:tools.increaseBtn];
            }];
            tools.quantityLabel.text = [NSString stringWithFormat:@"%ld",(long)self.model.buyCount];
            return tools;
        }
            break;
        case 3: {
            TXMessageChildTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMessage forIndexPath:indexPath];
            tools.titleLabel.text = @"可用VH积分";
            tools.subtitleLabel.text = kUserInfo.vrcurrency;
            return tools;
        }
            break;
        case 4: {
            TXGeneralModel *model = self.paymentArray[indexPath.row];
            TXChoosePayTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierChoosePay forIndexPath:indexPath];
            tools.titleLabel.text = model.title;
            tools.imagesView.image = kGetImage(model.imageText);
            tools.linerView.hidden = (indexPath.row!=self.paymentArray.count-1)?NO:YES;
            tools.selectedBtn.hidden = NO;
            return tools;
        }
            break;
    }
    return [UITableViewCell new];
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
    if (indexPath.section==0) return IPHONE6_W(70);
    if (indexPath.section==1) return IPHONE6_W(120);
    return IPHONE6_W(50);
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==2||section==3) return 0;
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TXAddressViewController *vc = [[TXAddressViewController alloc] init];
        MV(weakSelf)
        vc.selectedAddressBlock = ^(AddressModel * _Nonnull model) {
            weakSelf.addressModel = model;
            NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        TTPushVC(vc);
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else if (indexPath.section==3){
        _isSelected = YES;
        _payType = indexPath.row;
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXReceiveAddressTableViewCell class] forCellReuseIdentifier:reuseIdentifierReceiveAddress];
        [_tableView registerClass:[TXShoppingTableViewCell class] forCellReuseIdentifier:reuseIdentifierShopping];
        [_tableView registerClass:[TXChoosePayTableViewCell class] forCellReuseIdentifier:reuseIdentifierChoosePay];
        [_tableView registerClass:[TXPurchaseQuantityTableViewCell class] forCellReuseIdentifier:reuseIdentifierPurchase];
        [_tableView registerClass:[TXMessageChildTableViewCell class] forCellReuseIdentifier:reuseIdentifierMessage];

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
        UIImage *image = [UIImage lz_imageWithColor:kColorWithRGB(211, 0, 0)];
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
        _totalAmountLabel = [UILabel lz_labelWithTitle:@"" color:kColorWithRGB(211, 0, 0) font:kFontSizeMedium15];
    }
    return _totalAmountLabel;
}

- (UILabel *)totalTitleLabel{
    if (!_totalTitleLabel) {
        _totalTitleLabel = [UILabel lz_labelWithTitle:@"总计:" color:kTextColor102 font:kFontSizeMedium15];
    }
    return _totalTitleLabel;
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
        NSArray* titleArr = @[@"支付宝",@"微信支付",[NSString stringWithFormat:@"余额(￥:%@)",kUserInfo.balance]];
        NSArray* classArr = @[@"c31_btn_zfb",@"c31_btn_wxzf",@"c31_钱袋"];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:j];
            generalModel.imageText = [classArr lz_safeObjectAtIndex:j];
            [_paymentArray addObject:generalModel];
        }
    }
    return _paymentArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
