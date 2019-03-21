//
//  TXRolloutViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXRolloutViewController.h"
#import "TXMineHeaderTableViewCell.h"
#import "TXRolloutTableViewCell.h"
#import "TXPersonModel.h"

static NSString * const reuseIdentifier = @"TXRolloutTableViewCell";
static NSString * const reuseIdentifierHeader = @"TXMineHeaderTableViewCell";

@interface TXRolloutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIButton *saveButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation TXRolloutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    
}

#pragma mark ---- 约束布局
- (void) initViewConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self initViewConstraints];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TXMineHeaderTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
        return tools;
    } else {
        TXRolloutTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        TXPersonModel* model = self.dataArray[indexPath.row];
        model.index = indexPath.item;
        tools.titleLabel.text = model.title;
        return tools;
    }
    return [UITableViewCell new];
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/// 返回多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return 1;
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        return IPHONE6_W(55);
    }else {
        return UITableViewAutomaticDimension;
    }
}

#pragma mark ----- getter/setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXRolloutTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXMineHeaderTableViewCell class] forCellReuseIdentifier:reuseIdentifierHeader];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
        NSArray* titleArr = @[@"资产管理",@"实名认证",@"订单中心",@"我的钱包"];
        for (int i=0; i<titleArr.count; i++) {
            TXPersonModel* personModel = [[TXPersonModel alloc] init];
            personModel.title = [titleArr lz_safeObjectAtIndex:i];
            [_dataArray addObject:personModel];
        }
    }
    return _dataArray;
}

@end
