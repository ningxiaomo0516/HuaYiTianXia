//
//  TXTicketOrderViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/17.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTicketOrderViewController.h"
#import "TXTicketOrderModel.h"
#import "TXTicketOrderTableViewCell.h"

static NSString * const reuseIdentifier = @"TXTicketOrderTableViewCell";

@interface TXTicketOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SCNoDataView *noDataView;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation TXTicketOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"机票预订";
    [self initView];
    [self.view showLoadingViewWithText:@"加载中..."];
    self.pageSize = 20;
    self.pageIndex = 1;
    [self requestTicketOrderData];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) requestTicketOrderData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    [SCHttpTools postWithURLString:kHttpURL(@"aircraftorder/GetAircraftorder") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
            TXTicketOrderModel *model = [TXTicketOrderModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                [self.dataArray addObjectsFromArray:model.data.list];
            }else{
                Toast(model.message);
            }
            [self analysisData];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.view dismissLoadingView];
        }else{
            Toast(@"个人中心数据获取失败");
        }
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
        make.bottom.top.left.right.equalTo(self.view);
    }];
}
     
#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     TXTicketOrderTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
     tools.orderModel = self.dataArray[indexPath.section];
     return tools;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return IPHONE6_W(95);
 }
 
 // 多少个分组 section
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return self.dataArray.count;
 }
 
 /// 返回多少
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 1;
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
        [_tableView registerClass:[TXTicketOrderTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (SCNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[SCNoDataView alloc] initWithFrame:self.view.bounds
                                                imageName:@"c12_live_nodata"
                                            tipsLabelText:@"暂无数据哦~"];
        _noDataView.userInteractionEnabled = NO;
        [self.view insertSubview:_noDataView aboveSubview:self.tableView];
        [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.height.mas_equalTo(150);
        }];
    }
    return _noDataView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
