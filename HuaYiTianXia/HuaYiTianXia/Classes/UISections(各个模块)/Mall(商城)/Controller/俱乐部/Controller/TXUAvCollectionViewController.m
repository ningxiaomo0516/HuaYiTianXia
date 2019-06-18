//
//  TXUAvViewController.m
//  HuaYiTianXia
//  俱乐部
//  Created by 宁小陌 on 2019/5/10.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXUAvCollectionViewController.h"
#import "TXMallToolsCollectionViewCell.h"
#import "TXGeneralModel.h"
#import "TXMallBannerCollectionViewCell.h"
#import "TXMallCollectionViewCell.h"
#import "TTTemplateThreeTableViewCell.h"
#import "TXMallGoodsDetailsViewController.h"
#import "TXNewsModel.h"
#import "TXMallUAVModel.h"

#import "TXMallUAVHotTableViewCell.h"
#import "TXMallUAVAdTableViewCell.h"
#import "TXMallUAVRecommendTableViewCell.h"

/// 购机
#import "TXUAVRecommendedViewController.h"
/// 培训(课程)
#import "TXUAVExperienceMainViewController.h"
/// 体验
#import "TXUAVChildExperienceViewController.h"
/// 培训(课程)详情
#import "TXUAVExperienceChildViewController.h"

#import "TXBaseCollectionReusableHeaderView.h"
/// 购机(体验)详情
#import "TXUAVChildRecommendedViewController.h"
#import "TXPurchaseAgreementViewController.h"

static NSString* reuseIdentifier        = @"TXMallToolsCollectionViewCell";
static NSString* reuseIdentifierBanner  = @"TXMallBannerCollectionViewCell";
static NSString* reuseIdentifierMall    = @"TXMallCollectionViewCell";
static NSString* reuseIdentifierUAV     = @"TTTemplateThreeTableViewCell";

static NSString* reuseIdentifierHot         = @"TXMallUAVHotTableViewCell";
static NSString* reuseIdentifierAd          = @"TXMallUAVAdTableViewCell";
static NSString* reuseIdentifierRecommend   = @"TXMallUAVRecommendTableViewCell";

static NSString *headerViewIdentifier       = @"TXBaseCollectionReusableHeaderView";

@interface TXUAvCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView * collectionView;
/// 优秀产品数据
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *toolsArray;
@property (nonatomic, strong) NSMutableArray *bannerArray;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) MallUAVModel *listArray;

@property (nonatomic, strong) UIView *headerView;
@end

@implementation TXUAvCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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

- (void) initView{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}

// 每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==1) return self.toolsArray.count;
    else if (section<5) return 1;
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        TXMallBannerCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        tools.bannerArray = self.bannerArray;
        return tools;
    }else if(indexPath.section==1){
        TXMallToolsCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        TXGeneralModel* templateModel = self.toolsArray[indexPath.row];
        tools.titleLabel.text = templateModel.title;
        NSString *imagesName = [NSString stringWithFormat:@"c09_tools_%@",templateModel.title];
        tools.imagesView.image = kGetImage(imagesName);
        return tools;
    } else if (indexPath.section==5) {
        TXMallCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMall forIndexPath:indexPath];
        tools.recordsModel = self.dataArray[indexPath.row];
        return tools;
    }else{
        MV(weakSelf)
        if (indexPath.section==2) {/// 对应购机
            TXMallUAVRecommendTableViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierRecommend forIndexPath:indexPath];
            tools.selectBlock = ^(MallUAVListModel * _Nonnull listModel) {
                [weakSelf jumpRecommendDetails:listModel titleText:@"商品详情"];
            };
            tools.listModel = self.listArray;
            return tools;
        }else if (indexPath.section==3) {/// 对应培训课程
            TXMallUAVHotTableViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierHot forIndexPath:indexPath];
            tools.listModel = self.listArray;
            tools.selectBlock = ^(MallUAVListModel * _Nonnull listModel) {
                [weakSelf jumpCourseDetails:listModel];
            };
            return tools;
        }else if (indexPath.section==4) {
            TXMallUAVAdTableViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierAd forIndexPath:indexPath];
            tools.listModel = self.listArray;
            tools.selectBlock = ^(MallUAVListModel * _Nonnull listModel) {
                [weakSelf jumpRecommendDetails:listModel titleText:@"体验详情"];
            };
            return tools;
        }else{
            TTTemplateThreeTableViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierUAV forIndexPath:indexPath];
            self.listArray.sectionType = indexPath.section;
            tools.listModel = self.listArray;
            return tools;
        }
    }
}

//// 跳转购机详情或者体验详情
- (void) jumpRecommendDetails:(MallUAVListModel *)listModel titleText:(NSString *)titleText{
    TXUAVChildRecommendedViewController *vc = [[TXUAVChildRecommendedViewController alloc] initListModel:listModel];
    vc.title = titleText;
    TTPushVC(vc);
}

