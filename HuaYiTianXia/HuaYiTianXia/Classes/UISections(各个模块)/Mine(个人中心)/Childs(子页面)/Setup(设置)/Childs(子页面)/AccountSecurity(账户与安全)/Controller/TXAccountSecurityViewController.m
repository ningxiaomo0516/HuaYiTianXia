//
//  TXAccountSecurityViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXAccountSecurityViewController.h"
#import "TXMineTableViewCell.h"
#import "TXPersonModel.h"

static NSString * const reuseIdentifier = @"TXMineTableViewCell";

@interface TXAccountSecurityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TXAccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void) initView{
    
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXMineTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    TXPersonModel* model = self.dataArray[indexPath.row];
    model.index = indexPath.item;
    tools.titleLabel.text = model.title;
    return tools;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TXPersonModel* model = self.dataArray[indexPath.row];
    NSString *className = model.showClass;
    if ([model.showClass isEqualToString:@""]) {
        
    }else{
        Class controller = NSClassFromString(className);
        //    id controller = [[NSClassFromString(className) alloc] init];
        if (controller &&  [controller isSubclassOfClass:[UIViewController class]]){
            UIViewController *view = [[controller alloc] init];
            view.title = model.title;
            [view setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:view animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXMineTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
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
        NSArray* titleArr = @[@"个人资料",@"认证资料",@"重置密码",@"设置交易密码"];
        NSArray* classArr = @[@"TXPersonalInfoViewController",@"",@"TXResetPwdViewController",@""];
        for (int j = 0; j < titleArr.count; j ++) {
            TXPersonModel* personModel = [[TXPersonModel alloc] init];
            personModel.title = [titleArr lz_safeObjectAtIndex:j];
            personModel.showClass = [classArr lz_safeObjectAtIndex:j];
            [_dataArray addObject:personModel];
        }
    }
    return _dataArray;
}


@end
