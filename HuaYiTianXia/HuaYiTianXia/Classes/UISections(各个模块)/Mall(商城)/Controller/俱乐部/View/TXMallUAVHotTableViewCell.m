//
//  TXMallUAVHotTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMallUAVHotTableViewCell.h"
#import "TXMallUAVHotCollectionViewCell.h"
#import "TXMallUAVAdCollectionViewCell.h"
#import "TXMallUAVRecommendCollectionViewCell.h"
#import "TXMallClubSectionView.h"

static NSString* reuseIdentifierHot         = @"TXMallUAVHotCollectionViewCell";
static NSString* reuseIdentifierAd          = @"TXMallUAVAdCollectionViewCell";
static NSString* reuseIdentifierRecommend   = @"TXMallUAVRecommendCollectionViewCell";

@interface TXMallUAVHotTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
/// headerView的高度
@property (nonatomic, strong) TXMallClubSectionView *headerView;
@property (nonatomic, assign) CGFloat height;
@end

@implementation TXMallUAVHotTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)setListModel:(MallUAVModel *)listModel{
    _listModel = listModel;
    [self initView];
    self.headerView.headerTitle.text = @"热门";
    self.headerView.headerTitle.textColor = HexString(@"#FF6C00");
    self.headerView.headerIcon.image = kGetImage(@"c21_icon_热门");
    self.height = 192;
    self.collectionView.frame = CGRectMake(0, 40, kScreenWidth, self.height);
    [self.collectionView reloadData];
}

- (void) initView{
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(@(40));
    }];
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listModel.hot.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXMallUAVHotCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierHot forIndexPath:indexPath];
    tools.model = self.listModel.hot[indexPath.row];
    return tools;
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MallUAVListModel *listModel = self.listModel.hot[indexPath.row];
    self.selectBlock(listModel);
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (kScreenWidth-15*2)/2;
    return CGSizeMake(width, self.height);
}

//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,15,0,15);
}

//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(0,0);
}

//设置header呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(0,0);
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //确定滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //确定item的大小
        //        flowLayout.itemSize = CGSizeMake(100, 120);
        //确定横向间距(设置行间距)
        flowLayout.minimumLineSpacing = 5;
        //确定纵向间距(设置列间距)
        flowLayout.minimumInteritemSpacing = 0;
        //确定距离上左下右的距离
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //头尾部高度
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        flowLayout.footerReferenceSize = CGSizeMake(0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[TXMallUAVHotCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierHot];
        [_collectionView registerClass:[TXMallUAVAdCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierAd];
        [_collectionView registerClass:[TXMallUAVRecommendCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierRecommend];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = YES;
    }
    return _collectionView;
}

- (TXMallClubSectionView *)headerView{
    if (!_headerView) {
        _headerView = [[TXMallClubSectionView alloc] init];
        _headerView.backgroundColor = kClearColor;
    }
    return _headerView;
}

@end
