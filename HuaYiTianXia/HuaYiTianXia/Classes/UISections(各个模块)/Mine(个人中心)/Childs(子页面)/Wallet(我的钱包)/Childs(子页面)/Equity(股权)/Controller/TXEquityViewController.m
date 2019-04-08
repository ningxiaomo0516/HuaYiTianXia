//
//  TXEquityViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXEquityViewController.h"
#import "TXEarningsTableViewCell.h"
#import "TXWalletModel.h"

static NSString * const reuseIdentifier = @"TXEarningsTableViewCell";

@interface TXEquityViewController ()<UITableViewDelegate,UITableViewDataSource,TTTableViewRequestDelegate>
@property (nonatomic, strong) TTBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;
/// 当前页
@property (nonatomic, copy) NSString *stringURL;
/// 当前页
@property (nonatomic, assign) NSInteger pageType;

@end

@implementation TXEquityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageSize = 20;
    self.pageIndex = 1;
    if ([self.title isEqualToString:@"股权"]) { /// 股权
        self.stringURL = @"stockdeal/UserStockdeal";
        self.pageType = 0;
    }else if ([self.title isEqualToString:@"转出记录"]){/// 转出记录
        self.stringURL = @"transaction/UserTransOut";
        self.tableView.emptyViewHeight = 40;
        self.pageType = 1;
    }else if ([self.title isEqualToString:@"转入记录"]){/// 转入记录
        self.stringURL = @"transaction/UserTransInit";
        self.tableView.emptyViewHeight = 40;
        self.pageType = 2;
    }
    [self initView];
    [self loadEquityData];
}

- (void)tt_tableView:(TTBaseTableView *)tt_tableView requestFailed:(NSError *)error{
    TTLog(@"error --- %@",error);
}

/// 处理接口返回数据
- (void)tt_tableView:(TTBaseTableView *)tt_tableView isPullDown:(BOOL)PullDown result:(id)result{
    if (self.dataArray.count >0) {
        self.dataArray = @[].mutableCopy;
    }else{
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXWalletModel *model = [TXWalletModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                [self.dataArray addObjectsFromArray:model.data.list.mutableCopy];
                [self.tableView reloadData];
            }else{
                Toast(model.message);
            }
        }
    }
    //处理返回的SuccessData 数据之后刷新table
    [self.tableView reloadData];
}


/// 获取股权记录
- (void) loadEquityData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    self.tableView.requestType = kHttpPost;
    [self.tableView setUpWithURLString:kHttpURL(self.stringURL) parameter:parameter tempVC:self];
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
    TXEarningsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    WalletModel *model = self.dataArray[indexPath.row];
    model.pageType = self.pageType;
    cell.model = model;
    return cell;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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

- (TTBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[TTBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXEarningsTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
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
