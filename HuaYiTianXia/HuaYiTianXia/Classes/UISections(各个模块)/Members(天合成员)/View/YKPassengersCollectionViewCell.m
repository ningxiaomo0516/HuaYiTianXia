//
//  YKPassengersCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/13.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKPassengersCollectionViewCell.h"
@interface YKPassengersCollectionViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
{
@private
    UICollectionView * _collectionView;
}
@property(nonatomic,strong,readonly)UICollectionView * collectionView;
/// 记录最后的height
@property (nonatomic, assign) CGFloat endHeight;
@end
@implementation YKPassengersCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier{
    static NSString *footerIdentifier = @"YKPassengersCollectionViewCell";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [YKPassengersCollectionViewCell reuseIdentifier];
    YKPassengersCollectionViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
    return tools;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    for (int i=0; i<dataArray.count; i++) {
        PassengerModel *model = dataArray[i];
        if (model.isAdd) {
            [dataArray removeObject:model];
        }
    }
    PassengerModel *model = [[PassengerModel alloc] init];
    model.isAdd = YES;
    [self.dataArray addObject:model];
    [self.collectionView reloadData];
}

- (void) initView{
    [self addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(10, 0, kScreenWidth-20, self.height);
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
    YKTemplateSecondCollectionViewCell *tools=[YKTemplateSecondCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    PassengerModel *model = self.dataArray[indexPath.row];
    if (model.isAdd) {
        tools.addButton.hidden = NO;
        tools.selectedButton.hidden = YES;
    }else{
        if (model.isSelected) {
            tools.selectedButton.selected = YES;
        }else{
            tools.selectedButton.selected = NO;
            tools.layer.borderColor = kColorWithRGB(204, 204, 204).CGColor;
        }
        tools.addButton.hidden = YES;
        tools.selectedButton.hidden = NO;
//        tools.selectedButton.selected = tools.selectedButton.selected;
        model.isSelected = tools.selectedButton.selected;
        [tools.selectedButton setTitle:model.name forState:UIControlStateNormal];
    }
    tools.selectedButton.tag = indexPath.row;
    MV(weakSelf)
    [tools.addButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf didPassengersBtnClick:indexPath];
    }];
    [tools.selectedButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf didPassengersBtnClick:indexPath];
    }];
    [self updateSecondCollectionViewHeight:self.collectionView.collectionViewLayout.collectionViewContentSize.height];
    return tools;
}

- (void) didPassengersBtnClick:(NSIndexPath *)indexPath {
    PassengerModel *model = self.dataArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPassengerSelectItemAtIndexPath:withModel:)]) {
        [self.delegate didPassengerSelectItemAtIndexPath:indexPath withModel:model];
    }
}

/// 点击collectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    PassengerModel *model = self.dataArray[indexPath.row];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didPassengerSelectItemAtIndexPath:withModel:)]) {
//        [self.delegate didPassengerSelectItemAtIndexPath:indexPath withModel:model];
//    }
    [self didPassengersBtnClick:indexPath];
}

/// 更新CollectionViewHeight
- (void)updateSecondCollectionViewHeight:(CGFloat)height{
    if (self.endHeight != height) {
        self.endHeight = height;
        self.collectionView.frame = CGRectMake(10, 0, self.collectionView.width, height);
        if (_delegate && [_delegate respondsToSelector:@selector(updateSecondTableViewCellHeight:andheight:andIndexPath:)]) {
            [self.delegate updateSecondTableViewCellHeight:self andheight:height andIndexPath:self.indexPath];
        }
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //确定滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //确定item的大小
        CGFloat margin = 15*2+20;
        CGFloat spacing = 10*2;
        flowLayout.itemSize = CGSizeMake((kScreenWidth-margin-spacing)/3, 30);
        //确定横向间距(设置行间距)
        flowLayout.minimumLineSpacing = 15;
        //确定纵向间距(设置列间距)
        flowLayout.minimumInteritemSpacing = 10;
        //确定距离上左下右的距离
        flowLayout.sectionInset = UIEdgeInsetsMake(15,15,15,15);
        //头尾部高度
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        flowLayout.footerReferenceSize = CGSizeMake(0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        /// 注册工具栏视图
        [_collectionView registerClass:[YKTemplateSecondCollectionViewCell class] forCellWithReuseIdentifier:[YKTemplateSecondCollectionViewCell reuseIdentifier]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = YES;
    }
    return _collectionView;
}

@end

@implementation YKTemplateSecondCollectionViewCell
/// 方块视图的缓存池标示
+ (NSString *)reuseIdentifier{
    static NSString *reuseIdentifier = @"YKTemplateSecondCollectionViewCell";
    return reuseIdentifier;
}

//获取方块视图对象
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    YKTemplateSecondCollectionViewCell *tools=[collectionView dequeueReusableCellWithReuseIdentifier:[YKTemplateSecondCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    return tools;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kWhiteColor;
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = kWhiteColor;
        [self initView];
    }
    return self;
}

- (void) initView{
    self.layer.borderColor = kColorWithRGB(199, 167, 101).CGColor;
    self.layer.borderWidth = 0.5;
    [self lz_setCornerRadius:3.0];
//    [self addSubview:self.titlelabel];
    [self addSubview:self.selectedButton];
    [self addSubview:self.addButton];
//    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.equalTo(self);
//    }];
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titlelabel;
}

- (UIButton *)selectedButton{
    if (!_selectedButton) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedButton.titleLabel.font = kFontSizeMedium15;
        [_selectedButton setTitleColor:kTextColor51  forState:UIControlStateNormal];
        [_selectedButton setBackgroundImage:kGetImage(@"passenger_btn_selected") forState:UIControlStateSelected];
        [_selectedButton setBackgroundImage:imageColor(kClearColor) forState:UIControlStateNormal];
        _selectedButton.selected = YES;
        _selectedButton.hidden = YES;
    }
    return _selectedButton;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.titleLabel.font = kFontSizeMedium15;
        [_addButton setTitleColor:kColorWithRGB(199, 167, 101)  forState:UIControlStateNormal];
        [_addButton setTitle:@"新增" forState:UIControlStateNormal];
        [_addButton setImage:kGetImage(@"passenger_btn_add") forState:UIControlStateNormal];
        [Utils lz_setButtonTitleWithImageEdgeInsets:_addButton postition:kMVImagePositionLeft spacing:5.0];
        _addButton.hidden = YES;
    }
    return _addButton;
}
@end
