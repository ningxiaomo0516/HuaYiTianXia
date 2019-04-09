//
//  TXRolloutTypeViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/3.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXRolloutTypeViewController.h"
#import "TXRolloutTypeTableViewCell.h"

static NSString * const reuseIdentifier = @"TXRolloutTypeTableViewCell";

@interface TXRolloutTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TXRolloutTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void) initView{
    [self addGesture:self.tableView];
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kiPhoneX_T(0));
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXRolloutTypeTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    TXGeneralModel *model = self.dataArray[indexPath.row];
    tools.titleLabel.text = model.title;
    tools.subtitleLabel.text = model.imageText;
    return tools;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/// 返回多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return IPHONE6_W(55);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *kid = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    TXGeneralModel *model = self.dataArray[indexPath.row];
    if (self.typeBlock) {
        self.typeBlock(model.title,kid);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----- getter/setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXRolloutTypeTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.scrollEnabled = NO;
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
        NSArray* titleArr = @[@"AH积分",@"VH积分"];
        NSArray* subtitleArr = @[kUserInfo.arcurrency,kUserInfo.vrcurrency];
        for (int i=0; i<titleArr.count; i++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:i];
            generalModel.imageText = [subtitleArr lz_safeObjectAtIndex:i];
            [_dataArray addObject:generalModel];
        }
    }
    return _dataArray;
}

@end
