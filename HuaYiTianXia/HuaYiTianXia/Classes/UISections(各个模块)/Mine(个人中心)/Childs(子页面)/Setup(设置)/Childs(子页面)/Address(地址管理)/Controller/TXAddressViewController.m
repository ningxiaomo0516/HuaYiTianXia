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
    tools.titleLabel.text = @"佐伊";
    tools.telLabel.text = @"13512340987";
    NSString *labelText = @"四川省 成都市 双流县 华阳镇街道 比海运的一单元54564";
    if (indexPath.section==0) {
        tools.defaultLabel.hidden = NO;
        tools.addressLabel.attributedText = [UILabel changeIndentationSpaceForLabel:labelText spaceWidth:IPHONE6_W(35.0)];
    }else{
        if (indexPath.section==1) {
            labelText = @"四川省 成都市 武侯区 天和东街29号";
        }else{
            labelText = @"四川省 成都市 武侯区 桂溪街道 天和东街29号 22栋27楼48号 如奔赴古城道路上阳光温柔灿烂不用时刻联系";
        }
        tools.addressLabel.text = labelText;
    }
    return tools;
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
