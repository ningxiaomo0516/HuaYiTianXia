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

static NSString* reuseIdentifierHot         = @"TXMallUAVHotCollectionViewCell";
static NSString* reuseIdentifierAd          = @"TXMallUAVAdCollectionViewCell";
static NSString* reuseIdentifierRecommend   = @"TXMallUAVRecommendCollectionViewCell";

@interface TXMallUAVHotTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
/// headerView的高度
@property (nonatomic, strong) UIView *headerView;
/// headerView的高度
@property (nonatomic, strong) UILabel *headerTitle;
/// headerView的高度
@property (nonatomic, strong) UILabel *headerSubtitle;
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
    self.headerTitle.text = @"当下热门";
    self.height = 110;
    self.collectionView.frame = CGRectMake(0, 40, kScreenWidth, self.height);
    [self.collectionView reloadData];
}

- (void) initView{
    [self addSubview:self.collectionView];
    
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.headerTitle];
    [self.headerView addSubview:self.headerSubtitle];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(40));
    }];
    
    [self.headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerY.equalTo(self.headerView);
    }];
    
    [self.headerSubtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerTitle.mas_right).offset(7);
        make.centerY.equalTo(self.headerView);
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRecommendVideoSelectItemAtIndexPath:)]) {
        [self.delegate didRecommendVideoSelectItemAtIndexPath:indexPath];
    }
    
    self.selectBlock(self.listModel.hot[indexPath.row]);
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (kScreenWidth-15*2-10)/2;
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

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _headerView;
}

- (UILabel *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = [UILabel lz_labelWithTitle:@"" color:kTextColor12 font:kFontSizeScBold17];
    }
    return _headerTitle;
}

- (UILabel *)headerSubtitle {
    if (!_headerSubtitle) {
        _headerSubtitle = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium12];
    }
    return _headerSubtitle;
}
@end
