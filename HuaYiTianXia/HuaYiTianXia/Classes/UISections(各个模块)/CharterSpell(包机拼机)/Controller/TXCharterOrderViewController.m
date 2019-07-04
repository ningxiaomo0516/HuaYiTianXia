//
//  TXCharterOrderViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/1.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterOrderViewController.h"
#import "TXCharterOrderTableViewCell.h"
#import "TXCharterBaseInfoTableViewCell.h"
#import "TTBaseSectionHeaderView.h"
#import "TXCharterFooterView.h"

#import "TXCharterOrderModel.h"
#import "TXInvoiceViewController.h"
#import "TXAddressViewController.h"
#import "TXChoosePaySingleView.h"
#import "TXTicketModel.h"
#import "AlipayManager.h"

static NSString * const reuseIdentifier = @"TXCharterOrderTableViewCell";
static NSString * const reuseIdentifierInfo = @"TXCharterBaseInfoTableViewCell";

@interface TXCharterOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isDefault;
/// 底部视图
@property (nonatomic, strong) TXCharterFooterView *footerView;
/// 机票信息
@property (nonatomic, strong) CharterMachineModel *ticketTodel;
@property (nonatomic, strong) CharterOrderModel *orderModel;

@property (nonatomic, strong) InvoiceModel *invoiceMode;
@property (nonatomic, strong) AddressModel *addressModel;

/// 协议的View
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIButton *tableFooterBtn;

@property (nonatomic, strong) TXChoosePaySingleView *paySingleView;
@property (nonatomic, assign) NSInteger sectionHeaderHeight;
@property (nonatomic, strong) ChoosePayModel *pay_model;

@end

@implementation TXCharterOrderViewController
- (instancetype)initTicketModel:(CharterMachineModel *)ticketTodel{
    if (self = [super init]){
        self.ticketTodel = ticketTodel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填写订单";
    self.isDefault = YES;
    self.sectionHeaderHeight = 40.f;
    [self initView];
    TTLog(@"self.ticketTodel --- %@",self.ticketTodel.kid);
    [self.view showLoadingViewWithText:@"请稍后..."];
    [self requestTicketOrderData];
    MV(weakSelf)
    [self.footerView.submitButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf saveDataRequest];
    }];
}

- (void) saveDataRequest{
    NSString *invoiceID,*addressID = @"";
    if (self.isDefault) {
        if (!self.invoiceMode) {
            Toast(@"请选择发票抬头!");
            return;
        }else{
            invoiceID = self.invoiceMode.kid;
        }
        if (!self.addressModel) {
            Toast(@"请选择收货地址!");
            return;
        }else{
            addressID = self.addressModel.sid;
        }
    }else{
        invoiceID = @"";
        addressID = @"";
    }
    
    kShowMBProgressHUD(self.view);
    NSString *URLString = kHttpURL(@"aircraftorder/AddAircraftorder");
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.orderModel.depCity forKey:@"origin"];
    [parameter setObject:self.orderModel.arvCity forKey:@"destination"];
    /// 实际订票价格
    [parameter setObject:self.orderModel.needDeposit forKey:@"orderprice"];
    /// APP提交价格(需支付价格)
    [parameter setObject:self.orderModel.needDeposit forKey:@"price"];
    /// 备注
    [parameter setObject:@"" forKey:@"remarks"];
    /// 航班号(无航班号)
    [parameter setObject:@"" forKey:@"flightNumber"];
    /// 起飞时间
    [parameter setObject:self.orderModel.arvTime forKey:@"depTime"];
    /// 到达时间
    [parameter setObject:self.orderModel.depTime forKey:@"arvTime"];
    /// 航空公司
    [parameter setObject:self.orderModel.airline forKey:@"airline"];
    /// 飞机类型
    [parameter setObject:self.orderModel.aircraft forKey:@"aircraft"];
    /// 起飞机场
    [parameter setObject:self.orderModel.depAirport forKey:@"depAirport"];
    /// 到达机场
    [parameter setObject:self.orderModel.arvAirport forKey:@"arvAirport"];
    
    /// 到达航站楼
    [parameter setObject:self.orderModel.arvTerminal forKey:@"arvTerminal"];
    /// 起飞航站楼
    [parameter setObject:self.orderModel.depTerminal forKey:@"depTerminal"];
    /// 1:天合成员飞机订票 2:包机订票 3:拼机订票(默认1)
    [parameter setObject:@(2) forKey:@"type"];
    /// 支付方式 0:支付宝 1:微信 2:余额支付
    [parameter setObject:@(self.pay_model.kid.integerValue) forKey:@"payType"];
    /// 发票表ID
    [parameter setObject:@(invoiceID.integerValue) forKey:@"invoiceID"];
    /// 收货地址表ID
    [parameter setObject:@(addressID.integerValue) forKey:@"addressID"];
    
    [SCHttpTools postWithURLString:URLString parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
        if (model.errorcode==20000) {
            if (self.pay_model.kid.integerValue==0) {
                [AlipayManager doAlipayPay:model];
            }else if(self.pay_model.kid.integerValue==1){
                NSString *str = [Utils lz_dataWithJSONObject:result];
                TTLog(@"str == %@",str);
                [AlipayManager doWechatPay:model];
            }
            TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
        }else if(model.errorcode==200305){
            Toast(@"支付成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
        Toast(model.message);
        kHideMBProgressHUD(self.view);
    } failure:^(NSError *error) {
        TTLog(@"机票查询信息 -- %@", error);
        kHideMBProgressHUD(self.view);
    }];
}

