//
//  TXChoosePaySingleView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/27.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXChoosePaySingleView.h"
@interface TXChoosePaySingleView()
@end

@class ChoosePayModel;
@implementation TXChoosePaySingleView
+ (TXChoosePaySingleView *)initTableWithFrame:(CGRect)frame{
    TXChoosePaySingleView *SingleView = [[TXChoosePaySingleView alloc]initWithViewFrame:frame];
    return SingleView;
}

- (instancetype)initWithViewFrame:(CGRect)frame{
    self = [super init];
    if(self){
        self.frame = frame;
        [self initView];
    }
    return self;
}

- (void)initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.top.equalTo(self);
    }];
}

#pragma UITableViewDelegate - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TXChoosePayCell *tools = [TXChoosePayCell cellWithTableViewCell:tableView forIndexPath:indexPath];
    tools.payModel = [self.dataArray objectAtIndex:indexPath.row];
    /// 默认选中第一行
    if (self.index == indexPath.row ||indexPath.row==0) {
        [tools updateCellWithStatus:YES];
        _currentSelectIndex = indexPath;
        self.index = indexPath.row;
    } else{
        [tools updateCellWithStatus:NO];
    }
    return tools;
}

#pragma mark -------------- 设置组头 --------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TXChoosePayHeaderView *sectionView = [[TXChoosePayHeaderView alloc] init];
    sectionView.section = section;
    sectionView.tableView = tableView;
    sectionView.titleLabel.text = @"选择支付方式";
    return sectionView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentSelectIndex!=nil&&_currentSelectIndex != indexPath) {
        NSIndexPath *  beforIndexPath = [NSIndexPath indexPathForRow:_currentSelectIndex.row inSection:0];
        //如果之前的cell在当前屏幕，把之前选中cell的状态取消掉
        TXChoosePayCell * tools = [tableView cellForRowAtIndexPath:beforIndexPath];
        [tools updateCellWithStatus:NO];
    }
    TXChoosePayCell *tools = [tableView cellForRowAtIndexPath:indexPath];
    if (self.index != indexPath.row) {
        [tools updateCellWithStatus:!tools.isSelected];
        self.index = indexPath.row;
        ChoosePayModel *musicModel = [self.dataArray objectAtIndex:indexPath.row];
        _currentSelectIndex = indexPath;
        self.chooseBlock(musicModel);
    }else{
        TTLog(@"点击的是当前选中行");
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_tableView registerClass:[TXChoosePayCell class] forCellReuseIdentifier:[TXChoosePayCell reuseIdentifier]];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (void)reloadData{
    [self.tableView reloadData];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *titleArray = @[@"支付宝",@"微信"];
        NSArray *imageArray = @[@"c31_btn_zfb",@"c31_btn_wxzf"];
        for (int i = 0; i < titleArray.count; i ++) {
            ChoosePayModel *music = [[ChoosePayModel alloc] init];
            music.kid = [NSString stringWithFormat:@"%d",i];
            music.titleName = [titleArray lz_safeObjectAtIndex:i];
            music.imageName = [imageArray lz_safeObjectAtIndex:i];
            [_dataArray addObject:music];
        }
    }
    return _dataArray;
}
@end


@implementation TXChoosePayCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, [UIColor lz_colorWithHex:0xf7f7f7].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5));
}

/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier{
    static NSString *reuseIdentifier = @"TXChoosePayCell";
    return reuseIdentifier;
}

/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = [TXChoosePayCell reuseIdentifier];
    TXChoosePayCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return tools;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)setPayModel:(ChoosePayModel *)payModel{
    _payModel = payModel;
    self.imagesView.image = kGetImage(payModel.imageName);
    self.titleLabel.text = self.payModel.titleName;
}

- (void)initView{
    [self addSubview:self.imagesView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.selectBtn];
    CGFloat margin = IPHONE6_W(15);
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(margin));
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-margin);
        make.centerY.equalTo(self);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:kGetImage(@"mine_btn_normal") forState:UIControlStateNormal];
        [_selectBtn setImage:kGetImage(@"mine_btn_selected") forState:UIControlStateSelected];
        _selectBtn.userInteractionEnabled = NO;
    }
    return _selectBtn;
}


- (void)updateCellWithStatus:(BOOL)select{
    self.selectBtn.selected = select;
    _isSelected = select;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end


@implementation ChoosePayModel


@end


@implementation TXChoosePayHeaderView
- (void)setFrame:(CGRect)frame{
    CGRect sectionRect = [self.tableView rectForSection:self.section];
    CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect), CGRectGetWidth(frame), CGRectGetHeight(frame));
    [self initView];
    self.backgroundView = ({
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = kWhiteColor;
        view;
    });
    [super setFrame:newFrame];
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.linerView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(15));
    }];
    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kLinerViewHeight));
        make.left.bottom.right.equalTo(self);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium14];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    };
    return _titleLabel;
}

- (UIView *)linerView{
    if (!_linerView) {
        _linerView = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView;
}
@end
