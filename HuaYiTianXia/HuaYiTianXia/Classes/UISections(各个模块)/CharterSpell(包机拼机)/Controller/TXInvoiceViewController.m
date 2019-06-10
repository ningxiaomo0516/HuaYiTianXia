//
//  TXInvoiceViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/9.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXInvoiceViewController.h"
#import "TXInvoiceTableViewCell.h"
#import "MusicModel.h"
#import "TXInvoiceModel.h"
#import "TXAddInvoiceViewController.h"


static NSString * const reuseIdentifier = @"TXInvoiceTableViewCell";
@interface TXInvoiceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView      *tableView;
@property(nonatomic, strong) NSMutableArray   *dataArray;
@property(nonatomic, strong) NSIndexPath      *currentSelectIndex;
@property(nonatomic, strong) NSString         *chooseContent;
@property(nonatomic, strong) UIView           *headerView;
@property(nonatomic, strong) UIButton         *increaseBtn;
@end

@implementation TXInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"常用发票抬头";
    [self.view showLoadingViewWithText:@"请稍后..."];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.increaseBtn];
    [self.increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(@(10));
        make.right.equalTo(self.headerView.mas_right).offset(-15);
        make.bottom.equalTo(self.headerView.mas_bottom).offset(-10);
    }];
    [self getInvoiceDataRuquest];
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getInvoiceDataRuquest];
    }];
    MV(weakSelf)
    [self.increaseBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        TXAddInvoiceViewController *vc = [[TXAddInvoiceViewController alloc] init];
        vc.invoiceBlock = ^{
            [weakSelf getInvoiceDataRuquest];
        };
        vc.title = @"新增发票";
        TTPushVC(vc);
    }];
}

- (void) getInvoiceDataRuquest{
    [SCHttpTools getWithURLString:kHttpURL(@"invoice/queryInvoiceList") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXInvoiceModel *model = [TXInvoiceModel mj_objectWithKeyValues:result];
        if (model.errorcode==20000) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.list];
        }else{
            Toast(model.message);
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
        [self.view dismissLoadingView];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma UITableViewDelegate - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"reuseIdentifier%ld",(long)indexPath.row];
    TXInvoiceTableViewCell * tools = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!tools) {
        tools = [[TXInvoiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    InvoiceModel *musicModel = [self.dataArray objectAtIndex:indexPath.row];
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
    tools.editBtn.tag = indexPath.row;
    MV(weakSelf)
    [tools.editBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        TXAddInvoiceViewController *vc = [[TXAddInvoiceViewController alloc] initInvoiceModel:musicModel];
        vc.title = @"修改发票";
        vc.invoiceBlock = ^{
            [weakSelf getInvoiceDataRuquest];
        };
        TTPushVC(vc);
    }];
    tools.titleLabel.text = musicModel.invoiceTaxNumber;
    if ([self.chooseContent isEqualToString:tools.titleLabel.text]) {
        [tools updateCellWithState:YES];
    } else{
        [tools updateCellWithState:NO];
    }
    return tools;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentSelectIndex!=nil&&_currentSelectIndex != indexPath) {
        NSIndexPath *  beforIndexPath = [NSIndexPath indexPathForRow:_currentSelectIndex.row inSection:0];
        //如果之前decell在当前屏幕，把之前选中cell的状态取消掉
        TXInvoiceTableViewCell * cell = [tableView cellForRowAtIndexPath:beforIndexPath];
        [cell updateCellWithState:NO];
    }
    TXInvoiceTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell updateCellWithState:!cell.isSelected];
    self.chooseContent = cell.titleLabel.text;
    InvoiceModel *musicModel = [self.dataArray objectAtIndex:indexPath.row];
    _currentSelectIndex = indexPath;
    if (self.selectBlock) {
        self.selectBlock(musicModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXInvoiceTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        // 拖动tableView时收起键盘
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
//        for (int i=0; i<20; i++) {
//            MusicModel *music = [[MusicModel alloc] init];
//            music.kid = [NSString stringWithFormat:@"%d",i];
//            music.musicName = [NSString stringWithFormat:@"你给我听好 --- %d",i];
//            music.musicURL = @"音乐链接地址";
//            music.musicExt = @".mp3";
//            [_dataArray addObject:music];
//        }
    }
    return _dataArray;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView lz_viewWithColor:kClearColor];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 80);
    }
    return _headerView;
}

- (UIButton *)increaseBtn{
    if (!_increaseBtn) {
        _increaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_increaseBtn setImage:kGetImage(@"c51_plus_add") forState:UIControlStateNormal];
        [_increaseBtn lz_setCornerRadius:5.0];
        [_increaseBtn setBorderWidth:1.0];
        [_increaseBtn setBorderColor:kTextColor102];
    }
    return _increaseBtn;
}
@end
