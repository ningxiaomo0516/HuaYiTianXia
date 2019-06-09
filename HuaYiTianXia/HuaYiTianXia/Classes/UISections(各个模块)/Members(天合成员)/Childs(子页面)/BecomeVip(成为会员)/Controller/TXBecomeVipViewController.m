//
//  TXBecomeVipViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXBecomeVipViewController.h"
#import "TXBecomeVipHeaderView.h"
#import "TXBecomeVipTableViewCell.h"
#import "TXChoosePayTableViewCell.h"
#import "AlipayManager.h"

static NSString * const reuseIdentifier = @"TXBecomeVipTableViewCell";
static NSString * const reuseIdentifierChoosePay = @"TXChoosePayTableViewCell";

@interface TXBecomeVipViewController ()<UITableViewDelegate,UITableViewDataSource,TXBecomeVipTableViewCellDelegate>
@property (nonatomic,strong) TXBecomeVipHeaderView *headerView;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *footerView;
/// 付款方式数组
@property (nonatomic, strong) NSMutableArray *paymentArray;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@property (nonatomic, copy) NSString *topupAmount;
@property (nonatomic, copy) NSString *topupAmount1;
@property (nonatomic, copy) NSString *topupAmount2;
@property (nonatomic, assign) NSInteger payType;
@end

@implementation TXBecomeVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topupAmount = @"";
    self.payType = -1;
    [self initView];
    self.tableView.hidden = YES;
    [self.view showLoadingViewWithText:@"请稍后..."];
    [self getTopupAmount];
    self.title = @"会员充值";
}

- (void) submitClick:(UIButton *)sender{
    if (self.topupAmount.length==0) {
        Toast(@"请输入充值金额");
        return;
    }
    if (self.payType == -1) {
        Toast(@"请输选择支付方式");
        return;
    }
    [self GenerateOrderData:self.payType];
}

/// 天合成员充值金额获取
- (void) getTopupAmount{
    [SCHttpTools getWithURLString:kHttpURL(@"customer/THGetMoney") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TTUserDataModel *model = [TTUserDataModel mj_objectWithKeyValues:result];
        if (model.errorcode==20000) {
            TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
            NSDictionary *obj = [result lz_objectForKey:@"obj"];
            TTLog(@" ---- -%@",[obj lz_objectForKey:@"money"]);
            TTLog(@" ---- -%@",[obj lz_objectForKey:@"thMoney"]);
            NSString *AmoutText1 = [NSString stringWithFormat:@"%@",[obj lz_objectForKey:@"thMoney"]];
            self.topupAmount1 = [Utils isNull:AmoutText1];
            self.topupAmount2 = [Utils isNull:AmoutText1];
            [self.tableView reloadData];
        }else{
            self.topupAmount1 = @"0";
            self.topupAmount2 = @"0";
            Toast(model.message);
        }
        self.tableView.hidden = NO;
        kHideMBProgressHUD(self.view);
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        TTLog(@"成为会员 -- %@", error);
        kHideMBProgressHUD(self.view);
        [self.view dismissLoadingView];
    }];
}

/// 生成订单且支付
- (void) GenerateOrderData:(NSInteger)idx{
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
    [parameter setObject:@"天合成员充值" forKey:@"title"];
    [parameter setObject:@(6) forKey:@"purchaseType"];
    [parameter setObject:@([self.topupAmount doubleValue]) forKey:@"priceMoney"];
    [parameter setObject:@(1) forKey:@"number"];
    [parameter setObject:@"" forKey:@"proID"];
    [parameter setObject:@"" forKey:@"addressID"];
    [parameter setObject:@"" forKey:@"spec"];
    [parameter setObject:@"" forKey:@"color"];
    [parameter setObject:@"" forKey:@"remarks"];
    [parameter setObject:@(idx) forKey:@"payType"];/// 支付方式  0:支付宝 1:微信 2：余额支付
    [parameter setObject:@"" forKey:@"currency"];
    [SCHttpTools postWithURLString:kHttpURL(@"orderform/PayFrom") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
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
        kHideMBProgressHUD(self.view);;
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
        kHideMBProgressHUD(self.view);;
    }];
}

