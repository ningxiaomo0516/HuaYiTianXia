//
//  TXMineTeamViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/23.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMineTeamViewController.h"
#import "TXMineTeamTableViewCell.h"
#import "TXMineTeamModel.h"

static NSString * const reuseIdentifier = @"TXMineTeamTableViewCell";
@interface TXMineTeamViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>
@property (strong, nonatomic) UISearchController    *searchController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SCNoDataView *noDataView;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;
/// 列表类型
@property (nonatomic, assign) NSInteger listType;
@end

@implementation TXMineTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /// 默认为0,我的团队数据 1:为团队列表数据
    self.listType = 0;
    self.pageSize = 20;
    self.pageIndex = 1;
    [self initView];
    [self.view showLoadingViewWithText:@"加载中..."];
    [self requestTeamData];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将页码重新置为1
        self.pageIndex = 1;
        if (self.listType==0) {
            [self requestTeamData];
        }else{
            
        }
    }];
    
    /// 当为团队列表时添加上拉刷新
    if (self.listType!=0) {
        /// 上拉加载
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.pageIndex++;// 页码+1
        }];
    }
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void) requestTeamData{
    [SCHttpTools postWithURLString:kHttpURL(@"customerteam/teamMember") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXMineTeamModel *model = [TXMineTeamModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                if (model.data.list.count>0) {
                    [self.dataArray addObjectsFromArray:model.data.list];
                    [self.view dismissLoadingView];
                    [self.tableView reloadData];
                }else{
                    /// 默认请求团队列表数据
                    [self requestTeamListData];
                }
            }else{
                Toast(model.message);
                [self.view dismissLoadingView];
            }
        }else{
            Toast(@"我的团队数据获取失败");
            [self.view dismissLoadingView];
        }
    } failure:^(NSError *error) {
        [self.view dismissLoadingView];
    }];
}

- (void) requestTeamListData{
    [SCHttpTools postWithURLString:kHttpURL(@"customerteam/teamMember") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXMineTeamModel *model = [TXMineTeamModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                if (self.pageIndex==1) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:model.data.list];
            }
        }else{
            Toast(@"团队列表数据获取失败");
        }
        [self analysisData];
        [self.view dismissLoadingView];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
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

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.placeholder = @"搜索";
        self.definesPresentationContext = YES;
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXMineTeamTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.teamModel = self.dataArray[indexPath.row];
    return tools;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXMineTeamTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,IPHONE6_W(15),0,0)];
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
@end
