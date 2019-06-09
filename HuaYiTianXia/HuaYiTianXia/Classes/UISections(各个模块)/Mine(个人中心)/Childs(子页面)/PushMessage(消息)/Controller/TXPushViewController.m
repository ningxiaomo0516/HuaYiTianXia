//
//  TXPushViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPushViewController.h"
#import "TXPushTableViewCell.h"
#import "TXSystemTableViewCell.h"
#import "TXPushMessageModel.h"
#import "SCDropDownMenuView.h"
#import "LZOptionSelectView.h"
#import "TXMessageChildViewController.h"
#import "TXWebViewController.h"
#import "TXMessageChildAdsViewController.h"

static NSString * const reuseIdentifier = @"TXPushTableViewCell";
static NSString * const reuseIdentifiers = @"TXSystemTableViewCell";
@interface TXPushViewController ()<UITableViewDelegate,UITableViewDataSource,SCDropDownMenuViewDelegate>
{
    NSMutableArray *listArray;  // 快捷聊天数组
}
@property (nonatomic, strong) LZOptionSelectView *cellView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;
/// 消息类型
@property (nonatomic, assign) NSInteger messageType;
@end

@implementation TXPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = @"消息";
    self.pageSize = 20;
    self.pageIndex = 1;
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将页码重新置为1
        self.pageIndex = 1;
        self.messageType==0 ? [self isReloadData] : [self isLoadData];
    }];
    /// 上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;// 页码+1
        self.messageType==0 ? [self isReloadData] : [self isLoadData];
    }];
    
    [kNotificationCenter addObserver:self selector:@selector(receiveNotification:) name:@"dealwithSystemPushMessage" object:nil];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self analysisData];
    }else{
        [self.view showLoadingViewWithText:@"加载中..."];
        [self isReloadData];
    }
}

- (void)receiveNotification:(NSNotification *)infoNotification {
    NSDictionary *resultDic = [infoNotification userInfo];
    NSString *kid = [resultDic lz_objectForKey:@"info"];
    NSString *messageType = [resultDic lz_objectForKey:@"messageType"];
    PushMessageModel *messageModel = [[PushMessageModel alloc] init];
    messageModel.outID = kid.integerValue;
    if (messageType.integerValue==2||messageType.integerValue==3) { //// 拼接公告地址
        [self jumpPushChildVC:messageModel messageType:23];
    }else if (messageType.integerValue==5) {/// 新闻
        [self jumpPushChildVC:messageModel messageType:5];
    }
}

- (void) jumpPushChildVC:(PushMessageModel *)messageModel messageType:(NSInteger) messageType{
    if (messageType==23) {
        TXMessageChildViewController *vc = [[TXMessageChildViewController alloc] initPushMessageModel:messageModel];
        TTPushVC(vc);
    }else if(messageType==5){
        TXMessageChildAdsViewController *vc = [[TXMessageChildAdsViewController alloc] initPushMessageModel:messageModel];
        TTPushVC(vc);
    }
}

/// 首次加载或者下拉刷新
- (void) isReloadData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    [self loadMessageData:parameter];
}

/// 上啦加载更多
- (void) isLoadData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    [parameter setObject:@(self.messageType+1) forKey:@"status"];  // 消息类型
    [self loadMessageData:parameter];
}

- (void)menuView:(SCDropDownMenuView *)menu selectIndex:(SCIndexPatch *)index {
    TTLog(@"二级菜单默认-1 = index.row: %ld  \n 菜单 = index.column：%ld \n 一级菜单 = index.section： %ld", (long)index.row,(long)index.column,(long)index.section);
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    if (index.section!=0) {
        [parameter setObject:@(index.section+1) forKey:@"status"];  // 消息类型
    }
    kShowMBProgressHUD(self.view);
    [self loadMessageData:parameter];
}

- (void)menuView:(SCDropDownMenuView *)menu tfColumn:(NSInteger)column {
    TTLog(@"商家首页-- 点击的第几项菜单 - column: %ld", (long)column);
   
}

/// 点击右边菜单加载数据
- (void) didOnClick:(NSInteger) idx{
    self.messageType = idx;
    /// 点击筛选重置初始值
    self.pageSize = 20;
    self.pageIndex = 1;
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    if (idx!=0) {
        [parameter setObject:@(idx+1) forKey:@"status"];  // 消息类型
    }
    kShowMBProgressHUD(self.view);
    [self loadMessageData:parameter];
}

