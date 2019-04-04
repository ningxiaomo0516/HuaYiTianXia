//
//  TXAccountSecurityViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXAccountSecurityViewController.h"
#import "TXMineTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXRealNameViewController.h"

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
    TXGeneralModel* model = self.dataArray[indexPath.row];
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
    TXGeneralModel* model = self.dataArray[indexPath.row];
    NSString *className = model.showClass;
    if ([model.showClass isEqualToString:@"TXRealNameViewController"]) {
        TXRealNameViewController *vc = [[TXRealNameViewController alloc] init];
        vc.title = model.title;
        vc.typePage = 1;
        TTPushVC(vc);
    }else{
        Class controller = NSClassFromString(className);
        //    id controller = [[NSClassFromString(className) alloc] init];
        if (controller &&  [controller isSubclassOfClass:[UIViewController class]]){
            UIViewController *vc = [[controller alloc] init];
            vc.title = model.title;
            TTPushVC(vc);
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
        /// 0：未设置交易密码 1：已设置交易密码
        NSArray* titleArr = [NSArray new];
        NSArray* classArr = [NSArray new];
        if (kUserInfo.tranPwd==0) {
            titleArr = @[@"个人资料",@"认证资料",@"重置登录密码",@"设置交易密码"];
            classArr = @[@"TXPersonalInfoViewController",@"TXRealNameViewController",@"TXResetPwdViewController",@"TXSetupTradingViewController"];
        }else if(kUserInfo.tranPwd==1){
            titleArr = @[@"个人资料",@"认证资料",@"重置登录密码",@"重置交易密码",@"忘记交易密码"];
            classArr = @[@"TXPersonalInfoViewController",@"TXRealNameViewController",
                         @"TXResetPwdViewController",@"TXResetTradingViewController",@"TXForgetTradingViewController"];
        }else{
            titleArr = @[@"个人资料",@"认证资料"];
            classArr = @[@"TXPersonalInfoViewController",@"TXRealNameViewController"];
        }
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:j];
            generalModel.showClass = [classArr lz_safeObjectAtIndex:j];
            [_dataArray addObject:generalModel];
        }
    }
    return _dataArray;
}


@end
