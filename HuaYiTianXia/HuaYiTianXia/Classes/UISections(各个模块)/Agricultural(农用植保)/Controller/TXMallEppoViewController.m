//
//  TXMallEppoViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/10.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMallEppoViewController.h"
#import "TXMembersBannerView.h"
#import "TXEppoTableViewCell.h"
#import "TXNewsModel.h"
#import "TXMallGoodsDetailsViewController.h"

static NSString * const reuseIdentifier = @"TXEppoTableViewCell";

@interface TXMallEppoViewController ()<UITableViewDelegate,UITableViewDataSource,TTTableViewRequestDelegate>
@property (nonatomic, strong) TTBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TXMembersBannerView *bannerView;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation TXMallEppoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"农用植保";
    self.pageSize = 20;
    self.pageIndex = 1;
    [self initView];
    [self.view showLoadingViewWithText:@"加载中..."];
    [self requestData];
}

/// 获取订单中心-产品列表数据
- (void) requestData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    [parameter setObject:@(2) forKey:@"status"];  // 每页条数
    //请求数据
    [self.tableView setUpWithURLString:@"shopproduct/GetShopPro" parameter:parameter tempVC:self];
}

- (void)tt_tableView:(TTBaseTableView *)tt_tableView requestFailed:(NSError *)error{
    TTLog(@"error --- %@",error);
    [self.view dismissLoadingView];
}

/// 处理接口返回数据
- (void)tt_tableView:(TTBaseTableView *)tt_tableView isPullDown:(BOOL)PullDown result:(id)result{
    TXNewsArrayModel *model = [TXNewsArrayModel mj_objectWithKeyValues:result];
    if (model.errorcode == 20000) {
        if (PullDown) {
            self.bannerView.bannerArray = model.banners;
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:model.data.records.mutableCopy];
    }
    [self.view dismissLoadingView];
    //处理返回的SuccessData 数据之后刷新table
    [self.tableView reloadData];
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    self.tableView.tableHeaderView = self.bannerView;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXEppoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.recordsModel = self.dataArray[indexPath.section];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(225);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsRecordsModel *productModel = self.dataArray[indexPath.section];
    TXMallGoodsDetailsViewController *vc = [[TXMallGoodsDetailsViewController alloc] initMallProductModel:productModel];
    vc.pageType = 1;
    TTPushVC(vc);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(TTBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[TTBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXEppoTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
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

- (TXMembersBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[TXMembersBannerView alloc] init];
        _bannerView.backgroundColor = kTableViewInSectionColor;
        _bannerView.frame = CGRectMake(0, 0, kScreenWidth, IPHONE6_W(180));
    }
    return _bannerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
