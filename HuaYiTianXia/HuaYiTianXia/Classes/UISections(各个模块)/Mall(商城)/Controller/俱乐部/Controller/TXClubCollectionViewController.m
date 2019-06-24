//
//  TXClubCollectionViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXClubCollectionViewController.h"
#import "TXMallToolsCollectionViewCell.h"
#import "TXGeneralModel.h"
#import "TXMallBannerCollectionViewCell.h"

#import "TXClubCollectionViewCell.h"
#import "TXClubCollectionHeaderView.h"
#import "TXClubCollectionFooterView.h"
#import "TXBannerCollectionViewCell.h"

#import "TXMallCollectionViewCell.h"

/// 跳转购机详情或者体验详情
#import "TXClubChildRecommendedViewController.h"
/// 跳转培训(课程)详情
#import "TXClubExperienceChildViewController.h"
/// 精选详情
#import "TXMallGoodsDetailsViewController.h"
/// 培训(热门)列表
#import "TXClubExperienceMainViewController.h"
/// 体验(专区)列表
#import "TXClubChildExperienceViewController.h"
/// 购机(推荐)列表
#import "TXClubRecommendedViewController.h"
#import "TXCourseModel.h"

@interface TXClubCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView * collectionView;
/// 优秀产品数据
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *toolsArray;
@property (nonatomic, strong) NSMutableArray *bannerArray;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) MallClubModel *listArray;


@end

@implementation TXClubCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.pageSize = 20;
    self.pageIndex = 1;
    [self initView];
    [self.view showLoadingViewWithText:@"加载中..."];
    [self loadMallData];
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将页码重新置为1
        self.pageIndex = 1;
        [self loadMallData];
    }];
    /// 上拉加载
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;// 页码+1
        [self loadMallData];
    }];
}

- (void) loadMallData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@([self.title integerValue]) forKey:@"status"];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    
    TTLog(@"parameter -- %@",parameter);
    [SCHttpTools postWithURLString:@"shopproduct/GetShopPro" parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TTLog(@"result -- %@",result);
        if (self.pageIndex==1) {
            [self.dataArray removeAllObjects];
            [self.bannerArray removeAllObjects];
        }
        TXNewsArrayModel *model = [TXNewsArrayModel mj_objectWithKeyValues:result];
        [self.dataArray addObjectsFromArray:model.data.records];
        if (self.pageIndex==1) {
            [self.bannerArray addObjectsFromArray:model.banners];
            self.listArray = model.listArray;
        }
        [self.collectionView reloadData];
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.view dismissLoadingView];
    }];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void) initView{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
}

/// 跳转对应的界面
- (void) jumpMallChildsViewController_did:(NSIndexPath *) indexPath{
    NSInteger idx=0;
    if (indexPath.section==2) idx = 0;
    if (indexPath.section==3) idx = 1;
    if (indexPath.section==4) idx = 2;
    [self jumpMallChildsViewController:idx];
}

- (void) jumpMallChildsViewController:(NSInteger)idx{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    if (idx==1) {// 培训
        TXClubExperienceMainViewController *vc = [[TXClubExperienceMainViewController alloc] init];
        TTPushVC(vc);
    }else if(idx==2){// 体验
        [parameter setObject:@"2" forKey:@"pageType"];
        TXClubChildExperienceViewController *vc = [[TXClubChildExperienceViewController alloc] initParameter:parameter];
        TTPushVC(vc);
    }else{
        if (idx==0) {/// 购机
            [parameter setObject:@"1" forKey:@"pageType"];
        }else if(idx==3){
            [parameter setObject:@"3" forKey:@"pageType"];
            /// 暂无跳转
            return;
        }else{
            [parameter setObject:@"0" forKey:@"pageType"];
        }
        TXClubRecommendedViewController *vc = [[TXClubRecommendedViewController alloc] initParameter:parameter];
        TTPushVC(vc);
    }
}

/// 跳转详情
- (void) jumpProductDetails:(NSIndexPath *) indexPath{
    if (indexPath.section==1) {
        [self jumpMallChildsViewController:indexPath.row];
    }else if (indexPath.section==2||indexPath.section==3) {
        MallClubListModel *listModel = (indexPath.section==2)?self.listArray.recommended[indexPath.row]:self.listArray.hot[indexPath.row];
        TXClubChildRecommendedViewController *vc = [[TXClubChildRecommendedViewController alloc] initListModel:listModel];
        vc.title = (indexPath.section==2)?@"商品详情":@"体验详情";
        TTPushVC(vc);
    }else if(indexPath.section==4){
        MallClubListModel *listModel = self.listArray.jingxuan[indexPath.row];
        CourseListModel *model = [[CourseListModel alloc] init];
        model.kid = listModel.kid;
        TXClubExperienceChildViewController *vc = [[TXClubExperienceChildViewController alloc] initCourseListModel:model];
        TTPushVC(vc);
    }else if(indexPath.section==5){
        NewsRecordsModel *productModel = self.dataArray[indexPath.row];
        TXMallGoodsDetailsViewController *vc = [[TXMallGoodsDetailsViewController alloc] initMallProductModel:productModel];
        vc.pageType = 0;
        TTPushVC(vc);
    }
}

