//
//  TXCharterOrderViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/1.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterOrderViewController.h"
#import "TXCharterOrderTableViewCell.h"
#import "TXCharterBaseInfoTableViewCell.h"
#import "TTBaseSectionHeaderView.h"
#import "TXCharterFooterView.h"
static NSString * const reuseIdentifier = @"TXCharterOrderTableViewCell";
static NSString * const reuseIdentifierInfo = @"TXCharterBaseInfoTableViewCell";

@interface TXCharterOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isDefault;
/// 底部视图
@property (nonatomic, strong) TXCharterFooterView *footerView;

@end

@implementation TXCharterOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填写订单";
    self.isDefault = YES;
    [self initView];
    
}

- (void) requestTicketOrderData{
//    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
//    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
//    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
//    [SCHttpTools postWithURLString:kHttpURL(@"aircraftorder/GetAircraftorder") parameter:parameter success:^(id responseObject) {
//        NSDictionary *result = responseObject;
//        if ([result isKindOfClass:[NSDictionary class]]) {
//            TXTicketOrderModel *model = [TXTicketOrderModel mj_objectWithKeyValues:result];
//            if (model.errorcode == 20000) {
//                TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
//                [self.dataArray addObjectsFromArray:model.data.list];
//            }else{
//                Toast(model.message);
//            }
//            [self analysisData];
//            [self.tableView reloadData];
//            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshing];
//            [self.view dismissLoadingView];
//        }else{
//            Toast(@"个人中心数据获取失败");
//        }
//        [self.view dismissLoadingView];
//    } failure:^(NSError *error) {
//        TTLog(@" -- error -- %@",error);
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        [self.view dismissLoadingView];
//    }];
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(kTabBarHeight));
    }];
}

- (void) valueSwitchChanged:(UISwitch *) isSwitch{
    if (isSwitch.on) {
        self.isDefault = YES;
    }else{
        self.isDefault = NO;
    }
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        TXCharterOrderTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        return tools;
    }else{
        TXCharterBaseInfoTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierInfo forIndexPath:indexPath];
        TXGeneralModel* model = self.dataArray[indexPath.section][indexPath.row];
        tools.titleLabel.text = model.title;
        if (indexPath.section==1){
            tools.titleLabel.textColor = kTextColor153;
        }else if (indexPath.section==2) {
            tools.subtitleLabel.hidden = NO;
        }else if(indexPath.section==3 ){
            tools.imagesArrow.hidden = NO;
        }
        if (indexPath.section==3||indexPath.section==4) {
            tools.selectionStyle = UITableViewCellSelectionStyleDefault;
        }else{
            tools.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return tools;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) return IPHONE6_W(240);
    return IPHONE6_W(50);
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if(section==3){
//        return self.isDefault?2:1;
//    }else{
        NSArray *subArray = [self.dataArray lz_safeObjectAtIndex:section];
        return subArray.count;
//    }
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) return 0.0001f;
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}

#pragma mark -- Section HearderView Title
// UITableView在Plain类型下，HeaderView和FooterView不悬浮和不停留的方法viewForHeaderInSection
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [UIView lz_viewWithColor:kWhiteColor];
    CGFloat height = section==0?0.0001f:40.f;
    sectionView.frame = CGRectMake(0, 0, kScreenWidth, height);
    if (section!=0) {
        UIView *linerView = [UIView lz_viewWithColor:kLinerViewColor];
        linerView.frame = CGRectMake(0, 39.5, kScreenWidth, 0.4);
        [sectionView addSubview:linerView];
        UILabel *titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
        [sectionView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.centerY.equalTo(sectionView);
        }];
        
        if (section==1) titleLabel.text = @"联系人信息";
        if (section==2) titleLabel.text = @"售价";
        if (section==3) {
            UISwitch *isSwitch = [[UISwitch alloc] init];
            isSwitch.onTintColor = HexString(@"#26B9FE");
            /// 设置按钮处于关闭状态时边框的颜色
            isSwitch.tintColor = kTextColor238;
            [sectionView addSubview:isSwitch];
            [isSwitch addTarget:self action:@selector(valueSwitchChanged:) forControlEvents:(UIControlEventValueChanged)];
            [isSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(sectionView.mas_right).offset(-15);
                make.centerY.equalTo(sectionView);
            }];
            titleLabel.text = @"报销凭证";
        }
        if (section==4) titleLabel.text = @"选择支付方式";
    }
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *sectionView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 10.f)];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----- getter/setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        [_tableView registerClass:[TXCharterOrderTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXCharterBaseInfoTableViewCell class] forCellReuseIdentifier:reuseIdentifierInfo];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (TXCharterFooterView *)footerView{
    if (!_footerView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kTabBarHeight);
        _footerView = [[TXCharterFooterView alloc] initWithFrame:rect];
    }
    return _footerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@[@""],
                              @[kUserInfo.realname,kUserInfo.phone],
                              @[@"原价",@"特惠价",@"订金"],
                              @[@"请选择发票抬头",@"请选择收货地址"],
                              @[@"支付宝",@"微信支付"]];
        NSArray* classArr = @[@[@""],
                              @[@"",@"",@""],
                              @[@"",@"",@""],
                              @[@"",@"TXSetupViewController",@""],
                              @[@"",@""]];
        for (int i=0; i<titleArr.count; i++) {
            NSArray *subTitlesArray = [titleArr lz_safeObjectAtIndex:i];
            NSArray *classArray = [classArr lz_safeObjectAtIndex:i];
            NSMutableArray *subArray = [NSMutableArray array];
            for (int j = 0; j < subTitlesArray.count; j ++) {
                TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
                generalModel.title = [subTitlesArray lz_safeObjectAtIndex:j];
                generalModel.showClass = [classArray lz_safeObjectAtIndex:j];
                [subArray addObject:generalModel];
            }
            [_dataArray addObject:subArray];
        }
    }
    return _dataArray;
}
@end