- (void) initView{
    [self.view addSubview:self.tableView];
    [Utils lz_setExtraCellLineHidden:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.footerView addSubview:self.saveButton];
    self.tableView.tableFooterView = self.footerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(IPHONE6_W(45)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-45));
        make.left.equalTo(@(IPHONE6_W(45)));
        make.height.equalTo(@(IPHONE6_W(45)));
    }];
}

#pragma mark ====== First ======
- (void)updateTableViewCellHeight:(TXBecomeVipTableViewCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath {
    if (![self.heightAtIndexPath[indexPath] isEqualToNumber:@(height)]) {
        self.heightAtIndexPath[indexPath] = @(height);
        [self.tableView reloadData];
    }
}


#pragma mark ====== onClick First Section 工具======
- (void)didToolsSelectItemAtIndexPath:(NSIndexPath *)indexPath withContent:(NSString *)content{
    self.topupAmount = content;
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        TXBecomeVipTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.delegate = self;
        tools.indexPath = indexPath;
        if (self.topupAmount1.length>0&&self.topupAmount2.length>0) {
            [tools setDataCell:self.topupAmount amountText1:self.topupAmount1];
        }else{
            [tools setDataCell:self.topupAmount amountText1:@"0"];
        }
        return tools;
    }else if (indexPath.section==1) {
        TXGeneralModel *model = self.paymentArray[indexPath.row];
        TXChoosePayTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierChoosePay forIndexPath:indexPath];
        tools.titleLabel.text = model.title;
        tools.imagesView.image = kGetImage(model.imageText);
        tools.linerView.hidden = YES;
        tools.selectedBtn.hidden = NO;
        return tools;
    }
    return [UITableViewCell new];
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return 1;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (self.heightAtIndexPath[indexPath]) {
            NSNumber *num = self.heightAtIndexPath[indexPath];
            /// collectionView 底部还有七个像素
            TTLog(@"[num floatValue] --- %f",[num floatValue]);
            return [num floatValue];
        }else {
            return UITableViewAutomaticDimension;
        }
    }
    return IPHONE6_W(50);
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        self.payType = indexPath.row;
    }
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) return 0.001f;
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

#pragma mark -- Section HearderView Title
// UITableView在Plain类型下，HeaderView和FooterView不悬浮和不停留的方法viewForHeaderInSection
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==1) {
        UIView *sectionView = [UIView lz_viewWithColor:kTableViewInSectionColor];
        sectionView.frame = CGRectMake(0, 0, kScreenWidth, IPHONE6_W(50));
        UIView *boxView = [UIView lz_viewWithColor:kWhiteColor];
        boxView.frame = CGRectMake(0, 10, kScreenWidth, IPHONE6_W(40));
        [sectionView addSubview:boxView];
        UILabel *titletitle = [UILabel lz_labelWithTitle:@"选择支付方式" color:kTextColor102 font:kFontSizeMedium15];
        [boxView addSubview:titletitle];
        [titletitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(IPHONE6_W(15)));
            make.centerY.equalTo(boxView);
        }];
        return sectionView;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView lz_viewWithColor:kTableViewInSectionColor];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 0.001f);
    return footerView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,IPHONE6_W(15),0,0)];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TXChoosePayTableViewCell class] forCellReuseIdentifier:reuseIdentifierChoosePay];
        [_tableView registerClass:[TXBecomeVipTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kWhiteColor;
    }
    return _tableView;
}

- (TXBecomeVipHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TXBecomeVipHeaderView alloc] init];
        _headerView.backgroundColor = kWhiteColor;
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, IPHONE6_W(150));
    }
    return _headerView;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.tag = 2;
        [_saveButton setTitle:@"确定" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_saveButton cornerRadius:45/2.0];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf submitClick:self->_saveButton];
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

- (NSMutableDictionary *)heightAtIndexPath {
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [[NSMutableDictionary alloc] init];
    }
    return _heightAtIndexPath;
}

@end
