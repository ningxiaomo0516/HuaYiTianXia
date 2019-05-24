//
//  TXTeamTableView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/24.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTeamTableView.h"
#import "TXMineTeamTableViewCell.h"

static NSString * const reuseIdentifierTeam = @"TXTeamTableViewCell";

@interface TXTeamTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SCNoDataView *noDataView;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) UIViewController *vc;
@end

@implementation TXTeamTableView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style] ) {
        [self initTableView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame controller:(UIViewController *)vc{
    if (self = [super initWithFrame:frame]) {
        self.vc = vc;
        [self initTableView];
    }
    return self;
}

- (void) initTableView{
    self.pageSize = 20;
    self.pageIndex = 1;
    self.delegate = self;
    self.dataSource = self;
    [Utils lz_setExtraCellLineHidden:self];
    [self registerClass:[TXTeamTableViewCell class] forCellReuseIdentifier:reuseIdentifierTeam];

    // 下拉刷新
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将页码重新置为1
        [self requestTeamListData];
    }];
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;// 页码+1
        [self requestTeamListData];
    }];
    [self requestTeamListData];
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
                if (self.pageIndex==1) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:model.data.list];
            }
        }else{
            Toast(@"团队列表数据获取失败");
        }
        [self analysisData];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        [self dismissLoadingView];
        [self reloadData];
    } failure:^(NSError *error) {
        [self dismissLoadingView];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
    }];
}

- (void)analysisData {
    if (self.dataArray.count != 0) {
        self.noDataView.hidden = NO;
    }else {
        self.noDataView.hidden = YES;
    }
}

- (void) joinTeamButtonClick:(UIButton *)sender{
    [self.dataArray removeAllObjects];
    [self reloadData];
    
//    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
//    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
//    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
//    [SCHttpTools postWithURLString:kHttpURL(@"customerteam/teamList") parameter:parameter success:^(id responseObject) {
//        NSDictionary *result = responseObject;
//        if ([result isKindOfClass:[NSDictionary class]]) {
//            TeamDataModel *model = [TeamDataModel mj_objectWithKeyValues:result];
//            if (model.errorcode == 20000) {
//                if (self.pageIndex==1) {
//                    [self.dataArray removeAllObjects];
//                }
//                [self.dataArray addObjectsFromArray:model.data.list];
//            }
//        }else{
//            Toast(@"团队列表数据获取失败");
//        }
//        [self analysisData];
//        [self.mj_header endRefreshing];
//        [self.mj_footer endRefreshing];
//        [self dismissLoadingView];
//        [self reloadData];
//    } failure:^(NSError *error) {
//        [self dismissLoadingView];
//        [self.mj_header endRefreshing];
//        [self.mj_footer endRefreshing];
//    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamModel *teamModel = self.dataArray[indexPath.row];
    return teamModel.leaderName.length>0?IPHONE6_W(80):IPHONE6_W(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (SCNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[SCNoDataView alloc] initWithFrame:self.bounds
                                                imageName:@"c12_live_nodata"
                                            tipsLabelText:@"暂无数据哦~"];
        _noDataView.userInteractionEnabled = NO;
        [self.vc.view insertSubview:_noDataView atIndex:10];
        [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_offset(0);
            make.center.mas_equalTo(self);
            make.height.mas_equalTo(150);
        }];
    }
    return _noDataView;
}

@end
