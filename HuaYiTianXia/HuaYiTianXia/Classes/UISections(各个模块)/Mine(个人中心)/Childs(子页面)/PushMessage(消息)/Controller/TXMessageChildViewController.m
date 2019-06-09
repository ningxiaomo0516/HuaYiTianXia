//
//  TXMessageChildViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/30.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMessageChildViewController.h"
#import "TXMessageChildTableViewCell.h"
#import "TXMessageChildHeaderView.h"

static NSString * const reuseIdentifier = @"TXMessageChildTableViewCell";

@interface TXMessageChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PushMessageModel *messageModel;
@property (nonatomic, strong) TXMessageChildHeaderView *headerView;

@end

@implementation TXMessageChildViewController
- (id)initPushMessageModel:(PushMessageModel *)messageModel{
    if ( self = [super init] ){
        self.messageModel = messageModel;
        self.tableView.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self loadMessageData];
    self.title = @"转账详情";
}

/// 请求数据接口
- (void) loadMessageData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.messageModel.outID) forKey:@"outID"];
    [SCHttpTools postWithURLString:kHttpURL(@"notice/getTransferDetails") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXPushMessageModel *model = [TXPushMessageModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000 && model.data != nil) {
            TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
            [self.dataArray addObject:model.data.remarks];
            [self.dataArray addObject:model.data.realname];
            [self.dataArray addObject:model.data.account];
            [self.dataArray addObject:model.data.orderid];
            [self.dataArray addObject:model.data.tradingTime];
            self.headerView.nicknameLabel.text = model.data.nickname;
            self.headerView.amountLabel.text = model.data.tradingAmount;
            self.headerView.statusLabel.text = @"交易成功";
            [self.headerView.imagesViewAvatar sc_setImageWithUrlString:model.data.avatarURL
                                                      placeholderImage:kGetImage(@"mine_icon_avatar")
                                                              isAvatar:false];
        }else{
            Toast(model.message);
        }
        [self.tableView reloadData];
        [self.tableView setHidden:NO];
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        TTLog(@"消息推送 -- %@", error);
        [self.view dismissLoadingView];
    }];
}

- (void) initView{
    self.tableView.tableHeaderView = self.headerView;
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXMessageChildTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    TXGeneralModel* model = self.titleArray[indexPath.row];
    tools.titleLabel.text = model.title;
    tools.subtitleLabel.text = self.dataArray[indexPath.row];
    return tools;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(50);
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXMessageChildTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kTableViewInSectionColor;
    }
    return _tableView;
}

- (TXMessageChildHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TXMessageChildHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, IPHONE6_W(140))];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@"转账备注",@"对方姓名",@"对方账户",@"订单号",@"交易时间"];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:j];
            [_titleArray addObject:generalModel];
        }
    }
    return _titleArray;
}


@end
