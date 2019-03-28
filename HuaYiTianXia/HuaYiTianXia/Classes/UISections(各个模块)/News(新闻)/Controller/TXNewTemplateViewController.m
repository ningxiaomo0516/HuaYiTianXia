
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
#import "TXMallGoodsBannerTableViewCell.h"
#import "TXNewsModel.h"


static NSString * const reuseIdentifier = @"TXNewTemplateTableViewCell";
static NSString * const reuseIdentifierBanner = @"TXMallGoodsBannerTableViewCell";
static NSString * const reuseIdentifierSectionHeaderView = @"SCTableViewSectionHeaderView";

@interface TXNewTemplateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation TXNewTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageSize = 20;
    self.pageIndex = 1;
    [self initView];
    [self initViewConstraints];
    [self loadNewsData];
}


- (void) loadNewsData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@([self.title integerValue]) forKey:@"tabID"];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数

    TTLog(@"parameter -- %@",parameter);
    [SCHttpTools postWithURLString:@"news/GetNew" parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTLog(@"result -- %@",result);
            TXNewsArrayModel *model = [TXNewsArrayModel mj_objectWithKeyValues:result];
            [self.dataArray addObjectsFromArray:model.data.records];
            [self.bannerArray addObjectsFromArray:model.banners];
            [self.tableView reloadData];
        }else{
            Toast(@"获取城市数据失败");
        }
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
    }];
}

- (void) initView{
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
    if (self.bannerArray.count>0&&indexPath.section==0) {
        TXMallGoodsBannerTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        tools.bannerArray = self.bannerArray;
        return tools;
    }else{
        TXNewTemplateTableViewCell  *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.recordsModel = self.dataArray[indexPath.row];
        return tools;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.bannerArray.count>0&&indexPath.section==0)?IPHONE6_W(180):IPHONE6_W(108);
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (self.bannerArray.count>0)?2:1;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.bannerArray.count>0&&section==0)?1:self.dataArray.count;
}

#pragma mark -------------- 设置Header高度 --------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (self.bannerArray.count>0&&section==0)?0.f:44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section!=0) {
        return 0.0f;
    }
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -------------- 设置组头 --------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SCTableViewSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifierSectionHeaderView];
    if (self.bannerArray.count>0&&section==1) {
        NSString *titleTextStr = @"新闻动态";
        NSString *subtitleTestStr = @"";
        headerView.lineView.hidden = NO;
        headerView.titleLabel.text = titleTextStr;
        headerView.subtitleLabel.text = subtitleTestStr;
    }else{
        NSString *titleTextStr = @"新闻动态";
        NSString *subtitleTestStr = @"";
        headerView.lineView.hidden = NO;
        headerView.titleLabel.text = titleTextStr;
        headerView.subtitleLabel.text = subtitleTestStr;
    }
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
        [_tableView registerClass:[TXMallGoodsBannerTableViewCell class] forCellReuseIdentifier:reuseIdentifierBanner];
        //1 禁用系统自带的分割线
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (NSMutableArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [[NSMutableArray alloc] init];
    }
    return _bannerArray;
}

@end
