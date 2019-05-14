//
//  TXUAVExperienceViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXUAVExperienceViewController.h"
#import "TXUAVExperienceTableViewCell.h"
#import "TXCourseModel.h"
#import "TXUAVExperienceChildViewController.h"

static NSString * const reuseIdentifier = @"TXUAVExperienceTableViewCell";
@interface TXUAVExperienceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 总条数
@property (nonatomic, strong) NSMutableArray *totalSizeArray;
@property (nonatomic, strong) SCNoDataView *noDataView;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation TXUAVExperienceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.pageSize = 20;
    self.pageIndex = 1;
    self.title = @"培训课程";
    [self.view showLoadingViewWithText:@"加载中..."];
    [self requestPersonalCenterData];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将页码重新置为1
        self.pageIndex = 1;
        [self requestPersonalCenterData];
    }];
    
    /// 上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;// 页码+1
        [self requestPersonalCenterData];
    }];
}

- (void) requestPersonalCenterData{
    
    /// 分类ID 1:培训
    /// 查询排序方式 1:销量降序 2:销量升序 3:价格降序 4:价格升序 5:新品降序 6:新品升序
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    [parameter setObject:@(1) forKey:@"type"];  // 每页条数
    [SCHttpTools postWithURLString:kHttpURL(@"flighttrain/flightTrainPage") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXCourseModel *courseModel = [TXCourseModel mj_objectWithKeyValues:result];
            if (courseModel.errorcode == 20000) {
                if (self.pageIndex==1) {
                    [self.dataArray removeAllObjects];
                    [self.totalSizeArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:courseModel.data.list];
                for (CourseListModel *listModel in courseModel.data.list) {
                    if (listModel.flightcourse.count>0) {
                        [self.totalSizeArray addObject:listModel];
                    }
                }
            }else{
                Toast(courseModel.message);
            }
        }else{
            Toast(@"数据获取失败");
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
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXUAVExperienceTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!tools) {
        tools = (TXUAVExperienceTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil] objectAtIndex:0];
    }
    tools.listModel = self.totalSizeArray[indexPath.section];
    return tools;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.totalSizeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) return 0.001f;
    return 10.f;
}

// UITableView在Plain类型下，HeaderView和FooterView不悬浮和不停留的方法viewForHeaderInSection
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView lz_viewWithColor:kWhiteColor];
    headerView.frame = CGRectMake(0, 0, self.view.width, 0.001f);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(160);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseListModel *listModel = self.dataArray[indexPath.section];
    TXUAVExperienceChildViewController *vc = [[TXUAVExperienceChildViewController alloc] initCourseListModel:listModel];
    TTPushVC(vc);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (NSMutableArray *)totalSizeArray{
    if (!_totalSizeArray) {
        _totalSizeArray = [[NSMutableArray alloc] init];
    }
    return _totalSizeArray;
}
@end
