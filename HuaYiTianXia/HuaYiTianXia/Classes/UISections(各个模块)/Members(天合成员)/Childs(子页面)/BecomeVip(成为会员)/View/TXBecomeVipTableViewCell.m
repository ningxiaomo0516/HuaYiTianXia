//
//  TXBecomeVipTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXBecomeVipTableViewCell.h"
#import "TXBecomeVipCollectionViewCell.h"

static NSString* reuseIdentifier = @"TXBecomeVipCollectionViewCell";

@interface TXBecomeVipTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
{
@private
    UICollectionView * _collectionView;
    UIImageView * _iconImageView;
    UILabel * _titleLabel;
}
@property(nonatomic,strong,readonly)UICollectionView *collectionView;
/// 记录最后的height
@property (nonatomic, assign) CGFloat endHeight;
/// headerView的高度
@property (nonatomic, assign) CGFloat headerHeight;
///
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, assign) NSInteger selectedRow;
//// 是否可以选择
@property (nonatomic, assign) NSInteger isClick;

@end
@implementation TXBecomeVipTableViewCell

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
        self.headerHeight = IPHONE6_W(90);
        self.selectedRow = -1;
        [self initView];
    }
    return self;
}

- (void) initView{
    [self.contentView addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, self.height+self.headerHeight);
}

- (void)setDataCell:(NSString *)amountText amountText1:(NSString *)amountText1{

    TTLog(@"amountText -- %@ amountText1:%@ ",amountText,amountText1);
//    NSInteger text = [amountText integerValue];
//    if (text==0) {
//        self.selectedRow = 0;
//        self.isClick = 1;
//    } 
//    if (text==100000) {
//        self.selectedRow = 1;
//        self.isClick = 3;
//    }
//    if (text==100000) {
//        self.selectedRow = 2;
//        self.isClick = 1;
//    }
    self.textField.text = amountText;
    NSString *amountText11 = [NSString stringWithFormat:@"%@元",amountText1];
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:amountText11];
    /// 前面文字颜色
    [mutableAttr addAttribute:NSForegroundColorAttributeName
                        value:kTextColor102
                        range:NSMakeRange(amountText1.length, 1)];
    self.subtitlelabel1.attributedText = mutableAttr;
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==0) {
        return self.dataArray.count;
    }
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXBecomeVipCollectionViewCell *tools = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.imagesView.hidden = indexPath.row==0?NO:YES;
    TXGeneralModel* templateModel = self.dataArray[indexPath.row];
    tools.titleLabel.text = templateModel.title;
    tools.priceLabel.text = templateModel.imageText;
    tools.identityLabel.text = templateModel.showClass;
    self.indexPath = indexPath;
    CGFloat collectionViewHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    [self updateCollectionViewHeight:collectionViewHeight+self.headerHeight];
    [self createBottomView:collectionViewHeight];
    
    if (self.selectedRow == indexPath.row) {
        [tools setChecked:YES isClick:indexPath.row<self.isClick?NO:YES];
    } else {
        [tools setChecked:NO isClick:indexPath.row<self.isClick?YES:NO];
    }
    
//    if (self.isClick==1&&indexPath.row==0) {
//        tools.titleLabel.textColor = kColorWithRGB(180, 180, 180);
//    }
    return tools;
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedRow == indexPath.row ) {
//        self.selectedRow = -1;
        TTLog(@"暂停 == 暂停");
    } else {
        self.selectedRow = indexPath.row;
        TTLog(@"开始 == 开始");
    }
    [self.collectionView reloadData];
    if (indexPath.row>=self.isClick) {
        TXGeneralModel* templateModel = self.dataArray[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didToolsSelectItemAtIndexPath:withContent:)]) {
            [self.delegate didToolsSelectItemAtIndexPath:indexPath withContent:templateModel.message];
        }
    }else{
        Toast(@"当前已是该会员");
    }
}

/// 更新CollectionViewHeight
- (void)updateCollectionViewHeight:(CGFloat)height {
    if (self.endHeight != height) {
        self.endHeight = height;
        self.collectionView.frame = CGRectMake(0, 0, self.collectionView.width, height);
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
    CGFloat width = (kScreenWidth-IPHONE6_W(60))/3;
    return CGSizeMake(width, IPHONE6_W(95));
}

//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15,15,15,15);
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
        flowLayout.minimumLineSpacing = 15;
        //确定纵向间距(设置列间距)
        flowLayout.minimumInteritemSpacing = 0;
        //确定距离上左下右的距离
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //头尾部高度
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        flowLayout.footerReferenceSize = CGSizeMake(0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[TXBecomeVipCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = YES;
    }
    return _collectionView;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _boxView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@"黄金会员",@"白钻会员",@"黑砖会员"];
        NSArray* imagesArr = @[@"￥10,000",@"￥100,000",@"￥300,000"];
        NSArray* classArr = @[@"个人版",@"终身版",@"企业版"];
        NSArray* priceArr = @[@"1000",@"100000",@"300000"];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel* templateModel = [[TXGeneralModel alloc] init];
            templateModel.title = [titleArr lz_safeObjectAtIndex:j];
            templateModel.imageText = [imagesArr lz_safeObjectAtIndex:j];
            templateModel.showClass = [classArr lz_safeObjectAtIndex:j];
            templateModel.message = [priceArr lz_safeObjectAtIndex:j];
            [_dataArray addObject:templateModel];
        }
    }
    return _dataArray;
}

- (void) createBottomView:(CGFloat)collectionViewHeight{
    [self.contentView addSubview:self.boxView];
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.collectionView);
        make.top.equalTo(@(collectionViewHeight));
        make.height.equalTo(@(self.headerHeight));
    }];
    

    UIView *v1 = [UIView lz_viewWithColor:kWhiteColor];
    UIView *v3 = [UIView lz_viewWithColor:kWhiteColor];
    [self.boxView addSubview:v1];
    [self.boxView addSubview:v3];

    v1.frame = CGRectMake(0, 0, kScreenWidth, 25);
    v3.frame = CGRectMake(0, CGRectGetMaxY(v1.frame), kScreenWidth, 65);

    UILabel *titlelabel1 = [UILabel lz_labelWithTitle:@"已充值:" color:kTextColor51 font:kFontSizeMedium15];
    UILabel *titlelabel3 = [UILabel lz_labelWithTitle:@"充值金额:" color:kTextColor51 font:kFontSizeMedium15];
    [v1 addSubview:titlelabel1];
    [v3 addSubview:titlelabel3];

    [v1 addSubview:self.subtitlelabel1];
    [v3 addSubview:self.textField];

    [titlelabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(v1);
    }];
    [titlelabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titlelabel1);
        make.centerY.equalTo(v3);
    }];

    [_subtitlelabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(90)));
        make.centerY.equalTo(v1);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_subtitlelabel1);
        make.centerY.equalTo(v3);
        make.height.equalTo(@(IPHONE6_W(35)));
        make.right.equalTo(self.mas_right).offset(-IPHONE6_W(15));
    }];
}

- (UILabel *)subtitlelabel1{
    if (!_subtitlelabel1) {
        _subtitlelabel1 = [UILabel lz_labelWithTitle:@"" color:HexString(@"#F7D073") font:kFontSizeMedium15];
    }
    return _subtitlelabel1;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [UITextField lz_textFieldWithPlaceHolder:@"请输入充值金额"];
        _textField.layer.cornerRadius = 5.0;
        _textField.layer.borderColor = HexString(@"#78C1EA").CGColor;
        _textField.layer.borderWidth = 1.0;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
//        _textField.ry_inputType = RYIntInputType;
    }
    return _textField;
}
@end
