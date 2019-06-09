//
//  TXTicketBookingViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/17.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTicketBookingViewController.h"
#import "TXTicketModel.h"
#import "TXTicketBookingTableViewCell.h"
#import "TXRolloutTableViewCell.h"
#import "TXTicketInfoTableViewCell.h"
#import "TXPayPasswordViewController.h"

static NSString* reuseIdentifier = @"TXTicketBookingTableViewCell";
static NSString* reuseIdentifierRollout = @"TXRolloutTableViewCell";
static NSString* reuseIdentifierInfo = @"TXTicketInfoTableViewCell";

@interface TXTicketBookingViewController ()<UITableViewDelegate,UITableViewDataSource,TicketCellDelegate,TTPopupViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *parameter;
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) TicketModel *ticketModel;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *priceTipsLabel;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UILabel *titleLabel;
/// 是否选择了机票
@property (nonatomic, assign) NSInteger isSelected;
/// 单选，当前选中的行
@property (nonatomic, assign) NSIndexPath *selectedIndexPath;

@end

@implementation TXTicketBookingViewController
- (id)initTicketModel:(TicketModel *)ticketModel{
    if ( self = [super init] ){
        self.ticketModel = ticketModel;
        for (TicketPricesModel *model in ticketModel.prices) {
            if ([model.discount isEqualToString:@"全价"]) {
                [self.dataArray addObject:model];
            }
        }
        self.isSelected = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"机票预订";
    [self initView];
    // 注册通知
    [kNotificationCenter addObserver:self selector:@selector(dealwithNotice) name:@"buyTicketRequest" object:nil];
}

- (void) dealwithNotice{
    [self dismissedButtonClicked];
    kShowMBProgressHUD(self.view);
    NSString *URLString = kHttpURL(@"aircraftorder/AddAircraftorder");
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.ticketModel.dep_city forKey:@"origin"];
    [parameter setObject:self.ticketModel.arv_city forKey:@"destination"];
    [parameter setObject:self.priceLabel.text forKey:@"orderprice"];
    [parameter setObject:self.priceLabel.text forKey:@"price"];
    [parameter setObject:@"" forKey:@"remarks"];
    [parameter setObject:self.ticketModel.flight_number forKey:@"flightNumber"];// 航班号
    [parameter setObject:self.ticketModel.arv_time forKey:@"depTime"];/// 起飞时间
    [parameter setObject:self.ticketModel.dep_time forKey:@"arvTime"];/// 到达时间
    [parameter setObject:self.ticketModel.airline forKey:@"airline"];/// 航空公司
    [parameter setObject:self.ticketModel.model forKey:@"aircraft"]; /// 飞机类型
    [parameter setObject:self.ticketModel.dep_airport forKey:@"depAirport"];/// 起飞机场
    [parameter setObject:self.ticketModel.arv_airport forKey:@"arvAirport"];/// 到达机场
//
    [SCHttpTools postWithURLString:URLString parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXTicketModel *model = [TXTicketModel mj_objectWithKeyValues:result];
        if (model.errorcode==20000) {
            TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
            [self.navigationController popViewControllerAnimated:YES];
        }
        Toast(model.message);
        kHideMBProgressHUD(self.view);
    } failure:^(NSError *error) {
        TTLog(@"机票查询信息 -- %@", error);
        kHideMBProgressHUD(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.view showLoadingViewWithText:@"加载中..."];
}

- (void) submitOnClick{
    if (!self.isSelected) {
        Toast(@"请先选择机票");
        return;
    }
    if (kUserInfo.isValidation==2) {
        [self getBalance];
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

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [self.footerView addSubview:self.boxView];
    [self.footerView addSubview:self.titleLabel];
    [self.footerView addSubview:self.priceLabel];
    [self.footerView addSubview:self.priceTipsLabel];
    [self.footerView addSubview:self.payButton];
    
    [self initViewConstraints];
}

//// 购买之前先获取余额
- (void) getBalance{
    NSString *URLString = kHttpURL(@"customer/Balance");
    [SCHttpTools getWithURLString:URLString parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        kShowMBProgressHUD(self.view);
        TTUserDataModel *model = [TTUserDataModel mj_objectWithKeyValues:result];
        kHideMBProgressHUD(self.view);
        if (model.errorcode==20000) {
            TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
            /// 暂不调用支付密码界面
            kUserInfo.balance = model.data.balance;
            kUserInfo.vrcurrency = model.data.vrcurrency;
            [kUserInfo dump];
            TXPayPasswordViewController *viewController = [[TXPayPasswordViewController alloc] init];
            viewController.pageType = 4;
            viewController.tipsText = @"";
            viewController.integralText = kUserInfo.balance;
            viewController.delegate = self;
            [self presentPopupViewController:viewController animationType:TTPopupViewAnimationFade];
        }else{
            Toast(model.message);
        }
    } failure:^(NSError *error) {
        TTLog(@"余额查询信息 -- %@", error);
        kHideMBProgressHUD(self.view);
    }];
}

/// 关闭当前交易密码弹出的窗口
- (void)dismissedButtonClicked{
    [self dismissPopupViewControllerWithanimationType:TTPopupViewAnimationFade];
}


#pragma mark ---- 约束布局
- (void) initViewConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(kTabBarHeight));
    }];
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.footerView);
        make.height.equalTo(@(49));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerY.equalTo(self.boxView);
    }];
    [self.priceTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.boxView);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceTipsLabel.mas_right);
        make.centerY.equalTo(self.boxView);
    }];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self.boxView);
        make.width.equalTo(@(120));
    }];
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section<self.dataArray.count){
        TXTicketBookingTableViewCell *toolsTicket = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        toolsTicket.ticketModel = self.ticketModel;
        TicketPricesModel *priceModel = self.dataArray[indexPath.section];
        /// 文字颜色
        UIColor *textColor = HexString(@"#FC7E4C");
        NSInteger index,endIndex;
        index = priceModel.type.length+1;
        NSString *economyText = [NSString stringWithFormat:@"%@:￥%@",priceModel.type,priceModel.price];
        endIndex = economyText.length-index;
        toolsTicket.priceLabel.attributedText = [SCSmallTools setupTextColor:textColor currentText:economyText index:index endIndex:endIndex];
        
        toolsTicket.selectedIndexPath = indexPath;
        
        //当上下拉动的时候，因为cell的复用性，我们需要重新判断一下哪一行是打勾的
        if (_selectedIndexPath == indexPath) {
            toolsTicket.imagesSelected.image = kGetImage(@"使用中");
        }else {
            toolsTicket.imagesSelected.image = [Utils lz_imageWithColor:kClearColor];
        }
        toolsTicket.delegate=self;
        return toolsTicket;
    }else{
        if (indexPath.row==0) {
            TXTicketInfoTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierInfo forIndexPath:indexPath];
            tools.selectionStyle = UITableViewCellSelectionStyleNone;
            tools.ticketModel = self.ticketModel;
            return tools;
        }else{
            TXRolloutTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRollout forIndexPath:indexPath];
            tools.selectionStyle = UITableViewCellSelectionStyleNone;
            TXGeneralModel *generalModel = self.itemArray[indexPath.row];
            tools.titleLabel.text = generalModel.title;
            tools.textField.text = generalModel.imageText;
            tools.textField.enabled = NO;
            return tools;
        }
    }
    return [UITableViewCell new];
}


