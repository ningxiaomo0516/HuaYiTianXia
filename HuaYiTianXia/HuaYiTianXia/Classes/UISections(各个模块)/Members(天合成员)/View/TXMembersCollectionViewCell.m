//
//  TXMembersCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMembersCollectionViewCell.h"

static NSString* reuseIdentifier = @"MembersCollectionViewCell";

@interface TXMembersCollectionViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation TXMembersCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kWhiteColor;
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.right.equalTo(self);
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
    MembersCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    TXGeneralModel* model = self.dataArray[indexPath.row];
    tools.imagesView.image = kGetImage(model.imageText);
    return tools;
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TXGeneralModel* model = self.dataArray[indexPath.row];
    if (self.typeBlock) {
        self.typeBlock(model);
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //确定滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //确定item的大小
        flowLayout.itemSize = CGSizeMake(IPHONE6_W(107), IPHONE6_W(107));
        //确定横向间距(设置行间距)
        flowLayout.minimumLineSpacing = 10;
        //确定纵向间距(设置列间距)
        flowLayout.minimumInteritemSpacing = 10;
        //确定距离上左下右的距离
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        //头尾部高度
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        flowLayout.footerReferenceSize = CGSizeMake(0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[MembersCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
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
        NSArray* imagesArr = @[@"机票预订",@"热门景点",@"超值酒店",@"网红美食",@"包机服务",@"拼机服务"];
        NSArray* classArr = @[@"TXTicketQueryViewController",@"",@"",@"",@"TXCharterSpellMachineViewController",@""];
        for (int i=0; i<imagesArr.count; i++) {
            TXGeneralModel* templateModel = [[TXGeneralModel alloc] init];
            templateModel.imageText = [imagesArr lz_safeObjectAtIndex:i];
            templateModel.showClass = [classArr lz_safeObjectAtIndex:i];
            [_dataArray addObject:templateModel];
        }
    }
    return _dataArray;
}
@end

@implementation MembersCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kWhiteColor;
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    [self.contentView addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.right.equalTo(self);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

@end
