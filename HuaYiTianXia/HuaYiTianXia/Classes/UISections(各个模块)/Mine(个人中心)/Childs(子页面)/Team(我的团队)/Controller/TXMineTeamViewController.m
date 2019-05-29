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
#import "TXMineTeamSectionView.h"
/// 通讯录搜索
#import "LZChineseSort.h"
#import "LZPinYinSearch.h"
#import "NSString+LZPinYin.h"

static NSString * const reuseIdentifierMineTeam = @"TXMineTeamTableViewCell";
static NSString * const reuseIdentifierTeam = @"TXTeamTableViewCell";

@interface TXMineTeamViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>
@property (strong, nonatomic) UISearchController    *searchController;
@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) TXTeamTableView       *teamTableView;
@property (nonatomic, strong) UIView                *headerView;

/** <排序前的整个数据源> */
@property (strong, nonatomic) NSMutableArray        *dataArray;
/** <排序后的整个数据源> */
@property (strong, nonatomic) NSDictionary          *letterResultDictionary;
/** <索引数据源> */
@property (strong, nonatomic) NSArray               *indexArray;

/** <搜索结果排序前的整个数据源> */
@property (strong, nonatomic) NSMutableArray        *searchResultsArray;
/** <搜索结果排序后的整个数据源> */
@property (strong, nonatomic) NSDictionary          *searchResultsDictionary;
/** 搜索结果索引数据源 */
@property (strong, nonatomic) NSArray               *searchResultsIndexArray;
// 被搜索的字符串
@property (copy, nonatomic) NSString                *searchText;

/// 每页多少数据
@property (nonatomic, assign) NSInteger             pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger             pageIndex;

@property (nonatomic, strong) UILabel               *titleLable;
@property (nonatomic, strong) UILabel               *subtitleLable;


@end

@implementation TXMineTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageSize = 20;
    self.pageIndex = 1;
    [self initView];
    [self requestTeamData];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestTeamData];
    }];

    self.title = @"团队成员";
    
    // 1.设置右侧索引字体颜色
    self.tableView.sectionIndexColor = HexString(@"#808080");
    // 2.设置右侧索引背景色
    self.tableView.sectionIndexBackgroundColor = kClearColor;
    self.tableView.tableHeaderView = self.headerView;
}

- (void) reminderData{
    [self requestTeamData];
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void) requestTeamData{
    [self.view showLoadingViewWithText:@"加载中..."];
    [SCHttpTools postWithURLString:kHttpURL(@"customerteam/teamMember") parameter:@{} success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXMineTeamModel *model = [TXMineTeamModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                if (model.data.list.count>0) {
                    [self.dataArray removeAllObjects];
                    /// 对数据的处理
                    [self processData:model.data];
                    self.title = @"团队成员";
                }else{
                    self.teamTableView.hidden = NO;
                    self.title = @"加入团队";
                }
            }else{
                Toast(model.message);
                [self.view dismissLoadingView];
            }
        }else{
            Toast(@"我的团队数据获取失败");
            [self.view dismissLoadingView];
        }
        [self.view dismissLoadingView];
        [self.tableView.mj_header endRefreshing];
        self.tableView.hidden = NO;
        self.loadFailedView.hidden = YES;
    } failure:^(NSError *error) {
        [self.view dismissLoadingView];
        [self.tableView.mj_header endRefreshing];
        self.loadFailedView.hidden = NO;
    }];
}

- (void) processData:(MineTeamDataModel *)model{
    NSString *titleText = [NSString stringWithFormat:@"%@(%ld人)",model.teamName,model.list.count];
    self.titleLable.text = titleText;
    NSString *subtitleText = [NSString stringWithFormat:@"投保总金额:%@元",[Utils isNull:model.money]];
    self.subtitleLable.text = subtitleText;
    
    /// 所有的数据，没分组
    [self.dataArray addObjectsFromArray:model.list];
    /// 通讯录分组，乱序的
    self.letterResultDictionary = [LZChineseSort sortAndGroupForArray:self.dataArray PropertyName:@"name"];
    /// 抽取排序，A，B，C
    self.indexArray = [LZChineseSort sortForStringAry:[self.letterResultDictionary allKeys]];
    
    /// 刷新操作
    [self.view dismissLoadingView];
    [self.tableView reloadData];
}

