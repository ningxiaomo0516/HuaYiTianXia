//
//  TXMembersViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMembersViewController.h"
#import "TXMembersbleCollectionViewCell.h"
#import "TXMallBannerCollectionViewCell.h"
#import "TXMallToolsCollectionViewCell.h"
#import "TXGeneralModel.h"
#import "TTBannerModel.h"
#import "TXTicketQueryViewController.h"
#import "TXTicketOrderViewController.h"
#import "TXAdsModel.h"
#import "TXAdsGiftViewController.h"

static NSString* reuseIdentifier = @"TXMallToolsCollectionViewCell";
static NSString* reuseIdentifierBanner = @"TXMallBannerCollectionViewCell";
static NSString* reuseIdentifierMall = @"TXMembersbleCollectionViewCell";


@interface TXMembersViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
@private
    UICollectionView * _collectionView;
    UIImageView * _iconImageView;
    UILabel * _titleLabel;
}
@property(nonatomic,strong,readonly)UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@end

@implementation TXMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self loadMallData];
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将页码重新置为1
        [self.bannerArray removeAllObjects];
        [self loadMallData];
    }];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) loadMallData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(16) forKey:@"status"];
    [SCHttpTools postWithURLString:@"banner/GetBanners" parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTBannerModel *model = [TTBannerModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                [self.bannerArray addObjectsFromArray:model.banners];
                [self.collectionView reloadData];
            }
        }else{
            Toast(@"获取数据失败");
        }
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

/// 获取礼包活动数据
- (void) getGiftData{
    kShowMBProgressHUD(self.view);
    //    礼包类型 1:农保礼包 2:天合成员礼包
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(1) forKey:@"type"];
    [SCHttpTools postWithURLString:kHttpURL(@"parcel/ControlParcel") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTAdsData *model = [TTAdsData mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                /// 礼包活动是否结束1:活动继续，进入礼包界面，2:活动终止,无法进入礼包界面
                if (model.data.status==1) {
                    TXAdsGiftViewController *vc = [[TXAdsGiftViewController alloc] init];
                    vc.webURL = [NSString stringWithFormat:@"%@libao/index.html?type=2&userID=%@", DomainName,kUserInfo.userid];
                    TTPushVC(vc);
                }else{
                    Toast(@"礼包活动已结束");
                }
            }
        }else{
            Toast(@"获取礼包数据失败");
        }
        kHideMBProgressHUD(self.view);
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        kHideMBProgressHUD(self.view);
    }];
}


- (void) initView{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
    }];
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

// 每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *subArray = [self.dataArray lz_safeObjectAtIndex:section];
    return subArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXGeneralModel* templateModel = self.dataArray[indexPath.section][indexPath.row];
    if (indexPath.section==0) {
        TXMallBannerCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        tools.bannerArray = self.bannerArray;
        return tools;
    }else if (indexPath.section==2) {
        TXMembersbleCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMall forIndexPath:indexPath];
        tools.imagesView.image = kGetImage(templateModel.imageText);
        return tools;
    }else{
        TXMallToolsCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.titleLabel.text = templateModel.title;
        tools.imagesView.image = kGetImage(templateModel.imageText);
        return tools;
    }
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TXGeneralModel* model = self.dataArray[indexPath.section][indexPath.row];
    NSString *className = model.showClass;
    if ([model.showClass isEqualToString:@"礼包"]) {
        [self getGiftData];
    }else{
        Class controller = NSClassFromString(className);
        //    id controller = [[NSClassFromString(className) alloc] init];
        if (controller &&  [controller isSubclassOfClass:[UIViewController class]]){
            UIViewController *vc = [[controller alloc] init];
            vc.title = model.title;
            TTPushVC(vc);
        }
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
    CGFloat width = kScreenWidth/3;
    if (indexPath.section==0) return CGSizeMake(kScreenWidth, IPHONE6_W(180));
    else if (indexPath.section==1)return CGSizeMake(width, IPHONE6_W(95));
    CGFloat margin = 10*3;
    return CGSizeMake((kScreenWidth-margin)/2, IPHONE6_W(74));
}

//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section==2) return UIEdgeInsetsMake(10,10,0,10);
    return UIEdgeInsetsMake(0,0,0,0);
}

//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section==2) return CGSizeMake(0,10);
    return CGSizeMake(0,0);
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
        flowLayout.minimumInteritemSpacing = 10;
        //确定距离上左下右的距离
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //头尾部高度
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        flowLayout.footerReferenceSize = CGSizeMake(0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[TXMallToolsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerClass:[TXMallBannerCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierBanner];
        [_collectionView registerClass:[TXMembersbleCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierMall];
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
        NSArray* titleArr;
        NSArray* imagesArr;
//        titleArr = @[@[],@[@"会员",@"订单",@"礼包",@"其他"],@[]];
        titleArr = @[@[],@[@"会员",@"订单",@"礼包"],@[]];
        imagesArr = @[@[@"banner"],@[@"c41_btn_members",@"c41_btn_order",@"c41_btn_gift"],//,@"c41_btn_other"
                    @[@"机票预订",@"热门景区",@"超值酒店",@"网红美食"]];
        NSArray* classArr = @[@[],
                              @[@"TXBecomeVipViewController",@"TXTicketOrderViewController",@"礼包",@""],
                              @[@"TXTicketQueryViewController",@"TXCharterSpellMachineViewController",@"",@""]];
        for (int i=0; i<imagesArr.count; i++) {
            NSArray *subTitlesArray = [titleArr lz_safeObjectAtIndex:i];
            NSArray *subImagesArray = [imagesArr lz_safeObjectAtIndex:i];
            NSArray *classArray = [classArr lz_safeObjectAtIndex:i];
            NSMutableArray *subArray = [NSMutableArray array];
            for (int j = 0; j < subImagesArray.count; j ++) {
                TXGeneralModel* templateModel = [[TXGeneralModel alloc] init];
                templateModel.title = [subTitlesArray lz_safeObjectAtIndex:j];
                templateModel.imageText = [subImagesArray lz_safeObjectAtIndex:j];
                templateModel.showClass = [classArray lz_safeObjectAtIndex:j];
                [subArray addObject:templateModel];
            }
            [_dataArray addObject:subArray];
        }
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