#pragma mark - UICollectionViewDataSource
//设置容器中有多少个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 6;
}

// 设置每个组有多少个CollectionViewCell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) return 1;
    if (section==1) return 4;
    if (section==2) return self.listArray.recommended.count>2?2:self.listArray.recommended.count;
    if (section==3) return self.listArray.hot.count>2?2:self.listArray.hot.count;
    if (section==4) return self.listArray.jingxuan.count>2?2:self.listArray.jingxuan.count;
    if (section==5) return self.dataArray.count;
    return section+1;
}

// 设置方块的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        TXBannerCollectionViewCell *tools = [TXBannerCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        tools.bannerArray = self.bannerArray;
        return tools;
    }else if(indexPath.section==1){
        TXMallToolsCollectionViewCell *tools=[TXMallToolsCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        TXGeneralModel* templateModel = self.toolsArray[indexPath.row];
        tools.titleLabel.text = templateModel.title;
        NSString *imagesName = [NSString stringWithFormat:@"c09_tools_%@",templateModel.title];
        tools.imagesView.image = kGetImage(imagesName);
        return tools;
    }else if(indexPath.section==5){
        TXMallCollectionViewCell *tools = [TXMallCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        tools.recordsModel = self.dataArray[indexPath.row];
        return tools;
    }else{
        //获取cell视图，内部通过去缓存池中取，如果缓存池中没有，就自动创建一个新的cell
        TXClubCollectionViewCell *tools=[TXClubCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        if (indexPath.section==2) {/// 对应购机
            tools.model = self.listArray.recommended[indexPath.row];
        }else if (indexPath.section==3) {/// 对应培训课程
            tools.model = self.listArray.hot[indexPath.row];
        }else if (indexPath.section==4){
            tools.model = self.listArray.jingxuan[indexPath.row];
        }
        return tools;
    }
}

// 设置顶部视图和底部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //获取顶部视图
        TXClubCollectionHeaderView *headerView = [TXClubCollectionHeaderView headerViewWithCollectionView:collectionView forIndexPath:indexPath];
        NSString *titleText = @"";
        NSString *imageName = @"";
        UIColor *colorText;
        BOOL    has_hidden  = YES;
        if (indexPath.section==2) {
            titleText = @"推荐";
            imageName = @"俱乐部_推荐";
            has_hidden = NO;
            colorText = kColorWithRGB(176, 23, 23);
        }else if (indexPath.section==3) {
            titleText = @"热门";
            imageName = @"俱乐部_热门";
            has_hidden = NO;
            colorText = kColorWithRGB(255, 108, 0);
        }else if (indexPath.section==4) {
            titleText = @"专区";
            imageName = @"俱乐部_体验课";
            has_hidden = NO;
            colorText = kColorWithRGB(86, 206, 86);
        }else{
            titleText = @"精选";
            imageName = @"俱乐部_精选";
            has_hidden = YES;
            colorText = kColorWithRGB(253, 195, 72);
        }
        headerView.moreButton.tag = indexPath.section;
        MV(weakSelf)
        [headerView.moreButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf jumpMallChildsViewController_did:indexPath];
        }];
        headerView.moreButton.hidden = has_hidden;
        headerView.imagesView.image = kGetImage(imageName);
        headerView.textLabel.text = titleText;
        headerView.textLabel.textColor = colorText;
        return headerView;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        //获取底部视图
        TXClubCollectionFooterView *footerView = [TXClubCollectionFooterView footerViewWithCollectionView:collectionView forIndexPath:indexPath];
        footerView.textLabel.text = @"";
        return footerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 设置各个CollectionViewCell的大小尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat space = 5;
    CGFloat margin = 15*2;
    CGFloat width = (kScreenWidth-space*2-margin)/2;
    CGFloat height = width;
    if (indexPath.section==0) {
        width = kScreenWidth;
        height = IPHONE6_W(165);
    }else if(indexPath.section==1){
        width = kScreenWidth/4;
        height = width;
    }else if(indexPath.section==2||indexPath.section==4){
        height = IPHONE6_W(218);
    }else if(indexPath.section==3){
        height = IPHONE6_W(200);
    }else if(indexPath.section==5){
        height = IPHONE6_W(240);
    }
    return CGSizeMake(width, height);
}