/// 解决搜索结果tableView向上偏移20px
- (void)viewDidLayoutSubviews {
    if(self.searchController.active) {
        CGFloat top = 8 + kSafeAreaBottomHeight;
        [self.tableView setFrame:CGRectMake(0, top, kScreenWidth, self.view.height - top)];
    }else {
        self.tableView.frame = self.view.bounds;
    }
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    TXMineTeamTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMineTeam forIndexPath:indexPath];
    //获得对应的PVTongxunluModel对象<替换为你自己的model对象>
    if (!self.searchController.active) {
        NSArray *value = [self.letterResultDictionary objectForKey:[self.indexArray lz_safeObjectAtIndex:section]];
        tools.teamModel = [value lz_safeObjectAtIndex:row];
    }else{
        NSArray *value = [self.searchResultsDictionary objectForKey:[self.searchResultsIndexArray lz_safeObjectAtIndex:section]];
        tools.teamModel = [value lz_safeObjectAtIndex:row];
    }
    return tools;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.searchController.active) {
        return self.indexArray.count;
    }else {
        return self.searchResultsIndexArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.searchController.active) {
        NSArray *value = [self.letterResultDictionary objectForKey:[self.indexArray lz_safeObjectAtIndex:section]];
        return value.count;
    }else {
        NSArray *value = [self.searchResultsDictionary objectForKey:[self.searchResultsIndexArray lz_safeObjectAtIndex:section]];
        return value.count;
    }
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSUInteger row = [indexPath row];
//    NSUInteger section = [indexPath section];
    
    if (!self.searchController.active) {
//        NSArray *value = [self.letterResultDictionary objectForKey:[self.indexArray lz_safeObjectAtIndex:section]];
//        _tongxunluModel = value[row];
    }else{
//        NSArray *value = [self.searchResultsDictionary objectForKey:[self.searchResultsIndexArray lz_safeObjectAtIndex:section]];
//        _tongxunluModel = value[row];
    }
    //    self.searchController.active = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// UITableView在Plain类型下，HeaderView和FooterView不悬浮和不停留的方法
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView lz_viewWithColor:kTableViewInSectionColor];
}

// UITableView在Plain类型下，HeaderView和FooterView不悬浮和不停留的方法viewForHeaderInSection
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TXMineTeamSectionView *sectionView = [[TXMineTeamSectionView alloc] init];
    if (!self.searchController.active) {
        sectionView.labelTitle.text = [self.indexArray lz_safeObjectAtIndex:section];
    }else {
        sectionView.labelTitle.text = [self.searchResultsIndexArray lz_safeObjectAtIndex:section];
    }
    return sectionView;
}

//section右侧index数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (!self.searchController.active) {
        return self.indexArray;
    }else {
        return nil;
    }
}

//  点击右侧索引表项时调用 索引与section的对应关系
//  自定义索引与数组的对应关系 (响应点击索引时的委托方法) //索引列点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

/// 判断输入的是字符串还是数字
- (BOOL) deptNumInputShouldNumber:(NSString *)str{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self updateSearchResultsForSearchController:self.searchController];
}

#pragma mark - UISearchResultsUpdating - UISearchDelegate
- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    //  清空搜索结果
    [self.searchResultsArray removeAllObjects];
    NSArray *searchArray = [NSArray new];
    //对排序好的数据进行搜索
    searchArray = [LZChineseSort getAllValuesFromDictionary:_letterResultDictionary];
    
    if (searchController.searchBar.text.length == 0) {
        [self.searchResultsArray addObjectsFromArray:searchArray];
        // 根据搜索结果中的数据进行name再次排序
        self.searchResultsDictionary = [LZChineseSort sortAndGroupForArray:self.searchResultsArray PropertyName:@"name"];
        self.searchResultsIndexArray = [LZChineseSort sortForStringAry:[self.searchResultsDictionary allKeys]];
    } else {
        NSString *parameterStr = [NSString new];
        // 被搜索的字符串
        self.searchText = searchController.searchBar.text;
        
        // 判断是数字还是字符串
        BOOL isNum = [self deptNumInputShouldNumber:self.searchText];
        if (isNum) {
            // 根据电话号码进行搜索(tel)
            parameterStr = @"mobile";
        }else{
            // 根据姓名进行搜索(name)
            parameterStr = @"name";
        }
        
        // 根据设置的参数进行搜索(name或mobile)
        searchArray = [LZPinYinSearch searchWithOriginalArray:searchArray andSearchText:self.searchText andSearchByPropertyName:parameterStr];
        // 将搜索的数据放到数组
        [self.searchResultsArray addObjectsFromArray:searchArray];
        // 根据搜索结果中的数据进行name再次排序
        self.searchResultsDictionary = [LZChineseSort sortAndGroupForArray:self.searchResultsArray PropertyName:@"name"];
        self.searchResultsIndexArray = [LZChineseSort sortForStringAry:[self.searchResultsDictionary allKeys]];
    }
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXMineTeamTableViewCell class] forCellReuseIdentifier:reuseIdentifierMineTeam];
        [_tableView registerClass:[TXTeamTableViewCell class] forCellReuseIdentifier:reuseIdentifierTeam];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,IPHONE6_W(15),0,0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.backgroundColor = kTableViewInSectionColor;
    }
    return _tableView;
}

