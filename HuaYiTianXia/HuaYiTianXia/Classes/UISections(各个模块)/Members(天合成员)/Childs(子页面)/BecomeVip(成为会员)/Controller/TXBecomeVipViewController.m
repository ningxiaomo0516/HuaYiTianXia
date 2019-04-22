//
//  TXBecomeVipViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXBecomeVipViewController.h"
#import "TXBecomeVipHeaderView.h"
#import "TXBecomeVipTableViewCell.h"

static NSString * const reuseIdentifier = @"TXBecomeVipHeaderView";

@interface TXBecomeVipViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) TXBecomeVipHeaderView *headerView;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation TXBecomeVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void) initView{
    
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [UITableViewCell new];
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return 1;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return IPHONE6_W(50);
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,IPHONE6_W(15),0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kWhiteColor;
    }
    return _tableView;
}

- (TXBecomeVipHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [TXBecomeVipHeaderView lz_viewWithColor:kWhiteColor];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, IPHONE6_W(150));
    }
    return _headerView;
}

@end