-(void)selectRowStr:(NSString *)cellStr indexPath:(NSIndexPath *)selectedIndexPath{
//    self.cellStr=cellStr;
    self.isSelected = YES;
    TicketPricesModel *priceModel = self.dataArray[selectedIndexPath.section];
    self.priceLabel.text = priceModel.price;

    TXTicketBookingTableViewCell *toolsed = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
    toolsed.imagesSelected.image = [Utils lz_imageWithColor:kClearColor];
    //记录当前选中的位置索引
    _selectedIndexPath = selectedIndexPath;
    //当前选择的打勾
    TXTicketBookingTableViewCell *tools = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    tools.imagesSelected.image = kGetImage(@"使用中");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section<self.dataArray.count){
         return 95;
    }else{
        if (indexPath.row==0) {
            return IPHONE6_W(70);
        }else{
            return IPHONE6_W(50);
        }
    }
    
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count+1;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section<self.dataArray.count) return 1;
    return self.itemArray.count;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----- getter/setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_tableView registerClass:[TXTicketBookingTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXRolloutTableViewCell class] forCellReuseIdentifier:reuseIdentifierRollout];
        [_tableView registerClass:[TXTicketInfoTableViewCell class] forCellReuseIdentifier:reuseIdentifierInfo];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _footerView;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _boxView;
}

- (NSMutableArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@"",@"姓名",@"身份证",@"手机号"];
        NSArray* classArr = @[@"",kUserInfo.realname,kUserInfo.idnumber,kUserInfo.phone];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:j];
            generalModel.imageText = [classArr lz_safeObjectAtIndex:j];
            [_itemArray addObject:generalModel];
        }
    }
    return _itemArray;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"0" color:HexString(@"#FD9141") font:kFontSizeMedium25];
    }
    return _priceLabel;
}

- (UILabel *)priceTipsLabel{
    if (!_priceTipsLabel) {
        _priceTipsLabel = [UILabel lz_labelWithTitle:@"￥:" color:HexString(@"#FD9141") font:kFontSizeMedium15];
    }
    return _priceTipsLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"订单总价" color:kTextColor204 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UIButton *)payButton{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _payButton.titleLabel.font = kFontSizeMedium15;
        _payButton.tag = 2;
        [_payButton setTitle:@"付款" forState:UIControlStateNormal];
        [_payButton setBackgroundImage:imageHexString(@"#00ADFF") forState:UIControlStateNormal];
        MV(weakSelf);
        [_payButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf submitOnClick];
        }];
    }
    return _payButton;
}

@end
