//
//  TXMainViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/9/4.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMainViewController.h"
#import "TXBannerCollectionViewCell.h"
#import "TXClubCollectionHeaderView.h"
#import "TXClubCollectionFooterView.h"
#import "TXMainCollectionViewCell.h"
#import "TXMainToolsCollectionViewCell.h"
#import "SCBannerModel.h"
#import "TXCharterSpellMachineViewController.h"

#import "TXCharterMachineModel.h"
#import "TXCharterMachineChildViewController.h"
#import "TXMainModel.h"

#import "TXOrderViewController.h"


@interface TXMainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView * collectionView;
/// 优秀产品数据
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *toolsArray;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@end

@implementation TXMainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"华翼天下";
    [self initView];
    
    [self requestMaintData];
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestMaintData];
    }];
}

- (void) requestMaintData{
    NSString *URLString = @"aircraftinformation/index";
    [SCHttpTools postWithURLString:URLString parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXMainModel *model = [TXMainModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.data.list];
            
            [self.bannerArray removeAllObjects];
            [self.bannerArray addObjectsFromArray:model.data.banners];
        }else{
            Toast(model.message);
        }
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

- (void) initView{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
    }];
}

#pragma mark - UICollectionViewDataSource
//设置容器中有多少个组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

// 设置每个组有多少个CollectionViewCell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) return 1;
    if (section==1) return self.toolsArray.count;
    return self.dataArray.count;
}

// 设置方块的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        TXBannerCollectionViewCell *tools = [TXBannerCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        tools.isPageControl = YES;
        tools.bannerArray = self.bannerArray;
        return tools;
    }else if(indexPath.section==1){
        //获取cell视图，内部通过去缓存池中取，如果缓存池中没有，就自动创建一个新的cell
        TXMainToolsCollectionViewCell *tools=[TXMainToolsCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        TXGeneralModel *model = self.toolsArray[indexPath.row];
        tools.imagesView.image = kGetImage(model.imageText);
        return tools;

    }else{
        //获取cell视图，内部通过去缓存池中取，如果缓存池中没有，就自动创建一个新的cell
        TXMainCollectionViewCell *tools=[TXMainCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
        MainListModel *model = self.dataArray[indexPath.row];
        [tools.imagesView sd_setImageWithURL:kGetImageURL(model.aircraftImg) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
        tools.depCityLabel.text = model.origin;
        tools.arvCityLabel.text = model.destination;
        tools.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
        
        /// 月日 时分
        NSString *formatTime = @"MM-dd HH:mm";
        /// 得到时间
        NSString *datetime= [Utils lz_timeWithTimeIntervalString:model.depTime formatter:formatTime];
        NSString *subString = [datetime stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
        subString = [subString stringByReplacingOccurrencesOfString:@" " withString:@"日"];
        tools.datetimeLabel.text = [NSString stringWithFormat:@"%@ 起飞",subString];
        tools.discountLabel.text = [NSString stringWithFormat:@"%@折",model.referenceprice];
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
            titleText = @"超值特惠";
            imageName = @"首页_商务_打折_劵";
            has_hidden = YES;
            colorText = kColorWithRGB(176, 23, 23);
        }
        headerView.moreButton.tag = indexPath.section;
//        MV(weakSelf)
        [headerView.moreButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//            [weakSelf jumpMallChildsViewController_did:indexPath];
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
        width = (kScreenWidth-margin)/3;
        height = IPHONE6_W(60);
    }else if(indexPath.section==2){
        height = IPHONE6_W(150);
    }
    return CGSizeMake(width, height);
}

/// Cell之间的列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section==0||section==1) return 0;
    return 10;
}

/// Cell之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section==0||section==1) return 0;
    return 10;
}

// 设置每一组的上下左右间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section==0) return UIEdgeInsetsMake(0, 0, 10, 0);
    if (section==1) return UIEdgeInsetsMake(0, 15, 0, 15);
    return UIEdgeInsetsMake(0, 15, 10, 15);
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
//    [self jumpProductDetails:indexPath];
    if (indexPath.section==1&&indexPath.row==0) {
        TXCharterSpellMachineViewController *vc = [[TXCharterSpellMachineViewController alloc] init];
        TTPushVC(vc);
    }else if (indexPath.section==2){
        CharterMachineModel *model = self.dataArray[indexPath.row];
        TXCharterMachineChildViewController *vc = [[TXCharterMachineChildViewController alloc] initTicketModel:model];
        vc.webUrl = kAppendH5URL(DomainName, CharterDetailsH5,model.kid);
        TTPushVC(vc);
    }
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
        flowLayout.minimumLineSpacing = 10;
        // 确定纵向间距(设置列间距)
        flowLayout.minimumInteritemSpacing = 10;
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
        [_collectionView registerClass:[TXMainToolsCollectionViewCell class] forCellWithReuseIdentifier:[TXMainToolsCollectionViewCell reuseIdentifier]];
        /// 注册超值特惠视图中显示的视图
        [_collectionView registerClass:[TXMainCollectionViewCell class] forCellWithReuseIdentifier:[TXMainCollectionViewCell reuseIdentifier]];

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
        NSArray* titleArr = @[@"主页_包机",@"主页_拼机",@"主页_空中巴士"];
        NSArray* classArr = @[@"",@"",@""];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel* templateModel = [[TXGeneralModel alloc] init];
            templateModel.imageText = [titleArr lz_safeObjectAtIndex:j];
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
//        NSArray* imagesArr = @[@"c31_club_banner",@"c31_club_banner1",@"c31_club_banner2"];
//        for (int j = 0; j < imagesArr.count; j ++) {
//            NewsBannerModel *model = [[NewsBannerModel alloc] init];
//            model.imageText = [imagesArr objectAtIndex:j];
//            [_bannerArray addObject:model];
//        }
    }
    return _bannerArray;
}
@end
