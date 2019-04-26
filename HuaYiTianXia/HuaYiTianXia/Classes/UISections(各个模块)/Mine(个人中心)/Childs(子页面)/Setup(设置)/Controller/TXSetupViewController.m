//
//  TXSetupViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXSetupViewController.h"
#import "TXMineTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXWebViewController.h"
#import "AppDelegate.h"
#import "TXAddressViewController.h"

static NSString * const reuseIdentifier = @"TXMineTableViewCell";

@interface TXSetupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation TXSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.title = @"设置";
}

/** 退出 */
- (void) exitBtnClick:(UIButton *) sender{
    // 退出登录提示
    UIAlertController *alerController = [UIAlertController addAlertReminderText:@"退出登录"
                                                                        message:@"您确定要退出登录吗?"
                                                                    cancelTitle:@"取消"
                                                                        doTitle:@"确定"
                                                                 preferredStyle:UIAlertControllerStyleAlert
                                                                    cancelBlock:nil doBlock:^{
        [self logoutUserRequest];
    }];
    [self presentViewController:alerController animated:YES completion:nil];
}

- (void) logoutUserRequest{
    [SCHttpTools getWithURLString:kHttpURL(@"customer/outlogin") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTUserDataModel *model = [TTUserDataModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                TTLog(@"result ---- %@",[Utils lz_dataWithJSONObject:result]);
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[AppDelegate appDelegate] jumpMainVC];
                [kUserInfo logout];
                [kUserInfo dump];
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"个人中心数据获取失败");
        }
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
    }];

}

- (void) initView{
    
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.footerView addSubview:self.exitButton];
    self.tableView.tableFooterView = self.footerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(51));
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXMineTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSArray *subArray = [self.dataArray lz_safeObjectAtIndex:indexPath.section];
    TXGeneralModel* model = subArray[indexPath.row];
    model.index = indexPath.item;
    tools.titleLabel.text = model.title;
    if (indexPath.section == 1) {
        tools.imagesArrow.hidden = YES;
        tools.subtitleLabel.hidden = NO;
        tools.subtitleLabel.text = kStringFormat(@"v", kVersioning);
        tools.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return tools;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subArray = [self.dataArray lz_safeObjectAtIndex:section];
    return subArray.count;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(51);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TXGeneralModel* model = self.dataArray[indexPath.section][indexPath.row];
    NSString *className = model.showClass;
    if (indexPath.section==0) {
        if ([model.showClass isEqualToString:@""]) {
            Toast(@"暂未开通");
        }else if ([model.showClass isEqualToString:@"TXAddressViewController"]) {
            TXAddressViewController *vc = [[TXAddressViewController alloc] init];
            vc.pageType = 1;
            TTPushVC(vc);
        }else if(model.index==0||model.index==1||model.index==4){
            TXWebViewController *vc = [[TXWebViewController alloc] init];
            vc.title = model.title;
            if (model.index==0) {
                vc.webUrl = kAppendH5URL(DomainName, UserAgreeH5,@"");
            }else if(model.index==1){
                vc.webUrl = kAppendH5URL(DomainName, UserAgreeH5,@"");
            }else if(model.index==4){
                vc.webUrl = kAppendH5URL(DomainName, UserHelpH5,@"");
            }
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

- (UIButton *)exitButton{
    if (!_exitButton) {
        _exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_exitButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        _exitButton.titleLabel.font = kFontSizeMedium15;
        [_exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_exitButton setBackgroundColor:kWhiteColor];
        MV(weakSelf);
        [_exitButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf exitBtnClick:self.exitButton];
        }];
    }
    return _exitButton;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kClearColor];
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    }
    return _footerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        TTLog(@"kVersioning - %@",kVersioning);
        NSArray* titleArr = @[@[@"用户使用协议",@"隐私政策",@"账户与安全",@"地址管理",@"操作手册"],@[@"当前版本"]];
        NSArray* indexArr = @[@[@"0",@"1",@"2",@"3",@"4"],@[]];
        NSArray* classArr = @[@[@"TXWebViewController",@"TXWebViewController",@"TXAccountSecurityViewController",
                                @"TXAddressViewController",@"TXWebViewController"],@[]];
        for (int i=0; i<titleArr.count; i++) {
            NSArray *subTitlesArray = [titleArr lz_safeObjectAtIndex:i];
            NSArray *classArray     = [classArr lz_safeObjectAtIndex:i];
            NSArray *indexArray     = [indexArr lz_safeObjectAtIndex:i];
            NSMutableArray *subArray = [NSMutableArray array];
            for (int j = 0; j < subTitlesArray.count; j ++) {
                TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
                generalModel.title      = [subTitlesArray lz_safeObjectAtIndex:j];
                generalModel.showClass  = [classArray lz_safeObjectAtIndex:j];
                generalModel.index      = [[indexArray lz_safeObjectAtIndex:j] integerValue];
                [subArray addObject:generalModel];
            }
            [_dataArray addObject:subArray];
        }
    }
    return _dataArray;
}

@end
