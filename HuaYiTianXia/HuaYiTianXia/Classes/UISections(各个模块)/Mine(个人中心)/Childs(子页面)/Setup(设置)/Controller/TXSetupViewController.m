//
//  TXSetupViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXSetupViewController.h"
#import "TXMineTableViewCell.h"
#import "TXPersonModel.h"

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
}

/** 退出 */
- (void) exitBtnClick:(UIButton *) sender{
    
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
    TXPersonModel* model = subArray[indexPath.row];
    model.index = indexPath.item;
    tools.titleLabel.text = model.title;
    tools.subtitleLabel.hidden = NO;
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
    TXPersonModel* model = self.dataArray[indexPath.section][indexPath.row];
    NSString *className = model.showClass;
    if ([model.showClass isEqualToString:@""]) {
        Toast(@"暂未开通");
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

- (UIButton *)exitButton{
    if (!_exitButton) {
        _exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_exitButton setTitleColor:HexString(@"#26B9FE") forState:UIControlStateNormal];
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
        
        NSArray* titleArr = @[@[@"用户使用协议",@"隐私政策",@"账户与安全",@"地址管理",@"操作手册"]];
        NSArray* classArr = @[@[@"",@"",@"TXAccountSecurityViewController",
                                @"TXAddressViewController",@""]];
        for (int i=0; i<titleArr.count; i++) {
            NSArray *subTitlesArray = [titleArr lz_safeObjectAtIndex:i];
            NSArray *classArray = [classArr lz_safeObjectAtIndex:i];
            NSMutableArray *subArray = [NSMutableArray array];
            for (int j = 0; j < subTitlesArray.count; j ++) {
                TXPersonModel* personModel = [[TXPersonModel alloc] init];
                personModel.title = [subTitlesArray lz_safeObjectAtIndex:j];
                personModel.showClass = [classArray lz_safeObjectAtIndex:j];
                [subArray addObject:personModel];
            }
            [_dataArray addObject:subArray];
        }
    }
    return _dataArray;
}

@end
