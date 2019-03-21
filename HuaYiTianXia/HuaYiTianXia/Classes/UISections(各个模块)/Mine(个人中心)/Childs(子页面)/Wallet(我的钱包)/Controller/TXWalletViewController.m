//
//  TXWalletViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXWalletViewController.h"
#import "TXMineHeaderTableViewCell.h"
#import "TXWalletTableViewCell.h"

static NSString * const reuseIdentifier = @"TXWalletTableViewCell";
static NSString * const reuseIdentifierHeader = @"TXMineHeaderTableViewCell";

@interface TXWalletViewController ()<UITableViewDelegate,UITableViewDataSource,TXWalletTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度

@end

@implementation TXWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
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
        //    FMPersonModel* model = self.itemModelArray[indexPath.section][indexPath.row];
        //    model.index = indexPath.item;
        //    cell.personModel = model;
        return tools;
        
    } else {
        TXWalletTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.delegate = self;
        tools.indexPath = indexPath;
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section==1) && self.heightAtIndexPath[indexPath]) {
        NSNumber *num = self.heightAtIndexPath[indexPath];
        /// collectionView 底部还有七个像素
        return [num floatValue];
    }else {
        return UITableViewAutomaticDimension;
    }
}

#pragma mark ====== TXWalletTableViewCellDelegate ======
- (void)updateTableViewCellHeight:(TXWalletTableViewCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath {
    if (![self.heightAtIndexPath[indexPath] isEqualToNumber:@(height)]) {
        self.heightAtIndexPath[indexPath] = @(height);
        [self.tableView reloadData];
    }
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withTitle:(NSString *)title withShowClass:(NSString *)showClass {
    NSString *className = showClass;
    if ([className isEqualToString:@""]) {
        
    }else{
        Class controller = NSClassFromString(className);
        
        //    id controller = [[NSClassFromString(className) alloc] init];
        if (controller &&  [controller isSubclassOfClass:[UIViewController class]]){
            UIViewController *view = [[controller alloc] init];
            view.title = title;
            [view setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:view animated:YES];
        }
    }
}


#pragma mark ----- getter/setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXWalletTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
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

- (NSMutableDictionary *)heightAtIndexPath {
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [[NSMutableDictionary alloc] init];
    }
    return _heightAtIndexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
