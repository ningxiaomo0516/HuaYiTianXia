//
//  TXUAvCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/12.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXUAvCollectionViewCell.h"
#import "TTMallTemplateHotCollectionViewCell.h"
#import "TTMallTemplateAdCollectionViewCell.h"
#import "TTTemplateThreeTableViewCell.h"

static NSString* reuseIdentifierHot     = @"TTMallTemplateHotCollectionViewCell";
static NSString* reuseIdentifierAd      = @"TTMallTemplateAdCollectionViewCell";
static NSString* reuseIdentifierTh      = @"TTTemplateThreeTableViewCell";

@interface TXUAvCollectionViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, assign)CGFloat headerTitleHeight;
@end
@implementation TXUAvCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kWhiteColor;
        self.headerTitleHeight = 40;
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    [self.contentView addSubview:self.titleView];
    [self.titleView addSubview:self.titleLabel];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(self.headerTitleHeight));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self.titleView);
    }];
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
    self.collectionView.backgroundColor = kRedColor;
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _titleView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    TTMallTemplateHotCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierHot forIndexPath:indexPath];
//    TTMallTemplateAdCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierAd forIndexPath:indexPath];
    TTTemplateThreeTableViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierTh forIndexPath:indexPath];
//    UILabel *title = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium15];
//    title.text = [NSString stringWithFormat:@"当前组 ---- %ld \n当前行 ---- %ld",indexPath.section,indexPath.row];
//    [tools.contentView addSubview:title];
//    [title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.centerX.equalTo(tools.contentView);
//    }];
    return tools;
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        Toast(@"系统持续开放中");
    }else if(indexPath.section==5){
        
    }
}

/// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

/// 设置minimumInteritemSpacing：cell左右之间最小的距离(同一行的cell的间距)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat margin = 10*3;
//    CGFloat width = [self gainStringWidthWithString:@"" font:15.0f height:50];
//    return CGSizeMake((kScreenWidth-margin)/2, IPHONE6_W(150));
    return CGSizeMake(306, self.height-self.headerTitleHeight);
}

// 设置UIcollectionView整体的内边距 section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,15,15,15);
}

//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(10,10);
}

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
        [_collectionView registerClass:[TTMallTemplateHotCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierHot];
        [_collectionView registerClass:[TTMallTemplateAdCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierAd];
        [_collectionView registerClass:[TTTemplateThreeTableViewCell class] forCellWithReuseIdentifier:reuseIdentifierTh];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        /// 设置此属性为YES 不满一屏幕 也能滚动
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.bounces = YES;
    }
    return _collectionView;
}

@end
