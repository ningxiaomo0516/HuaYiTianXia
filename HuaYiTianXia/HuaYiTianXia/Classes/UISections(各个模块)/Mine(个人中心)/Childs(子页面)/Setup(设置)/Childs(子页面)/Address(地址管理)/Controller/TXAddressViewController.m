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

@interface TXAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
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
}

/// 获取收货地址
- (void) requestAddressData{
    [SCHttpTools getWithURLString:kHttpURL(@"address/GetAddress") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXAddressModel *model = [TXAddressModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                [self.dataArray addObjectsFromArray:model.data];
                [self.tableView reloadData];
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"收货地址数据获取失败");
        }
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
    }];
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
    tools.addressModel = self.dataArray[indexPath.section];
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
    [self jumpAddressEditVC:AddInfo vcTitle:@"修改收货地址"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXAddressTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

@end
