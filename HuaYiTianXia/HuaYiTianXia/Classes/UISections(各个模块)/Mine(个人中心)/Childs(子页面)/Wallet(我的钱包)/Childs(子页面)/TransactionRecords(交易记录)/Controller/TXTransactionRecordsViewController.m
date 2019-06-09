//
//  TXTransactionRecordsViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTransactionRecordsViewController.h"
#import "TXTransactionRecordsTableViewCell.h"
#import "TXWalletModel.h"

static NSString * const reuseIdentifier = @"TXTransactionRecordsTableViewCell";

@interface TXTransactionRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,TTTableViewRequestDelegate>
@property (nonatomic, strong) TTBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation TXTransactionRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageSize = 20;
    self.pageIndex = 1;
    [self initView];
    [self loadTransactionRecordsData];
}

- (void)tt_tableView:(TTBaseTableView *)tt_tableView requestFailed:(NSError *)error{
    TTLog(@"error --- %@",error);
}

/// 处理接口返回数据
- (void)tt_tableView:(TTBaseTableView *)tt_tableView isPullDown:(BOOL)PullDown result:(id)result{
    TXWalletModel *model = [TXWalletModel mj_objectWithKeyValues:result];
    if (model.errorcode == 20000) {
        if (PullDown) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:model.data.list.mutableCopy];
        [self.tableView reloadData];
    }else{
        Toast(model.message);
    }
    //处理返回的SuccessData 数据之后刷新table
    [self.tableView reloadData];
}

/// 获取交易记录
- (void) loadTransactionRecordsData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    self.tableView.requestType = kHttpPost;
    [self.tableView setUpWithURLString:kHttpURL(@"transaction/UserTrans") parameter:parameter tempVC:self];
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
    TXTransactionRecordsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section ];
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
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(TTBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[TTBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXTransactionRecordsTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.requestDelegate = self;
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
