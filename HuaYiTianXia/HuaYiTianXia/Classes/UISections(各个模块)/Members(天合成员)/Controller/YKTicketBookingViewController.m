//
//  YKTicketBookingViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/6.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKTicketBookingViewController.h"
#import "YKTicketBookingTableViewCell.h"
#import "YKTicketBookingHeaderView.h"
#import "YKBuyTicketViewController.h"
#import "YKAssuredServiceViewController.h"
#import "TXLoginViewController.h"

@interface YKTicketBookingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TicketModel *ticketModel;

@property (nonatomic, strong) YKTicketBookingHeaderView *headerView;

@end

@implementation YKTicketBookingViewController
- (id)initTicketModel:(TicketModel *)ticketModel{
    if ( self = [super init] ){
        self.ticketModel = ticketModel;
        for (SeatItems *seatModel in ticketModel.seatItems) {
            for (PricesModel *priceModel in seatModel.policys.priceDatas) {
                /**乘机人类型 1 成人 2 儿童 3 婴儿 暂不使用*/
               seatModel.crewType = priceModel.crewType;
                /**票面价*/
                seatModel.price = priceModel.price;
                /**单人结算价 (price*(1­ commisionPoint%)­ commisionMoney)不含税*/
                seatModel.settlement = priceModel.settlement;
                /**单人机建*/
                seatModel.airportTax = priceModel.airportTax;
                /**单人燃油费*/
                seatModel.fuelTax = priceModel.fuelTax;
                /**返点 0.1 =0.1%*/
                seatModel.commisionPoint = priceModel.commisionPoint;
                /**定额*/
                seatModel.commisionMoney = priceModel.commisionMoney;
                /**支付手续费*/
                seatModel.payFee = priceModel.payFee;
                /**是否换编码出票 1:原编码出票 2:需要换编码出票*/
                seatModel.isSwitchPnr = priceModel.isSwitchPnr;
                /**政策类型 BSP或者B2B*/
                seatModel.policyType = priceModel.policyType;
                /**出票效率*/
                seatModel.ticketSpeed = priceModel.ticketSpeed;
                [self.dataArray addObject:seatModel];
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    NSString *dateText = self.ticketModel.depDate;
    NSArray *dateArray = [dateText componentsSeparatedByString:@"-"];
    NSString *date = [NSString new];
    if (dateArray.count>2) {
        date = [NSString stringWithFormat:@"%@月%@日",dateArray[1],dateArray[2]];
    }
    NSString *weekText = [SCSmallTools tt_weekdayStringFromDate:dateText];
    self.title = [NSString stringWithFormat:@"%@ %@",date,weekText];
    self.ticketModel.dep_week = weekText;
    self.ticketModel.dep_date = date;
    self.ticketModel.dep_time = self.headerView.dep_timeLabel.text;
}


- (void) initView{
    
    NSArray *depTimeArray = [self.ticketModel.depTime componentsSeparatedByString:@" "];
    NSArray *arrTimeArray = [self.ticketModel.arrTime componentsSeparatedByString:@" "];

    self.headerView.dep_timeLabel.text = depTimeArray.count>1 ? depTimeArray[1]:@"00:00";
    self.headerView.arv_timeLabel.text = arrTimeArray.count>1 ? arrTimeArray[1]:@"00:00";
    
    self.headerView.dep_airportLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.ticketModel.depCname,self.ticketModel.depName,self.ticketModel.depJetquay];
    
    self.headerView.arv_airportLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.ticketModel.arrCname,self.ticketModel.arrName,self.ticketModel.arrJetquay];
    self.headerView.flightNoLabel.text = self.ticketModel.flightNo;
    self.headerView.planeTypeLabel.text = self.ticketModel.planeType;
    NSArray *distanceArray = [self.ticketModel.distance componentsSeparatedByString:@"."];
    NSString *distanceText = [NSString stringWithFormat:@"里程%@km",distanceArray[0]];
    self.headerView.distanceLabel.text = distanceText;
    if (self.ticketModel.meal.boolValue) {
        self.headerView.mealLabel.text = @"有餐食";
    }else{
        self.headerView.mealLabel.text = @"无餐食";
    }
    
    
    self.tableView.tableHeaderView = self.headerView;
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.right.equalTo(self.view);
    }];
}

- (void) reservationBtn:(NSIndexPath *)indexPath{
    if (!kUserInfo.isLogin) {
        TXLoginViewController *vc = [[TXLoginViewController alloc] init];
        LZNavigationController *navigation = [[LZNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navigation animated:YES completion:^{
            TTLog(@"登录界面");
        }];
        return;
    }
    SeatItems *model = self.dataArray[indexPath.row];
    YKBuyTicketViewController *vc = [[YKBuyTicketViewController alloc] initTicketModel:self.ticketModel seatItems:model];
    vc.title = [NSString stringWithFormat:@"%@ - %@",self.ticketModel.depCname,self.ticketModel.arrCname];
    TTPushVC(vc);
}

- (void) serviceBtnClick:(NSIndexPath *) indexPath{
    YKAssuredServiceViewController *vc = [[YKAssuredServiceViewController alloc] init];
    TTPushVC(vc);
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YKTicketBookingTableViewCell *tools = [YKTicketBookingTableViewCell cellWithTableViewCell:tableView forIndexPath:indexPath];
    SeatItems *model = self.dataArray[indexPath.row];
    tools.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    NSString *discountText = [NSString stringWithFormat:@"%0.2f",model.discount];
    NSArray *discountArray = [discountText componentsSeparatedByString:@"."];
    if (discountArray.count>1) {
        if ([discountArray[1] isEqualToString:@"00"]) {
            tools.discountLabel.text = [NSString stringWithFormat:@"惠选%@%@折",model.seatMsg,discountArray[0]];
        }else{
            tools.discountLabel.text = [NSString stringWithFormat:@"惠选%@%@折",model.seatMsg,discountText];
        }
    }else{
        tools.discountLabel.text = [NSString stringWithFormat:@"惠选%@%@折",model.seatMsg,discountText];
    }
    MV(weakSelf)
    tools.reservationBtn.tag = indexPath.row;
    [tools.reservationBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf reservationBtn:indexPath];
    }];
    [tools.fwButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf serviceBtnClick:indexPath];
    }];
    return tools;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self reservationBtn:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----- getter/setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_tableView registerClass:[YKTicketBookingTableViewCell class] forCellReuseIdentifier:[YKTicketBookingTableViewCell reuseIdentifier]];
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

- (YKTicketBookingHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YKTicketBookingHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 160);
    }
    return _headerView;
}
@end
