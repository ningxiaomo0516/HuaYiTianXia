//
//  TXChoosePaySingleView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/27.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXChoosePaySingleView.h"
static NSString * const reuseIdentifier = @"MVChooseTableViewCell";
@interface TXChoosePaySingleView()
@property(nonatomic,strong)NSDictionary *cellDic;//设置cell的identifier，防止重用
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
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(100));
    }];
}

#pragma UITableViewDelegate - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"reuseIdentifier%ld",(long)indexPath.row];
    TXChoosePayCell * tools = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!tools) {
        tools = [[TXChoosePayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
    tools.payModel = [self.dataArray objectAtIndex:indexPath.row];
    if ([self.chooseContent isEqualToString:tools.titleLabel.text]) {
        [tools updateCellWithStatus:YES];
    } else{
        [tools updateCellWithStatus:NO];
    }
    return tools;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentSelectIndex!=nil&&_currentSelectIndex != indexPath) {
        NSIndexPath *  beforIndexPath = [NSIndexPath indexPathForRow:_currentSelectIndex.row inSection:0];
        //如果之前decell在当前屏幕，把之前选中cell的状态取消掉
        TXChoosePayCell * tools = [tableView cellForRowAtIndexPath:beforIndexPath];
        [tools updateCellWithStatus:NO];
        tools.titleLabel.textColor = kColorWithRGB(34, 34, 34);
    }
    TXChoosePayCell *tools = [tableView cellForRowAtIndexPath:indexPath];
    tools.titleLabel.textColor = kColorWithRGB(255, 65, 99);
    [tools updateCellWithStatus:!tools.isSelected];
    self.chooseContent = tools.titleLabel.text;
    ChoosePayModel *musicModel = [self.dataArray objectAtIndex:indexPath.row];
    _currentSelectIndex = indexPath;
    _chooseBlock(self.chooseContent,musicModel.kid);
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXChoosePayCell class] forCellReuseIdentifier:reuseIdentifier];
        // 拖动tableView时收起键盘
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setPayModel:(ChoosePayModel *)payModel{
    _payModel = payModel;
    self.imagesView.image = kGetImage(payModel.imageName);
    self.titleLabel.text = self.payModel.titleName;
    self.selectBtn.hidden = YES;
}

- (void)initView{
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectBtn];
    CGFloat margin = IPHONE6_W(15);
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(margin));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView.mas_right).offset(-margin);
//        make.centerY.centerX.equalTo(self.contentView);
        make.left.equalTo(@(margin));
        make.centerY.equalTo(self.contentView);
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
