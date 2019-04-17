//
//  TXAddressViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXAddressViewController.h"
#import "TXAddressTableViewCell.h"
#import "TXAddressAddViewController.h"
#import "TXAddressModel.h"

static NSString * const reuseIdentifier = @"TXAddressTableViewCell";

@interface TXAddressViewController ()<UITableViewDelegate,UITableViewDataSource,TTTableViewRequestDelegate>
@property (nonatomic, strong) TTBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end


@implementation TXAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    // 添加右边保存按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增地址" style:UIBarButtonItemStylePlain target:self action:@selector(addBtnClick)];
    [self requestAddressData];
    // 注册通知
    [kNotificationCenter addObserver:self selector:@selector(requestAddressData) name:@"reloadAddressData" object:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view showLoadingViewWithText:@"请稍后"];
}

- (void)tt_tableView:(TTBaseTableView *)tt_tableView requestFailed:(NSError *)error{
    TTLog(@"error --- %@",error);
    [self.view dismissLoadingView];
}

/// 处理接口返回数据
- (void)tt_tableView:(TTBaseTableView *)tt_tableView isPullDown:(BOOL)PullDown result:(id)results{
    if ([results isKindOfClass:[NSDictionary class]]) {
        TXAddressModel *model = [TXAddressModel mj_objectWithKeyValues:results];
        if (model.errorcode == 20000) {
            if (PullDown) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:model.data.mutableCopy];
            [self.tableView reloadData];
        }else{
            Toast(model.message);
        }
    }
    [self.view dismissLoadingView];
    //处理返回的SuccessData 数据之后刷新table
    [self.tableView reloadData];
}

/// 获取收货地址
- (void) requestAddressData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [self.tableView setUpWithURLString:kHttpURL(@"address/GetAddress") parameter:parameter tempVC:self];
}

- (void) addBtnClick{
    [self jumpAddressEditVC:AddInfo vcTitle:@"新增收货地址"];
}

- (void) initView{
    
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void) jumpAddressEditVC:(AddressType)type vcTitle:(NSString *)title{
    TXAddressAddViewController *vc = [[TXAddressAddViewController alloc] init];
    vc.currentType = type;
    vc.title = title;
    TTPushVC(vc);
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXAddressTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    AddressModel *model = self.dataArray[indexPath.section];
    tools.addressModel = model;
    if (model.isDefault) {
        kUserInfo.receivedGoodsAddr = model.address;
        kUserInfo.receivedUserName = model.username;
        kUserInfo.receivedTelphone = model.telphone;
        
        [kUserInfo dump];
    }
    return tools;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pageType==0) {
        AddressModel *model = self.dataArray[indexPath.section];
        if (self.selectedAddressBlock) {
            self.selectedAddressBlock(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //    [self jumpAddressEditVC:AddInfo vcTitle:@"修改收货地址"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (TTBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[TTBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXAddressTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.requestDelegate = self;
        _tableView.requestType = kHttpGet;
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

- (void)dealloc{
    [kNotificationCenter removeObserver:self];
}

@end
