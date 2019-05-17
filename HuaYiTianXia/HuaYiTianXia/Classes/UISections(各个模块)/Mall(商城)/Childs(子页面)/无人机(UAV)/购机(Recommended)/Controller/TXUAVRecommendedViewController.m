//
//  TXUAVRecommendedViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXUAVRecommendedViewController.h"
#import "TXUAVRecommendedTableViewCell.h"
#import "TXMallUAVModel.h"
#import "TXSignatureView.h"
#import "TXUAVChildRecommendedViewController.h"
#import "TTSortButton.h"

NSInteger const SortButtonBeginTag = 1000;
static NSString * const reuseIdentifier = @"TXUAVRecommendedTableViewCell";
@interface TXUAVRecommendedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SCNoDataView *noDataView;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageType;
/// 画板签字
@property (nonatomic, strong) TXSignatureView *signatureView;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger sortType;
@end

@implementation TXUAVRecommendedViewController
- (id)initParameter:(NSDictionary *)parameter{
    if ( self = [super init] ){
        self.pageType = [parameter[@"pageType"] integerValue];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initView];
    self.pageSize = 20;
    self.pageIndex = 1;
    self.sortType = 1;
    self.title = @"选择飞机";
    [self.view showLoadingViewWithText:@"加载中..."];
    [self requestData];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将页码重新置为1
        self.pageIndex = 1;
        [self requestData];
    }];
    
    /// 上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;// 页码+1
        [self requestData];
    }];
    self.signatureView = [[TXSignatureView alloc] init];
    [self.view addSubview:[self.signatureView initSignatureView]];
    
    TXSignatureView *signatureView = [[TXSignatureView alloc] init];
    [self.signatureView addSubview:signatureView];
    signatureView.frame = CGRectMake(0, kScreenHeight/3, kScreenWidth, kScreenHeight - kScreenHeight/3);
}

- (void) requestData{
    
    /// 分类ID 1:购机  2:体验 3:活动;
    /// 查询排序方式 1:销量降序 2:销量升序 3:价格降序 4:价格升序 5:新品降序 6:新品升序
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    [parameter setObject:@(self.pageType) forKey:@"type"];  // 每页条数
    [parameter setObject:@(self.sortType) forKey:@"sortType"];  // 每页条数
    [SCHttpTools postWithURLString:kHttpURL(@"flightproduct/flightProductPage") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXMallUAVModel *model = [TXMallUAVModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                if (self.pageIndex==1) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:model.data.list];
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"我的团队数据获取失败");
        }
        [self analysisData];
        [self.view dismissLoadingView];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(40));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXUAVRecommendedTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.listModel = self.dataArray[indexPath.row];
    return tools;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(120);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self.signatureView addAnimate];
    MallUAVListModel *listModel = self.dataArray[indexPath.row];
    TXUAVChildRecommendedViewController *vc = [[TXUAVChildRecommendedViewController alloc] initListModel:listModel];
    vc.title = @"商品详情";
    TTPushVC(vc);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXUAVRecommendedTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kTableViewInSectionColor;
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

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView lz_viewWithColor:kWhiteColor];
        NSArray *titleArray = @[@"热门", @"价格", @"新品"];
        NSMutableArray *buttonArray = [NSMutableArray array];
        for (int i = 0; i < titleArray.count; i++) {
            TTSortButton *button = [[TTSortButton alloc] init];
            [_headerView addSubview:button];
            button.buttonTitle = titleArray[i];
            button.tag = SortButtonBeginTag + i;
            MV(weakSelf)
            [button lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                [weakSelf sortButtonClicked:button dataArray:titleArray];
            }];
            [buttonArray addObject:button];
            /// 默认选中第一个
            button.selected = (i==0)?YES:NO;
            /// 默认降序
            button.hasAscending = NO;
        }
        
        // 按钮等宽依次排列
        [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
    }
    return _headerView;
}

/// 排序
- (void) sortButtonClicked:(TTSortButton *) sender dataArray:(NSArray*)dataArray{
    for (int i = 0; i < dataArray.count; i++) {
        TTSortButton *button = [self.headerView viewWithTag:(SortButtonBeginTag + i)];
        button.selected = (button.tag == sender.tag);
    }
    NSInteger idx = sender.tag - SortButtonBeginTag;
    TTLog(@"第%ld个按钮点击，状态：%@", (long)(idx), sender.isAscending ? @"升序" : @"降序");
    //    查询排序方式 1:销量降序; 2:销量升序; 3:价格降序; 4:价格升序; 5:新品降序;6:新品升序
    
    
    /// sender.isAscending 正反序反着用就对了
    switch (idx) {
        case 0:
            self.sortType = sender.isAscending?1:2;
            [self requestData];
            break;
        case 1:
            self.sortType = sender.isAscending?3:4;
            [self requestData];
            break;
        case 2:
            self.sortType = sender.isAscending?5:6;
            [self requestData];
            break;
        default:
            break;
    }
}
@end