/// Cell之间的列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section==0||section==1) return 0;
    return 5;
}

/// Cell之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section==0||section==1) return 0;
    return 10;
}

// 设置每一组的上下左右间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section==0||section==1) return UIEdgeInsetsMake(0, 0, 0, 0);
    return UIEdgeInsetsMake(0, 15, 15, 15);
}
/// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0||section==1) return CGSizeMake(kScreenWidth,0);
    return CGSizeMake(kScreenWidth,40);
}
/// 设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth,0);
}

#pragma mark - UICollectionViewDelegate
// CollectionViewCell被选中会调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self jumpProductDetails:indexPath];
}
// CollectionViewCell取消选中会调用
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tipsTxext = [NSString stringWithFormat:@"取消选择第%ld组，第%ld个方块",(long)indexPath.section,(long)indexPath.row];
    TTLog(@"%@",tipsTxext);
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        // 创建布局对象
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置滚动方向为垂直滚动，说明方块是从左上到右下的布局排列方式
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //确定item的大小
        //        flowLayout.itemSize = CGSizeMake(100, 120);
        // 确定横向间距(设置行间距)
        flowLayout.minimumLineSpacing = 0;
        // 确定纵向间距(设置列间距)
        flowLayout.minimumInteritemSpacing = 0;
        // 确定距离上左下右的距离
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        // 设置顶部视图和底部视图的大小，当滚动方向为垂直时，设置宽度无效，当滚动方向为水平时，设置高度无效
        flowLayout.headerReferenceSize = CGSizeMake(100, 40);
        flowLayout.footerReferenceSize = CGSizeMake(100, 40);
        // 创建容器视图
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = kViewColorNormal;
        
        // 设置代理
        _collectionView.delegate = self;
        // 设置数据源
        _collectionView.dataSource = self;
        // 是否显示纵向滚动条
        _collectionView.showsVerticalScrollIndicator = NO;
        // 是否显示横向滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        // 是否有弹簧效果
        _collectionView.bounces = YES;
        
        /// 注册工具栏视图
        [_collectionView registerClass:[TXMallToolsCollectionViewCell class] forCellWithReuseIdentifier:[TXMallToolsCollectionViewCell reuseIdentifier]];
        /// 注册精选视图中显示的视图
        [_collectionView registerClass:[TXMallCollectionViewCell class] forCellWithReuseIdentifier:[TXMallCollectionViewCell reuseIdentifier]];

        // 注册推荐、热门、专区视图中显示的视图
        [_collectionView registerClass:[TXClubCollectionViewCell class] forCellWithReuseIdentifier:[TXClubCollectionViewCell reuseIdentifier]];
        // 注册Banner
        [_collectionView registerClass:[TXBannerCollectionViewCell class] forCellWithReuseIdentifier:[TXBannerCollectionViewCell reuseIdentifier]];

        // 注册容器视图中显示的顶部视图
        [_collectionView registerClass:[TXClubCollectionHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:[TXClubCollectionHeaderView headerViewIdentifier]];
        
        // 注册容器视图中显示的底部视图
        [_collectionView registerClass:[TXClubCollectionFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:[TXClubCollectionFooterView footerViewIdentifier]];
    }
    return _collectionView;
}

- (NSMutableArray *)toolsArray{
    if (!_toolsArray) {
        _toolsArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@"购机",@"培训",@"体验",@"活动"];
        NSArray* classArr = @[@"",@"",@"",@""];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel* templateModel = [[TXGeneralModel alloc] init];
            templateModel.title = [titleArr lz_safeObjectAtIndex:j];
            templateModel.showClass = [classArr lz_safeObjectAtIndex:j];
            [_toolsArray addObject:templateModel];
        }
    }
    return _toolsArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [[NSMutableArray alloc] init];
//        NSArray* titleArr = @[@"100张电影票 请你看大片!",@"1000张电影票 请你看大片!",@"10000张电影票 请你看大片!"];
//        NSArray* imagesArr = @[@"c31_club_banner",@"c31_club_banner1",@"c31_club_banner2"];
//        for (int j = 0; j < titleArr.count; j ++) {
//            SCBannerModel *model = [[SCBannerModel alloc] init];
//            model.titleText = [titleArr objectAtIndex:j];
//            model.imagesName = [imagesArr objectAtIndex:j];
//            [_bannerArray addObject:model];
//        }
    }
    return _bannerArray;
}
@end
