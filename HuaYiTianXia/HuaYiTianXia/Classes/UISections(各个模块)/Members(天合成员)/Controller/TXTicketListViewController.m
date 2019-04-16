//
//  TXTicketListViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTicketListViewController.h"
#import "TXTicketModel.h"
#import "TXTicketListTableViewCell.h"

static NSString* reuseIdentifier = @"TXTicketListTableViewCell";

@interface TXTicketListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *parameter;
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation TXTicketListViewController
- (id)initTicketListWithURLString:URLString parameter:(NSMutableDictionary *)parameter{
    if ( self = [super init] ){
        self.parameter = parameter;
        self.URLString = URLString;
//        [self.view showLoadingViewWithText:@"加载中..."];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查询详情";
    [self initView];
    [self GetTicketDataRequest];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view showLoadingViewWithText:@"加载中..."];
}

- (void) GetTicketDataRequest{
    [SCHttpTools getTicketWithURLString:self.URLString parameter:self.parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
            TXTicketModel *model = [TXTicketModel mj_objectWithKeyValues:result];
            if (model.errorcode==0) {
                /// 查询列表
                [self.dataArray addObjectsFromArray:model.data];
                TTLog(@"self.dataArray.count --- %lu",(unsigned long)self.dataArray.count);
                [self.tableView reloadData];
            }else{
                Toast(model.message);
            }
        }
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        TTLog(@"机票查询信息 -- %@", error);
        [self.view dismissLoadingView];
    }];
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self initViewConstraints];
}


#pragma mark ---- 约束布局
- (void) initViewConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.right.equalTo(self.view);
    }];
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXTicketListTableViewCell  *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.ticketModel = self.dataArray[indexPath.section];
    return tools;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return IPHONE6_W(90);
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----- getter/setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        [_tableView registerClass:[TXTicketListTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
        _tableView.rowHeight = UITableViewAutomaticDimension;
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
