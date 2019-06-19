//
//  TXLogisticViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/14.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXLogisticViewController.h"
#import "TXLogisticTableViewCell.h"
#import "TXLogisticProductCell.h"
#import "TXLogisticModel.h"

static NSString * const reuseIdentifier = @"TXLogisticTableViewCell";
static NSString * const reuseIdentifierProduct = @"TXLogisticProductCell";

@interface TXLogisticViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) OrderModel    *orderModel;
@property (nonatomic, strong) LogisticData  *logisticData;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView        *footerView;
@end

@implementation TXLogisticViewController
- (instancetype)initWithOrderModel:(OrderModel *)orderModel{
    if (self = [super init]) {
        _orderModel = orderModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = @"物流跟踪";
    [self.view showLoadingViewWithText:@"加载中..."];
    [self get_data];
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.right.equalTo(self.view);
    }];
}

- (void) get_data{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.orderModel.kid forKey:@"orderNo"];
    [parameter setObject:self.orderModel.abbreviation forKey:@"abbreviation"];
    [parameter setObject:self.orderModel.logisticsNo forKey:@"logisticsNo"];
    [SCHttpTools postWithURLString:kHttpURL(@"expresscompany/queryExpressInfo") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXLogisticModel *model = [TXLogisticModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000) {
            self.logisticData = model.data;
            self.logisticData.pro_title = self.orderModel.title;
            self.logisticData.pro_subtitle = self.orderModel.synopsis;
            self.logisticData.imageText = self.orderModel.coverimg;
            /// 倒序数组数据
            NSArray *arr = [[model.data.logisticInfo.list reverseObjectEnumerator] allObjects];
            [self.dataArray addObjectsFromArray:arr];
            [self.tableView reloadData];
            self.tableView.hidden = NO;
            if (model.data.logisticInfo.list.count==0) {
                self.tableView.tableFooterView = self.footerView;
            }
        }
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        [self.view dismissLoadingView];
    }];
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TXLogisticProductCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierProduct forIndexPath:indexPath];
        tools.logisticData = self.logisticData;
        return tools;
    }else{
        TXLogisticTableViewCell  *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        TracesList *tracesModel = self.dataArray[indexPath.row];
        tracesModel.state = self.logisticData.logisticInfo.State;
        tools.tracesModel = tracesModel;
        return tools;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) return IPHONE6_W(160);
    return UITableViewAutomaticDimension;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    return self.dataArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----- getter/setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        [_tableView registerClass:[TXLogisticTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXLogisticProductCell class] forCellReuseIdentifier:reuseIdentifierProduct];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 200;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.hidden = YES;
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
        _footerView = [UIView lz_viewWithColor:kClearColor];
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, self.view.height/3);
        UIView *boxView = [UIView lz_viewWithColor:kClearColor];
        boxView.frame = CGRectMake(0, 80, kScreenWidth, self.view.height/3);
        SCNoDataView *footerView = [[SCNoDataView alloc] initWithFrame:boxView.bounds
                                                             imageName:@"c12_live_nodata"
                                                         tipsLabelText:@"暂无数据哦~"];
        [boxView addSubview:footerView];
        [_footerView addSubview:boxView];
    }
    return _footerView;
}
@end