- (void) requestTicketOrderData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.ticketTodel.kid forKey:@"id"];  // 机票信息ID
    NSString *URLString = @"aircraftinformation/queryAircraftinDetails";
    [SCHttpTools postWithURLString:kHttpURL(URLString) parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TTLog(@"result -- %@",[Utils lz_dataWithJSONObject:result]);
        TXCharterOrderModel *model = [TXCharterOrderModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000) {
            self.orderModel = model.data;
            [self setValueText:model.data];
            self.tableView.hidden = NO;
            self.footerView.hidden = NO;
        }else{
            self.noDataView.hidden = NO;
        }
        [self.tableView reloadData];
        [self.view dismissLoadingView];
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        [self.view dismissLoadingView];
        self.noDataView.hidden = YES;
    }];
}

- (void) setValueText:(CharterOrderModel *) model{
    NSString *text = @"合计:";
    NSString *amountText =  [NSString stringWithFormat:@"%@￥%@",text,model.needDeposit];

    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:amountText];
    /// 前面文字颜色
    [mutableAttr addAttribute:NSForegroundColorAttributeName value:kTextColor51 range:NSMakeRange(0, text.length)];
    /// 前面文字大小
    [mutableAttr addAttribute:NSFontAttributeName value:kFontSizeMedium15 range:NSMakeRange(0, text.length)];
    self.footerView.totalAmountLabel.attributedText = mutableAttr;
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    self.tableView.tableFooterView = self.tableFooterView;
    [self.tableFooterView addSubview:self.tableFooterBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(kTabBarHeight));
    }];

    [self.tableFooterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tableFooterView.mas_right).offset(-15);
        make.top.equalTo(@(5));
    }];
}

