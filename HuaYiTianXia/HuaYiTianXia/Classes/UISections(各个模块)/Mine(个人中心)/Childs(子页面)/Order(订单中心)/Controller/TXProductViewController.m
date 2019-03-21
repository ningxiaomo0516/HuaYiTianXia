//
//  TXProductViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXProductViewController.h"
#import "TXProductTableViewCell.h"

static NSString * const reuseIdentifier = @"TXProductTableViewCell";

@interface TXProductViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemModelArray;

@end

@implementation TXProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kRandomColor;
    [self initView];
}

- (void) initView{
    
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
//    [self.view showLoadingViewWithText:@"加载中..."];
    
//    // 下拉刷新
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        //将页码重新置为1
//        self.pageIndex = 1;
//        [self getDataRequest];
//    }];
//    /// 上拉加载
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.pageIndex++;// 页码+1
//        [self getDataRequest];
//        [self.tableView.mj_footer endRefreshing];
//    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXProductTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(110);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXProductTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kTableViewInSectionColor;
    }
    return _tableView;
}

//- (SCNoDataView *)noDataView {
//    if (!_noDataView) {
//        _noDataView = [[SCNoDataView alloc] initWithFrame:self.view.bounds
//                                                imageName:@"live_k_yuyue"
//                                            tipsLabelText:@"没有预约的商家哦~"];
//        _noDataView.userInteractionEnabled = YES;
//        [self.view insertSubview:_noDataView aboveSubview:self.tableView];
//        [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_offset(0);
//            make.centerY.mas_equalTo(self.view.mas_centerY);
//            make.height.mas_equalTo(150);
//        }];
//    }
//    return _noDataView;
//}

- (NSMutableArray *)itemModelArray{
    if (!_itemModelArray) {
        _itemModelArray = [[NSMutableArray alloc] init];
    }
    return _itemModelArray;
}

@end
