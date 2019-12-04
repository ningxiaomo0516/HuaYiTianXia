//
//  TXCharterSpellMachineViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterSpellMachineViewController.h"
#import "TXCharterSpellMachineView.h"
#import "TXCharterSpellMachineCollectionViewCell.h"
#import "TXCharterMachineModel.h"
#import "TXCharterMachineViewController.h"
#import "TXCharterMachineChildViewController.h"

static NSString * const reuseIdentifier = @"TXCharterSpellMachineCollectionViewCell";
@interface TXCharterSpellMachineViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong) TXCharterSpellMachineView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation TXCharterSpellMachineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    [self.headerView.searchView whenTapped:^{
        TXCharterMachineViewController *vc = [[TXCharterMachineViewController alloc] init];
        TTPushVC(vc);
    }];
    [self.headerView.citylabel whenTapped:^{
//        Toast(@"城市选择");
    }];
    [self.headerView.backButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.pageSize = 20;
    self.pageIndex = 1;
    [self.view showLoadingViewWithText:@"加载中..."];
    [self requestCurrentData];

    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将页码重新置为1
        self.pageIndex = 1;
        [self requestCurrentData];
    }];

    /// 上拉加载
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;// 页码+1
        [self requestCurrentData];
    }];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (void) initView{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
}

/// 请求拼机包机数据
- (void) requestCurrentData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    NSString *URLString = kHttpURL(@"aircraftinformation/queryHomeAircraftinList");
    [SCHttpTools postWithURLString:URLString parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXCharterMachineModel *model = [TXCharterMachineModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000) {
            if (self.pageIndex==1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:model.data.list];
        }else{
            Toast(model.message);
        }
        [self analysisData];
        [self.view dismissLoadingView];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.loadFailedView.hidden = YES;
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.view dismissLoadingView];
        self.loadFailedView.hidden = NO;
    }];
}

- (void)analysisData {
    if (self.dataArray.count == 0) {
        self.noDataView.hidden = NO;
    }else {
        self.noDataView.hidden = YES;
    }
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

// 每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXCharterSpellMachineCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.section<3) {
        NSInteger idx = indexPath.section+1;
        NSString *imagesName = [NSString stringWithFormat:@"lv28_btn_no%ld",(long)idx];
        tools.imagesRank.image = kGetImage(imagesName);
    }else{
        tools.imagesRank.hidden = YES;
    }
    tools.machineModel = self.dataArray[indexPath.section];
    return tools;
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CharterMachineModel *model = self.dataArray[indexPath.section];
    TXCharterMachineChildViewController *vc = [[TXCharterMachineChildViewController alloc] initTicketModel:model];
    vc.webUrl = kAppendH5URL(DomainName, CharterDetailsH5,model.kid);
    TTPushVC(vc);
}

/// 布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
/// 设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth-30), IPHONE6_W(250));
}

/// 设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(section==0)return UIEdgeInsetsMake(15,15,15 ,15);
    return UIEdgeInsetsMake(0,15,15,15);
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //确定滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //确定item的大小
        //        flowLayout.itemSize = CGSizeMake(100, 120);
        //确定横向间距(设置行间距)
        flowLayout.minimumLineSpacing = 0;
        //确定纵向间距(设置列间距)
        flowLayout.minimumInteritemSpacing = 0;
        //确定距离上左下右的距离
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //头尾部高度
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        flowLayout.footerReferenceSize = CGSizeMake(0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[TXCharterSpellMachineCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = YES;
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (TXCharterSpellMachineView *)headerView{
    if (!_headerView) {
//        CGRect rect = CGRectMake(0, 0, kScreenWidth, IPHONE6_W(150)+kNavBarHeight);
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kNavBarHeight);
        _headerView = [[TXCharterSpellMachineView alloc] initWithFrame:rect];
        _headerView.buttonView.hidden = YES;
    }
    return _headerView ;
}

@end