- (void) valueSwitchChanged:(UISwitch *) isSwitch{
    if (isSwitch.on) {
        self.isDefault = YES;
    }else{
        self.isDefault = NO;
    }
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        TXCharterOrderTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.orderModel = self.orderModel;
        return tools;
    }else if(indexPath.section==4){
        static NSString * reuseIdentifierPaySingleView = @"self.paySingleView";
        UITableViewCell *tools = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifierPaySingleView];
        if (!tools) {
            tools = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierPaySingleView];
        }
        [tools.contentView addSubview:self.paySingleView];
        return tools;
    }else{
        TXCharterBaseInfoTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierInfo forIndexPath:indexPath];
        TXGeneralModel* model = self.dataArray[indexPath.section][indexPath.row];
        tools.titleLabel.text = model.title;
        if (indexPath.section==1){
            tools.titleLabel.textColor = kTextColor153;
        }else if (indexPath.section==2) {
            tools.subtitleLabel.hidden = NO;
            switch (indexPath.row) {
                case 0:
                    tools.subtitleLabel.text = [NSString stringWithFormat:@"￥%@",self.orderModel.referenceprice];
                    break;
                case 1:
                    tools.subtitleLabel.text = [NSString stringWithFormat:@"￥%@",self.orderModel.price];
                    break;
                case 2:
                    tools.subtitleLabel.text = [NSString stringWithFormat:@"￥%@",self.orderModel.needDeposit];
                    break;
            }
        }else if(indexPath.section==3){
            tools.imagesArrow.hidden = NO;
            if (indexPath.row==0) {
                tools.titleLabel.text = (self.invoiceMode.invoiceTaxNumber.length==0)?model.title:self.invoiceMode.invoiceTaxNumber;
            }else if(indexPath.row==1){
                tools.titleLabel.text = (self.addressModel.username.length==0)?model.title:self.addressModel.address;
            }
        }
        if (indexPath.section==3||indexPath.section==4) {
            tools.selectionStyle = UITableViewCellSelectionStyleDefault;
        }else{
            tools.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return tools;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) return IPHONE6_W(240);
    if (indexPath.section==4) return 140;
    return IPHONE6_W(50);
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subArray = [self.dataArray lz_safeObjectAtIndex:section];
    return subArray.count;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==4) return 0.0001f;
    return self.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}

#pragma mark -- Section HearderView Title
// UITableView在Plain类型下，HeaderView和FooterView不悬浮和不停留的方法viewForHeaderInSection
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [UIView lz_viewWithColor:kWhiteColor];
    CGFloat height = section==0?0.0001f:self.sectionHeaderHeight;
    sectionView.frame = CGRectMake(0, 0, kScreenWidth, height);
    if (section!=0) {
        UIView *linerView = [UIView lz_viewWithColor:kLinerViewColor];
        linerView.frame = CGRectMake(0, 39.5, kScreenWidth, 0.4);
        [sectionView addSubview:linerView];
        UILabel *titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium13];
        [sectionView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.centerY.equalTo(sectionView);
        }];

        if (section==1) titleLabel.text = @"联系人信息";
        if (section==2) titleLabel.text = @"售价";
        if (section==3) {
            UISwitch *isSwitch = [[UISwitch alloc] init];
            isSwitch.onTintColor = kThemeColorHex;
            /// 设置按钮处于关闭状态时边框的颜色
            isSwitch.tintColor = kTextColor238;
            isSwitch.on = self.isDefault;
            [sectionView addSubview:isSwitch];
            [isSwitch addTarget:self action:@selector(valueSwitchChanged:) forControlEvents:(UIControlEventValueChanged)];
            [isSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(sectionView.mas_right).offset(-15);
                make.centerY.equalTo(sectionView);
            }];
            titleLabel.text = @"报销凭证";
        }
    }
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *sectionView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 10.f)];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MV(weakSelf)
    if(indexPath.section==4){
        
    }else if(indexPath.section==3){
        if (indexPath.row==0) {
            if (self.isDefault) {
                TXInvoiceViewController *vc = [[TXInvoiceViewController alloc] init];
                vc.selectBlock = ^(InvoiceModel * _Nonnull invoiceModel) {
                    weakSelf.invoiceMode = invoiceModel;
                    [self refreshTableView:tableView indexPath:indexPath];
                };
                TTPushVC(vc);
            }
        }else{
            TXAddressViewController *vc = [[TXAddressViewController alloc] init];
            MV(weakSelf)
            vc.selectedAddressBlock = ^(AddressModel * _Nonnull model) {
                weakSelf.addressModel = model;
                [self refreshTableView:tableView indexPath:indexPath];
            };
            TTPushVC(vc);
        }
    }else{
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/// 使用 UITableViewStylePlain 的情况下,系统默认会有黏滞效果.使用如下方法去除黏滞效果:
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView){
        CGFloat sectionHeaderHeight = self.sectionHeaderHeight; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

/// 刷新单个Cell
- (void) refreshTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPaths,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark ----- getter/setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_tableView registerClass:[TXCharterOrderTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXCharterBaseInfoTableViewCell class] forCellReuseIdentifier:reuseIdentifierInfo];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.hidden = YES;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (TXCharterFooterView *)footerView{
    if (!_footerView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kTabBarHeight);
        _footerView = [[TXCharterFooterView alloc] initWithFrame:rect];
        _footerView.hidden = YES;
    }
    return _footerView;
}

