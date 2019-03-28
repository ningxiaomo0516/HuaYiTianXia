//
//  TXMallCollectionViewController.m
//  HuaYiTianXia
//
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

static NSString* reuseIdentifier = @"TXMallToolsCollectionViewCell";
static NSString* reuseIdentifierBanner = @"TXMallBannerCollectionViewCell";
static NSString* reuseIdentifierMall = @"TXMallCollectionViewCell";


@interface TXMallCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
@private
    UICollectionView * _collectionView;
    UIImageView * _iconImageView;
    UILabel * _titleLabel;
}
@property(nonatomic,strong,readonly)UICollectionView * collectionView;
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
    [self loadMallData];
}

- (void) loadMallData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@([self.title integerValue]) forKey:@"status"];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数
    
    TTLog(@"parameter -- %@",parameter);
    [SCHttpTools postWithURLString:@"shopproduct/GetShopPro" parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTLog(@"result -- %@",result);
            TXNewsArrayModel *model = [TXNewsArrayModel mj_objectWithKeyValues:result];
            [self.dataArray addObjectsFromArray:model.data.records];
            [self.bannerArray addObjectsFromArray:model.banners];
            [self.collectionView reloadData];
        }else{
            Toast(@"获取城市数据失败");
        }
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
    }];
}

- (void) initView{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count+2;
}

// 每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==0) return 1;
    else if (section==2) return self.dataArray.count;
    else{
        NSArray *subArray = [self.toolsArray lz_safeObjectAtIndex:section-1];
        return subArray.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        TXMallBannerCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        tools.bannerArray = self.bannerArray;
        return tools;
    }else if (indexPath.section==2) {
        TXMallCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMall forIndexPath:indexPath];
        tools.recordsModel = self.dataArray[indexPath.row];
        return tools;
    }else{
        TXMallToolsCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        TXGeneralModel* templateModel = self.toolsArray[indexPath.section-1][indexPath.row];
        tools.titleLabel.text = templateModel.title;
        tools.imagesView.image = kGetImage(templateModel.imageText);
        return tools;
    }
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NewsRecordsModel *productModel = self.dataArray[indexPath.row];
    TXMallGoodsDetailsViewController *vc = [[TXMallGoodsDetailsViewController alloc] initMallProductModel:productModel];
    TTPushVC(vc);
}

/// 同一行的cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = kScreenWidth/4;
    if (indexPath.section==0) return CGSizeMake(kScreenWidth, IPHONE6_W(180));
    else if (indexPath.section==1)return CGSizeMake(width, IPHONE6_W(95));
    CGFloat margin = 10*3;
    return CGSizeMake((kScreenWidth-margin)/2, IPHONE6_W(230));
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
        [_collectionView registerClass:[TXMallCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierMall];
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
        NSArray* titleArr;
        NSArray* imagesArr;
//        NSArray* imagesArr = @[@[@"home_tools_sheying",@"home_tools_cehua",@"home_tools_lifu",@"home_tools_hotel"]];

        if ([self.title isEqualToString:@"1"]) {
            titleArr = @[@[@"飞行",@"培训",@"服装",@"零件"]];
            imagesArr = @[@[@"mall_tools_fx_nor",@"mall_tools_px_nor",@"mall_tools_fz_nor",@"mall_tools_lj_nor"]];
        }else{
            titleArr = @[@[@"农业",@"蔬菜",@"水果",@"其他"]];
            imagesArr = @[@[@"mall_tools_nb_nor",@"mall_tools_sc_nor",@"mall_tools_sg_nor",@"mall_tools_qt_nor"]];
        }
        
        NSArray* classArr = @[@[@"",@"",@"",@""]];
        for (int i=0; i<titleArr.count; i++) {
            NSArray *subTitlesArray = [titleArr lz_safeObjectAtIndex:i];
            NSArray *subImagesArray = [imagesArr lz_safeObjectAtIndex:i];
            NSArray *classArray = [classArr lz_safeObjectAtIndex:i];
            NSMutableArray *subArray = [NSMutableArray array];
            for (int j = 0; j < subTitlesArray.count; j ++) {
                TXGeneralModel* templateModel = [[TXGeneralModel alloc] init];
                templateModel.title = [subTitlesArray lz_safeObjectAtIndex:j];
                templateModel.imageText = [subImagesArray lz_safeObjectAtIndex:j];
                templateModel.showClass = [classArray lz_safeObjectAtIndex:j];
                [subArray addObject:templateModel];
            }
            [_toolsArray addObject:subArray];
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