- (TXTeamTableView *)teamTableView{
    if (!_teamTableView) {
        _teamTableView = [[TXTeamTableView alloc] initWithFrame:self.view.bounds controller:self];
        _teamTableView.hidden = YES;
        MV(weakSelf)
        _teamTableView.typeBlock = ^(TeamModel * _Nonnull teamModel) {
            weakSelf.teamTableView.hidden = YES;
            [weakSelf.view showLoadingViewWithText:@"加载中..."];
            [weakSelf requestTeamData];
        };
        [self.view addSubview:_teamTableView];
    }
    return _teamTableView;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.placeholder = @"请输入您想搜索的成员";
        //改变取消按钮字体颜色
        UIColor *color = self.navigationController.navigationBar.barTintColor;
        _searchController.searchBar.barTintColor = color;
        [_searchController.searchBar setBackgroundImage:imageColor(color)];
        UITextField *searchField=[_searchController.searchBar valueForKey:@"searchField"];
        searchField.backgroundColor = kColorWithRGB(246, 247, 251);
        searchField.font = kFontSizeMedium14;
        searchField.textColor = kTextColor170;
        _searchController.searchBar.contentMode = UIViewContentModeCenter;
        self.definesPresentationContext = YES;
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView lz_viewWithColor:kTableViewInSectionColor];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 96);
        [_headerView addSubview:self.searchController.searchBar];
        UIView *footer = [UIView lz_viewWithColor:kWhiteColor];
        [_headerView addSubview:footer];
        MV(weakSelf)
        [footer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(weakSelf.headerView);
            make.height.equalTo(@(40));
        }];
        
        UILabel *titleLable = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        [footer addSubview:titleLable];
        UILabel *subtitleLable = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        [footer addSubview:subtitleLable];
        self.titleLable = titleLable;
        self.subtitleLable = subtitleLable;
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.centerY.equalTo(footer);
        }];
        [subtitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(footer.mas_right).offset(-15);
            make.centerY.equalTo(footer);
        }];
    }
    return _headerView;
}

/** <排序前的整个数据源> */
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

/** <排序后的整个数据源> */
- (NSDictionary *)letterResultDictionary{
    if (!_letterResultDictionary) {
        _letterResultDictionary = [[NSDictionary alloc] init];
    }
    return _letterResultDictionary;
}

/** <索引数据源> */
- (NSArray *)indexArray{
    if (!_indexArray) {
        _indexArray = [[NSArray alloc] init];
    }
    return _indexArray;
}

/** <搜索结果排序前的整个数据源> */
- (NSMutableArray *)searchResultsArray{
    if (!_searchResultsArray) {
        _searchResultsArray = [[NSMutableArray alloc] init];
    }
    return _searchResultsArray;
}

/** <搜索结果排序后的整个数据源> */
- (NSDictionary *)searchResultsDictionary{
    if (!_searchResultsDictionary) {
        _searchResultsDictionary = [[NSDictionary alloc] init];
    }
    return _searchResultsDictionary;
}

/** 搜索结果索引数据源 */
- (NSArray *)searchResultsIndexArray{
    if (!_searchResultsIndexArray) {
        _searchResultsIndexArray = [[NSArray alloc] init];
    }
    return _searchResultsIndexArray;
}

@end
