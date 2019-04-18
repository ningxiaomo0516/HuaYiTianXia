//
//  TXShareViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXShareViewController.h"
#import "TXShareToolsCollectionViewCell.h"
#import "TXGeneralModel.h"

static NSString* reuseIdentifierShareTools = @"TXShareToolsCollectionViewCell";

@interface TXShareViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
@private
    UICollectionView * _collectionView;
    UIImageView * _iconImageView;
    UILabel * _titleLabel;
}
@property (nonatomic, strong,readonly)UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 标题
@property (nonatomic, strong) UILabel       *titleLabel;
/// 底部视图
@property (nonatomic, strong) UIView        *footerView;
/// 取消按钮
@property (nonatomic, strong) UIButton      *cancelButton;
/// 取消按钮
@property (nonatomic, strong) UIView        *linerView;
@end

@implementation TXShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void) initView{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.footerView];
    [self.footerView addSubview:self.cancelButton];
    [self.view addSubview:self.linerView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.top.right.equalTo(self.view);
        make.height.equalTo(@(IPHONE6_W(42)));
    }];
    
    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.equalTo(@(0.7));
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(kTabBarHeight));
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.footerView);
        make.height.equalTo(@(49));
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.footerView.mas_top);
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
    TXShareToolsCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierShareTools forIndexPath:indexPath];
    TXGeneralModel* templateModel = self.dataArray[indexPath.row];
    tools.backgroundColor = kClearColor;
    tools.titleLabel.text = templateModel.title;
    tools.imagesView.image = kGetImage(templateModel.imageText);
    return tools;
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TXGeneralModel* templateModel = self.dataArray[indexPath.row];
    if (self.selectItemBlock) {
        self.selectItemBlock(indexPath.row,templateModel.title);
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
    CGFloat width = kScreenWidth/5;
    return CGSizeMake(width, self.collectionView.height);
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
        [_collectionView registerClass:[TXShareToolsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierShareTools];
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
        NSArray* titleArr = @[@"微信",@"微博",@"QQ"];
        NSArray* imagesArr = @[@"live_btn_wechat",@"live_btn_weibo",@"live_btn_qq"];
        for (int i=0; i<titleArr.count; i++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:i];
            generalModel.imageText = [imagesArr lz_safeObjectAtIndex:i];
            [_dataArray addObject:generalModel];
        }
    }
    return _dataArray;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"分享至" color:kTextColor102 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _footerView;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitleColor:kTextColor51 forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = kFontSizeMedium15;
        _cancelButton.backgroundColor = kWhiteColor;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:@"LZActionSheet.bundle/actionSheetHighLighted.png"];
        [_cancelButton setBackgroundImage:image forState:UIControlStateHighlighted];
        MV(weakSelf);
        [_cancelButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//            [weakSelf saveBtnClick:self._cancelButton];
        }];
    }
    return _cancelButton;
}

- (UIView *)linerView{
    if (!_linerView) {
        _linerView = [UIView lz_viewWithColor:kTextColor238];
    }
    return _linerView;
}
@end
