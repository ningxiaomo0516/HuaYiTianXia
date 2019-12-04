//
//  YKTicketOrderViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/10.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKTicketOrderViewController.h"
#import "YKTicketOrderModel.h"
#import "YXTicketOrderTableViewCell.h"
#import "YKTicketOrderChildViewController.h"

@interface YKTicketOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation YKTicketOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self.view showLoadingViewWithText:@"加载中..."];
    self.pageSize = 20;
    self.pageIndex = 1;
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self.dataArray removeAllObjects];
        [self requestTicketOrderData];
    }];
    
    /// 上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;// 页码+1
        [self requestTicketOrderData];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestTicketOrderData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) requestTicketOrderData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    [SCHttpTools getWithURLString:kHttpURL(@"flight-order/flightOrderPage") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        YKTicketOrderModel *model = [YKTicketOrderModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000) {
            TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
            [self.dataArray addObjectsFromArray:model.data.records];
        }else{
            Toast(model.message);
        }
        [self analysisData];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.view dismissLoadingView];
    }];
}

- (void)analysisData {
    if (self.dataArray.count == 0) {
        self.noDataView.hidden = NO;
    }else {
        self.noDataView.hidden = YES;
    }
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
    }];
}

- (void) NextBtnClick:(UIButton *)sender{
    TicketListModel *model = self.dataArray[sender.tag];
    YKTicketOrderChildViewController *vc = [[YKTicketOrderChildViewController alloc] initTicketOrderModel:model];
    TTPushVC(vc);
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXTicketOrderTableViewCell *tools = [YXTicketOrderTableViewCell cellWithTableViewCell:tableView forIndexPath:indexPath];
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
    TicketListModel *model = self.dataArray[indexPath.row];

    //@"成都前往 北京";
    tools.dep_arv_city_label.text = [NSString stringWithFormat:@"%@前往 %@",model.segment.depCityCName,model.segment.arrCityCName];
    
    NSArray *dateArray = [model.segment.depDate componentsSeparatedByString:@" "];
    NSArray *dateArray1 = [dateArray[0] componentsSeparatedByString:@"-"];
    tools.dep_date_label.text = [NSString stringWithFormat:@"%@月%@日",dateArray1[1],dateArray1[2]];
    /// 根据当前日期转换星期
    tools.dep_week_label.text = [SCSmallTools tt_weekdayStringFromDate:dateArray[0]];
//    tools.dep_week_label.text = @"星期一";
    
    tools.flightNo_label.text = model.segment.flightNo;//@"8L556656";
    tools.depCity_arvCity_label.text = [NSString stringWithFormat:@"%@-%@",model.segment.depCityCName,model.segment.arrCityCName];//@"成都-北京";
    
    tools.dep_airport_label.text = [NSString stringWithFormat:@"%@ %@",model.depCname,model.depJetquay];//@"双流机场T1";
    tools.arv_airport_label.text = [NSString stringWithFormat:@"%@ %@",model.arrCname,model.arrJetquay];;//@"首都T3";
    
    switch (model.payFlag.integerValue) {
        case 0:
            tools.trip_status_label.text = @"待支付";
            tools.imagesView_b.image = kGetImage(@"行程_状态_未出票");
            break;
        case 1:
//            tools.trip_status_label.text = @"支付成功";
            tools.trip_status_label.text = @"等待出票";
            tools.imagesView_b.image = kGetImage(@"行程_状态_未出票");
            break;
        case 2:
            tools.trip_status_label.text = @"等待出票";
            tools.imagesView_b.image = kGetImage(@"行程_状态_未出票");
            break;
        case 3:
            tools.trip_status_label.text = @"出票成功";
            tools.imagesView_b.image = kGetImage(@"行程_状态_已出票");
            break;
        case 4:
            tools.trip_status_label.text = @"出票失败";
            tools.imagesView_b.image = kGetImage(@"行程_状态_未出票");
            break;
        default:
            break;
    }
    tools.dep_time_label.text = @"09:30";
    tools.arv_time_label.text = @"11:30";
    tools.nextButton.tag = indexPath.row;
    [tools.nextButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self NextBtnClick:tools.nextButton];
    }];
    return tools;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 257;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
        [_tableView registerClass:[YXTicketOrderTableViewCell class] forCellReuseIdentifier:[YXTicketOrderTableViewCell reuseIdentifier]];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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


@end
