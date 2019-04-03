//
//  TXWalletTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXWalletTableViewCell.h"
#import "TXWalletCollectionViewCell.h"
#import "TXGeneralModel.h"

static NSString* reuseIdentifier = @"TXWalletCollectionViewCell";

@interface TXWalletTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
{
@private
    UICollectionView * _collectionView;
}
@property (nonatomic,strong,readonly)UICollectionView * collectionView;

/// 记录最后的height
@property (nonatomic, assign) CGFloat endHeight;
/// headerView的高度
@property (nonatomic, assign) CGFloat headerHeight;

@end
@implementation TXWalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        self.headerHeight = 0;
    }
    return self;
}

- (void) initView{
    [self addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(0, self.headerHeight, kScreenWidth, self.height+self.headerHeight);
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXWalletCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    TXGeneralModel* templateModel = self.dataArray[indexPath.row];
    
    tools.titleLabel.text = templateModel.title;
    tools.imagesView.image = kGetImage(templateModel.imageText);
//    self.indexPath = indexPath;
    [self updateCollectionViewHeight:self.collectionView.collectionViewLayout.collectionViewContentSize.height+self.headerHeight];

    return tools;
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:withTitle:withShowClass:)]) {
        TXGeneralModel* templateModel = self.dataArray[indexPath.row];
        [self.delegate didSelectItemAtIndexPath:indexPath withTitle:templateModel.title withShowClass:templateModel.showClass];
    }
}

/// 更新CollectionViewHeight
- (void)updateCollectionViewHeight:(CGFloat)height {
    if (self.endHeight != height) {
        self.endHeight = height;
        self.collectionView.frame = CGRectMake(0, self.headerHeight, self.collectionView.width, height);
        if (_delegate && [_delegate respondsToSelector:@selector(updateTableViewCellHeight:andheight:andIndexPath:)]) {
            [self.delegate updateTableViewCellHeight:self andheight:height andIndexPath:self.indexPath];
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
    return CGSizeMake(kScreenWidth/3, 100);
}

//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0,0,0);
}

//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
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
        [_collectionView registerClass:[TXWalletCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
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
        NSArray* titleArr = @[@"交易记录",@"充值",@"转出转入",@"股权",@"分红",@"转出",@"交易",@"转换",@"复投"];
        
        NSArray* imagesArr = @[@"wallet_btn_jiaoyijilu",@"wallet_btn_chongzhi",@"wallet_btn_zhuanchuzhuanru",
                               @"wallet_btn_guquan",@"wallet_btn_tixian",@"wallet_btn_zhuanchu",
                               @"wallet_btn_jiaoyi",@"wallet_btn_zhuanhuan",@"wallet_btn_futou"];
        
        NSArray* classArr = @[@"TXTransactionRecordsViewController",@"TXTopupViewController",
                              @"TXZhuanchuZhuanruViewController",@"TXEquityViewController",
                              @"",@"TXRolloutViewController",@"",
                              @"TXConversionViewController",@"TXRepeatCastViewController"];
        
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel* templateModel = [[TXGeneralModel alloc] init];
            templateModel.title = [titleArr lz_safeObjectAtIndex:j];
            templateModel.imageText = [imagesArr lz_safeObjectAtIndex:j];
            templateModel.showClass = [classArr lz_safeObjectAtIndex:j];
            [_dataArray addObject:templateModel];
        }
    }
    return _dataArray;
}

@end
