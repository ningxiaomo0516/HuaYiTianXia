//
//  TXMembersViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMembersViewController.h"
#import "TXMembersBannerView.h"
#import "TXMembersbleViewCell.h"
#import "TXWebHeaderView.h"

static NSString * const reuseIdentifier = @"TXMembersbleViewCell";

@interface TXMembersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) TXWebHeaderView *headerView;
@property (nonatomic, strong) TXMembersBannerView *bannerView;
@end

@implementation TXMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    
}

- (void) initView{
    
    self.headerView.titleLabel.text = @"欢迎激活共享飞行";
    self.headerView.subtitleLabel.text = @"优享品质生活";
    self.headerView.imagesView.image = kGetImage(@"c41_live_jinka");
    [self.headerView.saveButton setTitle:@"系统审核中" forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [Utils lz_setExtraCellLineHidden:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabBarHeight);
    }];
    MV(weakSelf);
    [self.headerView.saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf saveBtnClick:self.headerView.saveButton];
    }];
    
//    [self.view addSubview:self.bannerView];
//    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self.view);
//        make.height.equalTo(@(IPHONE6_W(150)));
//    }];
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(self.view);
//        make.top.equalTo(self.bannerView.mas_bottom);
//    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXMembersbleViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
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
    return IPHONE6_W(90);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXMembersbleViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kTableViewInSectionColor;
    }
    return _tableView;
}

- (TXMembersBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[TXMembersBannerView alloc] init];
    }
    return _bannerView;
}

- (TXWebHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TXWebHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, IPHONE6_W(330));
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
