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

static NSString * const reuseIdentifier = @"TXPushTableViewCell";
static NSString * const reuseIdentifiers = @"TXSystemTableViewCell";
@interface TXPushViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SCNoDataView *noDataView;
@end

@implementation TXPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = @"消息";
    [self.view showLoadingViewWithText:@"加载中..."];
    [self loadMessageData];
    
}

- (void) loadMessageData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [SCHttpTools postWithURLString:kHttpURL(@"notice/noticePage") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXPushMessageModel *model = [TXPushMessageModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
                [self.dataArray addObjectsFromArray:model.data.list];
            }else{
                Toast(model.message);
            }
            [self analysisData];
        }
        [self.view dismissLoadingView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        TTLog(@"我的团队数据信息 -- %@", error);
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

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PushMessageModel *messageModel = self.dataArray[indexPath.section];
    if (messageModel.messageType==2||messageModel.messageType==3) {
        TXSystemTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifiers forIndexPath:indexPath];
        tools.titleLabel.text = messageModel.title;
        tools.subtitleLabel.text = messageModel.content;
        if (messageModel.messageType==2) {
            tools.imagesView.image = kGetImage(@"转账图标");
            tools.amountLabel.text = [NSString stringWithFormat:@"- ￥%@",messageModel.money];
        }else{
            tools.amountLabel.text = [NSString stringWithFormat:@"+ ￥%@",messageModel.money];
            tools.imagesView.image = kGetImage(@"转账图标2");
            tools.amountLabel.textColor = HexString(@"#1296DB");
        }
        return tools;
    }else{
        TXPushTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.titleLabel.text = messageModel.title;
        tools.contenLabel.text = messageModel.content;
        tools.dateLabel.text = messageModel.datetime;
        return tools;
    }
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXPushTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXSystemTableViewCell class] forCellReuseIdentifier:reuseIdentifiers];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,0)];
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

@end
