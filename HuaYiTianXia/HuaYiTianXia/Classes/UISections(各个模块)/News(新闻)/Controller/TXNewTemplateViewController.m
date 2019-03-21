
//
//  TXNewTemplateViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXNewTemplateViewController.h"
#import "SCTableViewSectionHeaderView.h"
#import "TXNewTemplateTableViewCell.h"


static NSString * const reuseIdentifier = @"TXNewTemplateTableViewCell";
static NSString * const reuseIdentifierSectionHeaderView = @"SCTableViewSectionHeaderView";

@interface TXNewTemplateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TXNewTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initViewConstraints];
}

- (void) initView{
//    self.homeHeaderView.cityLabel.text = kUserInfo.cityName;
//    [self.view addSubview:self.homeHeaderView];
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
}


#pragma mark ---- 约束布局
- (void) initViewConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
    }];
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        TXNewTemplateTableViewCell  *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
//        tools.listModel = self.businessModel.huodongs;
        return tools;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return IPHONE6_W(108);
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

#pragma mark -------------- 设置Header高度 --------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.f;
}

#pragma mark -------------- 设置组头 --------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SCTableViewSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifierSectionHeaderView];
    NSString *titleTextStr = @"新闻动态";
    NSString *subtitleTestStr = @"";
    headerView.arrowImageView.hidden = YES;
    headerView.titleLabel.text = titleTextStr;
    headerView.subtitleLabel.text = subtitleTestStr;
    return headerView;
}

#pragma mark ----- getter/setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        [_tableView registerClass:[SCTableViewSectionHeaderView class] forHeaderFooterViewReuseIdentifier:reuseIdentifierSectionHeaderView];
        [_tableView registerClass:[TXNewTemplateTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        //1 禁用系统自带的分割线
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

@end
