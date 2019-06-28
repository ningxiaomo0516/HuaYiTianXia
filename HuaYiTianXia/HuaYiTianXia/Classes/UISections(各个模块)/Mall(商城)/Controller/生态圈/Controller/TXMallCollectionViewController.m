//
//  TXMallCollectionViewController.m
//  HuaYiTianXia
//  生态产业控制器
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMallCollectionViewController.h"
#import "TXMallToolsCollectionViewCell.h"
#import "TXGeneralModel.h"
#import "TXMallBannerCollectionViewCell.h"
#import "TXMallCollectionViewCell.h"
#import "TXMallGoodsDetailsViewController.h"
#import "TXNewsModel.h"
#import "TXMallHotTableViewCell.h"
#import "TXEppoListViewController.h"

static NSString* reuseIdentifier        = @"TXMallToolsCollectionViewCell";
static NSString* reuseIdentifierBanner  = @"TXMallBannerCollectionViewCell";
static NSString* reuseIdentifierMall    = @"TXMallCollectionViewCell";
static NSString* reuseIdentifierHot     = @"TXMallHotTableViewCell";

@interface TXMallCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *toolsArray;
@property (nonatomic, strong) NSMutableArray *bannerArray;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation TXMallCollectionViewController

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
    
    return 4;
}

// 每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==0||section==2) return 1;
    else if (section==3) return self.dataArray.count;
    else return self.toolsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        TXMallBannerCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        tools.bannerArray = self.bannerArray;
        return tools;
    }else if (indexPath.section==2) {
        TXMallHotTableViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierHot forIndexPath:indexPath];
        return tools;
    }else if (indexPath.section==3) {
        TXMallCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMall forIndexPath:indexPath];
        tools.recordsModel = self.dataArray[indexPath.row];
        return tools;
    }else{
        TXMallToolsCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        TXGeneralModel* templateModel = self.toolsArray[indexPath.row];
        tools.titleLabel.text = templateModel.title;
        NSString *imagesName = [NSString stringWithFormat:@"c09_tools_%@",templateModel.title];
        tools.imagesView.image = kGetImage(imagesName);
        return tools;
    }
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        TXEppoListViewController *vc = [[TXEppoListViewController alloc] init];
        TXGeneralModel* templateModel = self.toolsArray[indexPath.row];
        vc.title = templateModel.title;
        vc.idx = indexPath.row+1;
        vc.status = [self.title integerValue];
        TTPushVC(vc);
    }else if(indexPath.section==3){
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
    if (indexPath.section==0) return CGSizeMake(kScreenWidth, IPHONE6_W(165));
    else if (indexPath.section==1)return CGSizeMake(width, IPHONE6_W(95));
    else if (indexPath.section==2)return CGSizeMake(kScreenWidth, IPHONE6_W(95*2+30));
    CGFloat margin = 10*3;
    return CGSizeMake((kScreenWidth-margin)/2, IPHONE6_W(240));
}

//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section==1) return UIEdgeInsetsMake(0,1,0,1);
    if (section==3) return UIEdgeInsetsMake(0,10,0,10);
    return UIEdgeInsetsMake(0,0,0,0);
}

//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(self.view.width,10);
}

/// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==3) {
        return CGSizeMake(self.view.width,40);
    }else{
        return CGSizeMake(0.0001f,0.0001f);
    }
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {\
    if (indexPath.section==3) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"STCYHeaderViewSectioin3" forIndexPath:indexPath];
        headerView.backgroundColor = kClearColor;
        UILabel *titlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeScBold17];
        [headerView addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(headerView);
            make.height.equalTo(@(30));
        }];
        titlelabel.text = @"精选商品";
        UIView *leftView = [UIView lz_viewWithColor:kLinerViewColor];
        UIView *rightView = [UIView lz_viewWithColor:kLinerViewColor];
        [headerView addSubview:leftView];
        [headerView addSubview:rightView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titlelabel);
            make.height.equalTo(@(0.7));
            make.width.equalTo(@(32));
            make.right.equalTo(titlelabel.mas_left).offset(-5);
        }];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.width.equalTo(leftView);
            make.left.equalTo(titlelabel.mas_right).offset(5);
        }];
        return headerView;
    }else{
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"STCYHeaderView" forIndexPath:indexPath];
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
        [_collectionView registerClass:[TXMallToolsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerClass:[TXMallBannerCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierBanner];
        [_collectionView registerClass:[TXMallCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierMall];
        [_collectionView registerClass:[TXMallHotTableViewCell class] forCellWithReuseIdentifier:reuseIdentifierHot];
        //注册头视图
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"STCYHeaderView"];
        //注册头视图
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"STCYHeaderViewSectioin3"];
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
        NSArray* titleArr = @[@"农业",@"蔬菜",@"水果",@"其它"];
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
@end