- (UIView *)tableFooterView{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] init];
        _tableFooterView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    }
    return _tableFooterView;
}

- (TXChoosePaySingleView *)paySingleView {
    if (!_paySingleView) {
        _paySingleView = [TXChoosePaySingleView initTableWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
//        _paySingleView.dataArray = self.dataArray;
//        _paySingleView.chooseContent = self.selectMusicStr;
        [_paySingleView reloadData];
        //选中内容
        MV(weakSelf)
        _paySingleView.chooseBlock = ^(ChoosePayModel * _Nonnull model) {
            TTLog(@"数据：%@ ；第%@行",model.titleName,model.kid);
            weakSelf.pay_model = model;
        };
    }
    return _paySingleView;
}

- (UIButton *)tableFooterBtn{
    if (!_tableFooterBtn) {
        _tableFooterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tableFooterBtn setTitleColor:kTextColor51 forState:UIControlStateNormal];
        _tableFooterBtn.titleLabel.font = kFontSizeMedium14;
        _tableFooterBtn.selected = YES;
        [_tableFooterBtn setTitle:@"我已同意包机协议" forState:UIControlStateNormal];
        [_tableFooterBtn setImage:kGetImage(@"mine_btn_normal") forState:UIControlStateNormal];
        [_tableFooterBtn setImage:kGetImage(@"mine_btn_selected") forState:UIControlStateSelected];
        [Utils lz_setButtonTitleWithImageEdgeInsets:_tableFooterBtn postition:kMVImagePositionLeft spacing:5.0];
        MV(weakSelf)
        [_tableFooterBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            weakSelf.tableFooterBtn.selected = !weakSelf.tableFooterBtn.selected;
            if (weakSelf.tableFooterBtn.selected) {
                [self->_tableFooterBtn setImage:kGetImage(@"mine_btn_selected") forState:UIControlStateSelected];
            }else{
                [self->_tableFooterBtn setImage:kGetImage(@"mine_btn_normal") forState:UIControlStateNormal];
            }
        }];
    }
    return _tableFooterBtn;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@[@""],
                              @[kUserInfo.realname,kUserInfo.phone],
                              @[@"原价",@"特惠价",@"定金"],
                              @[@"请选择发票抬头",@"请选择收货地址"],
                              @[@"支付方式"]];
        NSArray* classArr = @[@[@""],
                              @[@"",@"",@""],
                              @[@"",@"",@""],
                              @[@"",@"TXSetupViewController",@""],
                              @[@""]];
        for (int i=0; i<titleArr.count; i++) {
            NSArray *subTitlesArray = [titleArr lz_safeObjectAtIndex:i];
            NSArray *classArray = [classArr lz_safeObjectAtIndex:i];
            NSMutableArray *subArray = [NSMutableArray array];
            for (int j = 0; j < subTitlesArray.count; j ++) {
                TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
                generalModel.title = [subTitlesArray lz_safeObjectAtIndex:j];
                generalModel.showClass = [classArray lz_safeObjectAtIndex:j];
                [subArray addObject:generalModel];
            }
            [_dataArray addObject:subArray];
        }
    }
    return _dataArray;
}

@end
