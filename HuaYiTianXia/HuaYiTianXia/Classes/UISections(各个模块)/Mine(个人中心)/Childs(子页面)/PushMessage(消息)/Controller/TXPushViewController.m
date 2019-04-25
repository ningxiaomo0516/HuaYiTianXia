//
//  TXPushViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPushViewController.h"
#import "TXPushTableViewCell.h"

static NSString * const reuseIdentifier = @"TXPushTableViewCell";
@interface TXPushViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TXPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
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
    TXPushTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSInteger idx = kRandomNumber(1);
    NSDictionary *dic = self.dataArray[idx];
    tools.titleLabel.text = [dic lz_objectForKey:@"title"];
    tools.contenLabel.text = [dic lz_objectForKey:@"content"];
    tools.dateLabel.text = [dic lz_objectForKey:@"content"];
    return tools;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 20;//self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(80);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXPushTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
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
        NSDictionary *dic = @{@"title":@"天合会员焕新公告",@"content":@"2019年4月9日起，天合会员将迎来一次全新改版，将引入更加全面的用户成长“等级分”会员体系，等级身份的评估周期、评估维度将进行优化升级。“等级分”是根据您在华翼近12个月内的订单消费情况、任务活动完成情及信誉记录，来综合计算相应的分值。详情至会员中心...",@"date":@"14:17"};
        NSDictionary *dic1 = @{@"title":@"会员等级变更通知",@"content":@"      恭喜你升级到白钻会员，超越了35%的用户！你已享受5项尊贵权益，可点击“个人中心”查看会员等级，快去看看吧！",@"date":@"02-14"};
        [_dataArray addObject:dic];
        [_dataArray addObject:dic1];
    }
    return _dataArray;
}

@end
