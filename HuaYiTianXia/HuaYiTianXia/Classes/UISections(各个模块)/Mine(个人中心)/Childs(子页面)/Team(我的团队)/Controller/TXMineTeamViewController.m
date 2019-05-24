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
#import "TXTeamTableView.h"

static NSString * const reuseIdentifierMineTeam = @"TXMineTeamTableViewCell";
static NSString * const reuseIdentifierTeam = @"TXTeamTableViewCell";

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

}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void) requestTeamData{ 
    [SCHttpTools postWithURLString:kHttpURL(@"customerteam/teamMember") parameter:@{} success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXMineTeamModel *model = [TXMineTeamModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                if (model.data.list.count>0) {
                    [self.dataArray addObjectsFromArray:model.data.list];
                    [self.view dismissLoadingView];
                    [self.tableView reloadData];
                }else{
                    self.listType = 1;
//                    /// 默认请求团队列表数据
//                    [self requestTeamListData];
//                    /// 上拉加载
//                    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//                        self.pageIndex++;// 页码+1
//                        [self requestTeamListData];
//                    }];
                    
                    
                    
                    TXTeamTableView *teamTableView = [[TXTeamTableView alloc] initWithFrame:self.view.bounds controller:self];
                    [self.view addSubview:teamTableView];
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
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    [SCHttpTools postWithURLString:kHttpURL(@"customerteam/teamList") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TeamDataModel *model = [TeamDataModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                if (self.pageIndex==1||self.listType==0) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:model.data.list];
            }
        }else{
            Toast(@"团队列表数据获取失败");
        }
        [self analysisData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.view dismissLoadingView];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.view dismissLoadingView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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

- (void) joinTeamButtonClick:(UIButton *)sender{
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listType==0) {
        TXMineTeamTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMineTeam forIndexPath:indexPath];
        tools.teamModel = self.dataArray[indexPath.row];
        return tools;
    }else{
        TXTeamTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTeam forIndexPath:indexPath];
        tools.teamModel = self.dataArray[indexPath.row];
        MV(weakSelf)
        [tools.joinButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf joinTeamButtonClick:tools.joinButton];
        }];
        NSInteger idx = indexPath.row+1;
        if (indexPath.row<3) {
            tools.imagesRanking.hidden = NO;
            tools.labelRanking.hidden = YES;
            NSString *imagesName = [NSString stringWithFormat:@"c77_icon_no%ld",idx];
            tools.imagesRanking.image = kGetImage(imagesName);
        }else{
            tools.labelRanking.hidden = NO;
            tools.imagesRanking.hidden = YES;
            tools.labelRanking.text = [NSString stringWithFormat:@"%ld",idx];
        }
        return tools;
    }
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
    if (self.listType==0) {
        return IPHONE6_W(60);
    }else{
        TeamModel *teamModel = self.dataArray[indexPath.row];
        return teamModel.leaderName.length>0?IPHONE6_W(80):IPHONE6_W(60);
    }
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
        [_tableView registerClass:[TXMineTeamTableViewCell class] forCellReuseIdentifier:reuseIdentifierMineTeam];
        [_tableView registerClass:[TXTeamTableViewCell class] forCellReuseIdentifier:reuseIdentifierTeam];
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
