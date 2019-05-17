//
//  TXUAVChildExperienceViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXUAVChildExperienceViewController.h"
#import "TXMallCollectionViewCell.h"

#import "TTSortButton.h"
#import "TXMallUAVModel.h"
#import "TXUAVChildRecommendedViewController.h"
NSInteger const kSortButtonBeginTag = 1000;
static NSString* reuseIdentifierMall    = @"TXMallCollectionViewCell";

@interface TXUAVChildExperienceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageType;
@property (nonatomic, strong) SCNoDataView *noDataView;
/// 顶部排序
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) NSInteger sortType;

@end

@implementation TXUAVChildExperienceViewController
- (id)initParameter:(NSDictionary *)parameter{
    if ( self = [super init] ){
        self.pageType = [parameter[@"pageType"] integerValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageSize = 20;
    self.pageIndex = 1;
    self.sortType = 1;
    self.title = @"体验服务";
    [self initView];
    [self.view showLoadingViewWithText:@"加载中..."];
    [self requestData];
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将页码重新置为1
        self.pageIndex = 1;
        [self requestData];
    }];
    /// 上拉加载
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;// 页码+1
        [self requestData];
    }];
}

- (void) requestData{
    /// 分类ID 1:购机  2:体验 3:活动;
    /// 查询排序方式 1:销量降序 2:销量升序 3:价格降序 4:价格升序 5:新品降序 6:新品升序
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    [parameter setObject:@(self.pageType) forKey:@"type"];      // 每页条数
    [parameter setObject:@(self.sortType) forKey:@"sortType"];  // 排序
    [SCHttpTools postWithURLString:kHttpURL(@"flightproduct/flightProductPage") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXMallUAVModel *model = [TXMallUAVModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                if (self.pageIndex==1) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:model.data.list];
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"我的团队数据获取失败");
        }
        [self analysisData];
        [self.view dismissLoadingView];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.view dismissLoadingView];
    }];
}

- (void)analysisData {
    if (self.dataArray.count == 0) {
        self.noDataView.hidden = NO;
    }else {
        self.noDataView.hidden = YES;
    }
}

- (void) initView{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(40));
    }];
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXMallCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMall forIndexPath:indexPath];
    MallUAVListModel *listModel = self.dataArray[indexPath.row];
    [tools.imagesView sd_setImageWithURL:[NSURL URLWithString:listModel.coverimg] placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    tools.titleLabel.text = listModel.title;
    tools.subtitleLabel.text = listModel.synopsis;
    tools.marketPriceLabel.text = [NSString stringWithFormat:@"￥%@",listModel.startPrice];
    return tools;
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MallUAVListModel *listModel = self.dataArray[indexPath.row];
    TXUAVChildRecommendedViewController *vc = [[TXUAVChildRecommendedViewController alloc] initListModel:listModel];
    vc.title = @"体验详情";
    TTPushVC(vc);
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat margin = 15*2+10;
    return CGSizeMake((kScreenWidth-margin)/2, IPHONE6_W(230));
}

//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,15,0,15);
}

//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(self.view.width,10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //确定滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //确定item的大小
        //        flowLayout.itemSize = CGSizeMake(100, 120);
        //确定横向间距(设置行间距)
        flowLayout.minimumLineSpacing = 10;
        //确定纵向间距(设置列间距)
        flowLayout.minimumInteritemSpacing = 0;
        //确定距离上左下右的距离
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //头尾部高度
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        flowLayout.footerReferenceSize = CGSizeMake(0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[TXMallCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierMall];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = YES;
    }
    return _collectionView;
}

- (SCNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[SCNoDataView alloc] initWithFrame:self.view.bounds
                                                imageName:@"c12_live_nodata"
                                            tipsLabelText:@"暂无数据哦~"];
        _noDataView.userInteractionEnabled = NO;
        [self.view insertSubview:_noDataView aboveSubview:self.collectionView];
        [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.height.mas_equalTo(150);
        }];
    }
    return _noDataView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView lz_viewWithColor:kWhiteColor];
        NSArray *titleArray = @[@"热门", @"价格", @"新品"];
        NSMutableArray *buttonArray = [NSMutableArray array];
        for (int i = 0; i < titleArray.count; i++) {
            TTSortButton *button = [[TTSortButton alloc] init];
            [_headerView addSubview:button];
            button.buttonTitle = titleArray[i];
            button.tag = kSortButtonBeginTag + i;
            MV(weakSelf)
            [button lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                [weakSelf sortButtonClicked:button dataArray:titleArray];
            }];
            [buttonArray addObject:button];
            /// 默认选中第一个
            button.selected = (i==0)?YES:NO;
            /// 默认降序
            button.hasAscending = NO;
        }
        
        // 按钮等宽依次排列
        [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
    }
    return _headerView;
}


- (void) sortButtonClicked:(TTSortButton *) sender dataArray:(NSArray*)dataArray{
    for (int i = 0; i < dataArray.count; i++) {
        TTSortButton *button = [self.headerView viewWithTag:(kSortButtonBeginTag + i)];
        button.selected = (button.tag == sender.tag);
    }
    NSInteger idx = sender.tag - kSortButtonBeginTag;
    TTLog(@"第%ld个按钮点击，状态：%@", (long)(idx), sender.isAscending ? @"升序" : @"降序");
    //    查询排序方式 1:销量降序; 2:销量升序; 3:价格降序; 4:价格升序; 5:新品降序;6:新品升序
    /// sender.isAscending 正反序反着用就对了
    switch (idx) {
        case 0:
            self.sortType = sender.isAscending?1:2;
            [self requestData];
            break;
        case 1:
            self.sortType = sender.isAscending?3:4;
            [self requestData];
            break;
        case 2:
            self.sortType = sender.isAscending?5:6;
            [self requestData];
            break;
        default:
            break;
    }
}
@end