//// 跳转培训(课程)详情
- (void) jumpCourseDetails:(MallUAVListModel *)listModel{
    CourseListModel *model = [[CourseListModel alloc] init];
    model.kid = listModel.kid;
    TXUAVExperienceChildViewController *vc = [[TXUAVExperienceChildViewController alloc] initCourseListModel:model];
    TTPushVC(vc);
}


/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        if (indexPath.row==1) {
            TXUAVExperienceMainViewController *vc = [[TXUAVExperienceMainViewController alloc] init];
            TTPushVC(vc);
        }else if(indexPath.row==2){
            [parameter setObject:@"2" forKey:@"pageType"];
            TXUAVChildExperienceViewController *vc = [[TXUAVChildExperienceViewController alloc] initParameter:parameter];
            TTPushVC(vc);
        }else{
            if (indexPath.row==0) {
                [parameter setObject:@"1" forKey:@"pageType"];
            }else if(indexPath.row==3){
                [parameter setObject:@"3" forKey:@"pageType"];
                /// 暂无跳转
                return;
            }else{
                [parameter setObject:@"0" forKey:@"pageType"];
            }
            TXUAVRecommendedViewController *vc = [[TXUAVRecommendedViewController alloc] initParameter:parameter];
            TTPushVC(vc);
        }
    }else if(indexPath.section==5){
        NewsRecordsModel *productModel = self.dataArray[indexPath.row];
        TXMallGoodsDetailsViewController *vc = [[TXMallGoodsDetailsViewController alloc] initMallProductModel:productModel];
        vc.pageType = 0;
        TTPushVC(vc);
    }
}

/// 同一行的cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (kScreenWidth-2)/4;
    CGFloat height = 0;
    if (indexPath.section==2) {
        // 两个显示，40位顶部title高度，10为底部间距
        height = (kScreenWidth-15*2-10)/2+40+10;
    }else if (indexPath.section==3){
        // 110图片加文字高度，40位顶部title高度
        height = 110+40;
    }else if(indexPath.section==4){
        // 150图片加文字高度，40位顶部title高度
        height = 150+40;
    }
    if (indexPath.section==0) return CGSizeMake(kScreenWidth, IPHONE6_W(165));
    else if (indexPath.section==1)return CGSizeMake(width, IPHONE6_W(95));
    else if (indexPath.section<5)return CGSizeMake(kScreenWidth, height);
    CGFloat margin = 10*3;
    return CGSizeMake((kScreenWidth-margin)/2, IPHONE6_W(240));
}

//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section==1) return UIEdgeInsetsMake(0,1,0,1);
    if (section<5) return UIEdgeInsetsMake(0,0,0,0);
    return UIEdgeInsetsMake(0,10,0,10);
}

/// 设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(self.view.width,10);
}

/// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==5) {
        return CGSizeMake(self.view.width,40);
    }else{
        return CGSizeMake(0.0001f,0.0001f);
    }
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==5) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MGHeaderView" forIndexPath:indexPath];
        headerView.backgroundColor = kWhiteColor;
        UILabel *titlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeScBold17];
        [headerView addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.centerY.equalTo(headerView);
        }];
        titlelabel.text = @"优秀产品";
        return headerView;
    }else{
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MGHeaderViewSection5" forIndexPath:indexPath];
        
        return headerView;
    }
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
        [_collectionView registerClass:[TXMallToolsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerClass:[TXMallBannerCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierBanner];
        [_collectionView registerClass:[TXMallCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierMall];
        [_collectionView registerClass:[TTTemplateThreeTableViewCell class] forCellWithReuseIdentifier:reuseIdentifierUAV];
        
        [_collectionView registerClass:[TXMallUAVHotTableViewCell class] forCellWithReuseIdentifier:reuseIdentifierHot];
        [_collectionView registerClass:[TXMallUAVAdTableViewCell class] forCellWithReuseIdentifier:reuseIdentifierAd];
        [_collectionView registerClass:[TXMallUAVRecommendTableViewCell class] forCellWithReuseIdentifier:reuseIdentifierRecommend];

        //注册头视图
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MGHeaderView"];//注册头视图
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MGHeaderViewSection5"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = YES;
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
    }
    return _bannerArray;
}

- (MallUAVModel *)listArray{
    if (!_listArray) {
        _listArray = [[MallUAVModel alloc] init];
    }
    return _listArray;
}

/*
 *  补充头部内容
 */
-(void)addContent {
    UIView *headerView=[[UIView alloc]init];
    headerView.backgroundColor = kWhiteColor;
    headerView.frame=CGRectMake(0, 0, self.view.width - 20, 44);
    
    UIView *yellowView = [[UIView alloc]initWithFrame:CGRectMake(10, (headerView.frame.size.height - 13) / 2, 3, 13)];
    yellowView.backgroundColor = kWhiteColor;
    [headerView addSubview:yellowView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 0, self.view.width - 20 - 33, headerView.frame.size.height)];
    titleLabel.font = [UIFont systemFontOfSize:12.0];
    titleLabel.text = @"户口办理";
    titleLabel.textColor = kRedColor;
    [headerView addSubview:titleLabel];
    
    self.headerView=headerView;
}

@end
