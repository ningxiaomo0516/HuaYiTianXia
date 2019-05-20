//
//  TXProductViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXProductViewController.h"
#import "TXProductTableViewCell.h"
#import "TXOrderModel.h"
#import "TXWebViewController.h"

static NSString * const reuseIdentifier = @"TXProductTableViewCell";

@interface TXProductViewController ()<UITableViewDelegate,UITableViewDataSource,TTTableViewRequestDelegate>
@property (nonatomic, strong) TTBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation TXProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kRandomColor;
    self.pageSize = 20;
    self.pageIndex = 1;
    [self initView];
    [self requestData];
}


- (void)tt_tableView:(TTBaseTableView *)tt_tableView requestFailed:(NSError *)error{
    TTLog(@"error --- %@",error);
}

/// 处理接口返回数据
- (void)tt_tableView:(TTBaseTableView *)tt_tableView isPullDown:(BOOL)PullDown result:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        TXOrderModel *model = [TXOrderModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000) {
            if (PullDown) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:model.data.records.mutableCopy];
        }
    }
    //处理返回的SuccessData 数据之后刷新table
    [self.tableView reloadData];
}

/// 获取订单中心-产品列表数据
- (void) requestData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    //请求数据
    [self.tableView setUpWithURLString:kHttpURL(@"orderform/GetOrderPro") parameter:parameter tempVC:self];
}

//// 跳转查看合同
- (void) jumpWebViewController:(NSString *)kid{
    TXWebViewController *vc = [[TXWebViewController alloc] init];
    vc.title = @"农用植保合作协议";
    vc.webUrl = kAppendH5URL(DomainName, CooperationAgreementH5, kid);
    TTPushVC(vc);
}

- (void) initView{
    
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    //    [self.view showLoadingViewWithText:@"加载中..."];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXProductTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.orderModel = self.dataArray[indexPath.section];
    cell.lookContractBtn.tag = indexPath.section;
    [cell.lookContractBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        /// 查看合同
        [self jumpWebViewController:cell.orderModel.kid];
    }];
    return cell;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(110);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (TTBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[TTBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXProductTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.requestDelegate = self;
        _tableView.requestType = kHttpPost;
        _tableView.backgroundColor = kTableViewInSectionColor;
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
