//
//  TXCharterMachineViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/31.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterMachineViewController.h"
#import "TXCharterMachineHeaderView.h"
#import "TXCharterMachineCollectionViewCell.h"
#import "TXCharterMachineModel.h"
#import "TXCharterMachineDateView.h"
#import "LZDatePickerView.h"
#import "TXCharterMachineChildViewController.h"

static NSString * const reuseIdentifier = @"TXCharterMachineCollectionViewCell";
@interface TXCharterMachineViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong) TXCharterMachineHeaderView *headerView;
@property (nonatomic, strong) TXCharterMachineDateView *dateView;

@property (nonatomic, strong) NSMutableArray *dataArray;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation TXCharterMachineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"包机";
    self.pageSize = 20;
    self.pageIndex = 1;
    [self.view showLoadingViewWithText:@"加载中..."];
    [self initView];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (void) initView{
    
    NSString *startDate = self.dateView.startDateButton.currentTitle;
    NSString *endDate = self.dateView.endDateButton.currentTitle;
    [self requestCurrentData:startDate endDate:endDate];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.dateView];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.dateView.mas_bottom);
    }];
    MV(weakSelf)
    [self.dateView.startDateButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        TTLog(@"开始日期");
        [weakSelf showDataPicker:weakSelf.dateView.startDateButton];
    }];
    [self.dateView.endDateButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        TTLog(@"结束日期");
        [weakSelf showDataPicker:weakSelf.dateView.endDateButton];
    }];
    [self.dateView.screeningButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        kShowMBProgressHUD(weakSelf.view);
        [weakSelf requestCurrentData:startDate endDate:endDate];
    }];
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将页码重新置为1
        self.pageIndex = 1;
        [self requestCurrentData:startDate endDate:endDate];
    }];
    
    /// 上拉加载
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;// 页码+1
        [self requestCurrentData:startDate endDate:endDate];
    }];
}

/// 选择机票查询日期
- (void) showDataPicker:(UIButton *)sender{
    [self tapGesture];
    NSString *minDateStr = [Utils lz_getCurrentTime];
    NSString *maxDateStr = @"";
    NSString *defaultSelValue = @"";
    if (sender.tag == 100) {
        defaultSelValue = self.dateView.startDateButton.currentTitle;
    }else if(sender.tag == 200){
        defaultSelValue = self.dateView.endDateButton.currentTitle;
    }
    MV(weakSelf)
    /**
     *  显示时间选择器
     *
     *  @param title            标题
     *  @param type             类型（时间、日期、日期和时间、倒计时）
     *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
     *  @param minDateStr       最小时间（如：2015-08-28 00:00:00），可为空
     *  @param maxDateStr       最大时间（如：2018-05-05 00:00:00），可为空
     *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
     *  @param resultBlock      选择结果的回调
     *
     */
    [LZDatePickerView showDatePickerWithTitle:@"" dateType:UIDatePickerModeDate defaultSelValue:defaultSelValue minDateStr:minDateStr maxDateStr:maxDateStr isAutoSelect:NO resultBlock:^(NSString *selectValue) {
        if (sender.tag==100) {
            [weakSelf.dateView.startDateButton setTitle:selectValue forState:UIControlStateNormal];
        }else{
            [weakSelf.dateView.endDateButton setTitle:selectValue forState:UIControlStateNormal];
        }
    }];
}


/// 请求拼机包机数据
- (void) requestCurrentData:(NSString *)startDate endDate:(NSString *)endDate{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    [parameter setObject:startDate forKey:@"startTime"];        // 开始日期
    [parameter setObject:endDate forKey:@"endTime"];            // 结束日期
    
    NSString *URLString = kHttpURL(@"aircraftinformation/queryAircraftinList");
    [SCHttpTools postWithURLString:URLString parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXCharterMachineModel *model = [TXCharterMachineModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                if (self.pageIndex==1) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:model.data.list];
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"我的邀请数据获取失败");
        }
        [self analysisData];
        [self.view dismissLoadingView];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.loadFailedView.hidden = YES;
        kHideMBProgressHUD(self.view);
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.view dismissLoadingView];
        self.loadFailedView.hidden = NO;
        kHideMBProgressHUD(self.view);
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
    TXCharterMachineCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.machineModel = self.dataArray[indexPath.section];
    return tools;
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TXCharterMachineChildViewController *vc = [[TXCharterMachineChildViewController alloc] init];
    CharterMachineModel *model = self.dataArray[indexPath.section];
    vc.webUrl = kAppendH5URL(DomainName, CharterDetailsH5,model.kid);
    TTPushVC(vc);
}


/// 设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(section==0)return UIEdgeInsetsMake(10,15,10,15);
    return UIEdgeInsetsMake(0,15,10,15);
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //确定滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //确定item的大小
        flowLayout.itemSize = CGSizeMake((kScreenWidth-30), IPHONE6_W(100));
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
        [_collectionView registerClass:[TXCharterMachineCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
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

- (TXCharterMachineHeaderView *)headerView{
    if (!_headerView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kNavBarHeight);
        _headerView = [[TXCharterMachineHeaderView alloc] initWithFrame:rect];
        _headerView.titlelabel.text = @"航班查询";
    }
    return _headerView ;
}

- (TXCharterMachineDateView *)dateView{
    if (!_dateView) {
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreenWidth, IPHONE6_W(40));
        _dateView = [[TXCharterMachineDateView alloc] initWithFrame:rect];
    }
    return _dateView;
}
@end
