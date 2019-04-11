//
//  TXAgriculturalViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXAgriculturalViewController.h"
#import "TXRegisterTableViewCell.h"
#import "TXWebHeaderView.h"
#import "TXMallEppoViewController.h"

static NSString * const reuseIdentifier = @"TXRegisterTableViewCell";

@interface TXAgriculturalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) TXWebHeaderView *headerView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TXAgriculturalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void) initView{
    
    self.headerView.titleLabel.text = @"一县一代理独家经营";
    self.headerView.subtitleLabel.text = @"农用科技化、现代化";
    self.headerView.imagesView.image = kGetImage(@"c41_live_nongbao");
    [self.headerView.saveButton setTitle:@"农用植保" forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [Utils lz_setExtraCellLineHidden:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    MV(weakSelf);
    [self.headerView.saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf saveBtnClick:self.headerView.saveButton];
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    TXMallEppoViewController *vc = [[TXMallEppoViewController alloc] init];
    TTPushVC(vc);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TXRegisterTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.titleLabel.text = @"12";
    return tools;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return IPHONE6_W(55);
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TXRegisterTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        // 拖动tableView时收起键盘
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kClearColor;
    }
    return _tableView;
}

- (TXWebHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TXWebHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, IPHONE6_W(340));
    }
    return _headerView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