/// 请求数据接口
- (void) loadMessageData:(NSDictionary *)parameter{
    [SCHttpTools postWithURLString:kHttpURL(@"notice/noticePage") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXPushMessageModel *model = [TXPushMessageModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000) {
            TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
            if (self.pageIndex == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:model.data.list];
        }else{
            Toast(model.message);
        }
        [self analysisData];
//        self.tableView.tt_emptyView = [TTEmptyView emptyViewWithImagesText:@"noData"
//                                                                 titleText:@"暂无数据"
//                                                                detailText:@""];
        kHideMBProgressHUD(self.view);
        [self.tableView reloadData];
        [self.view dismissLoadingView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        TTLog(@"消息推送 -- %@", error);
        kHideMBProgressHUD(self.view);
        [self.view dismissLoadingView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

/// 无数据的情况下
- (void)analysisData {
    if (self.dataArray.count == 0) {
        self.noDataView.hidden = NO;
    }else {
        self.noDataView.hidden = YES;
    }
}

/// 初始化视图
- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    /**
    NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:@"全部", @"转出记录", @"转入记录", @"公告", @"系统通知", nil];
    NSMutableArray *sectioinData1 = [NSMutableArray arrayWithObjects:dataArray, nil];
    NSMutableArray *sectioinData2 = [NSMutableArray arrayWithObjects:@[], @[], @[], @[], nil];
    SCDropDownMenuView *menu = [[SCDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) firstArray:sectioinData1 secondArray:sectioinData2];
    menu.delegate = self;
    menu.separatorColor = kColorWithRGB(221, 221, 221);
    menu.bottomLineView.hidden = YES;
    menu.cellSelectBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    menu.ratioLeftToScreen = 0.35;
    [self.view addSubview:menu];
    /// 风格
    menu.menuStyleArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:SCDropDownMenuStyleTableView], nil];
    */
    listArray = [NSMutableArray array];
    NSArray *mbArray = @[@"全部", @"转出记录", @"转入记录", @"公告", @"系统通知"];
    for (NSInteger i = 0; i < mbArray.count; i++) {
        [listArray addObject:[NSString stringWithFormat:@"%@",mbArray[i]]];
    }
    _cellView = [[LZOptionSelectView alloc] initOptionView];
    UIImage *rightImg = kGetImage(@"c51_plus_add");
    rightImg = [rightImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:rightImg
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(didTapShareButton:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/// 点击右上角的加号弹出菜单选项
- (void)didTapShareButton:(UIBarButtonItem *)barButtonItem {
    [self setDefaultCell];
    _cellView.backColor = [UIColor blackColor];
    _cellView.vhShow = NO;
    _cellView.edgeInsets = UIEdgeInsetsMake(64, 10, 10, 5);
    _cellView.optionType = LZOptionSelectViewTypeArrow;
    [_cellView showTapPoint:CGPointMake(kScreenWidth-IPHONE6_W(27), self.navigationController.navigationBar.bottom)
                  viewWidth:100
                  direction:LZOptionSelectViewTop];
}

/** 设置Cell(竖屏) */
- (void)setDefaultCell {
    WEAK(weaklistArray, listArray);
    WEAK(weakSelf, self);
    _cellView.canEdit = NO;
    _cellView.cornerRadius = 5.0;
    _cellView.isScrollEnabled = NO;
    [_cellView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PopupTableViewCell"];
    _cellView.cell = ^(NSIndexPath *indexPath){
        UITableViewCell *cell = [weakSelf.cellView dequeueReusableCellWithIdentifier:@"PopupTableViewCell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",weaklistArray[indexPath.row]];
        cell.textLabel.textColor = kWhiteColor;
        cell.textLabel.font = [UIFont fontWithName:@".PingFangSC-Regular" size:13];;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        return cell;
    };
    _cellView.optionCellHeight = ^{
        return 35.f;
    };
    _cellView.rowNumber = ^(){
        return (NSInteger)weaklistArray.count;
    };
    _cellView.selectedOption = ^(NSIndexPath *indexPath){
        [weakSelf didOnClick:indexPath.row];
    };
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PushMessageModel *messageModel = self.dataArray[indexPath.row];
    // 2：转出记录 3：转入记录 4：后台公告 5：通知
//    if (messageModel.messageType==2||messageModel.messageType==3||messageModel.messageType==5) {
        TXSystemTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifiers forIndexPath:indexPath];
        tools.messageModel = messageModel;
        return tools;
//    }else{
//        TXPushTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
//        tools.titleLabel.text = messageModel.title;
//        tools.contenLabel.text = messageModel.content;
//        tools.dateLabel.text = messageModel.datetime;
//        return tools;
//    }
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PushMessageModel *messageModel = self.dataArray[indexPath.row];
    /// 2：转出记录 3：转入记录 4：后台公告 5：通知
    ///    status等于2或者3，使用原生转账页面，需要请求接口
    ///    status等于4，使用H5页面，拼接地址
    ///    status等于5，使用原生页面，标题、内容、时间
    if (messageModel.messageType==2||messageModel.messageType==3) {
        [self jumpPushChildVC:messageModel messageType:23];
    }else if(messageModel.messageType==4){
        TXWebViewController *vc = [[TXWebViewController alloc] init];
        vc.title = @"新闻详情";
        NSString *outID = [NSString stringWithFormat:@"%ld",(long)messageModel.outID];
        vc.webUrl = kAppendH5URL(DomainName, PushDetailsH5, outID);
        TTPushVC(vc);
    }else if(messageModel.messageType==5){
        [self jumpPushChildVC:messageModel messageType:5];
    }
    if (messageModel.hasRead==0) {
        [self sendHasReadMessageRequest:messageModel indexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) sendHasReadMessageRequest:(PushMessageModel *) messageModel indexPath:(NSIndexPath *) indexPath{
    NSMutableArray *parameterArray = [[NSMutableArray alloc] init];
    [parameterArray addObject:messageModel.kid];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:parameterArray forKey:@"ids"];
    [SCHttpTools postWithURLString:kHttpURL(@"notice/insertNoticeRead") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TTLog(@"不做任何提示---%@",result);
        /// 修改已读状态
        if (messageModel.hasRead==0) messageModel.hasRead = 1;
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSError *error) {
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXPushTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXSystemTableViewCell class] forCellReuseIdentifier:reuseIdentifiers];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (void)dealloc{
    [kNotificationCenter removeObserver:self];
}

@end
