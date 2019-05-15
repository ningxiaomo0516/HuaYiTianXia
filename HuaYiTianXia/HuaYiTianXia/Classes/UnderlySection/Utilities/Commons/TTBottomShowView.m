//
//  TTBottomShowView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/15.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBottomShowView.h"
#import "TXChoosePayTableViewCell.h"


static NSString * const reuseIdentifierChoosePay = @"TXChoosePayTableViewCell";
@interface TTBottomShowView ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation TTBottomShowView
- (UIView *)initMaskView{
    self.defaultHeight = 180+kSafeAreaBottomHeight;
    [self initView];
    return self;
}

- (void)initView{
    self.hidden = YES;
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavBarHeight);
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    
    self.maskView = [[UIView alloc] init];
    self.maskView.frame = CGRectMake(0, self.height, self.width, self.defaultHeight);
    self.maskView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.maskView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(kScreenWidth - 40, 10, 30, 30);
    cancelBtn.tag = 1;
    [cancelBtn setImage:kGetImage(@"c31_btn_close") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:cancelBtn];
    
    [self.maskView addSubview:self.titleLabel];
    [self.maskView addSubview:self.subtitleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, kScreenWidth, 0.5)];
    lineView.backgroundColor = kLinerViewColor;
    [self.maskView addSubview:(lineView)];
    
    [self.maskView addSubview:self.tableView];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(30));
        make.centerX.equalTo(self);
        make.top.equalTo(@(10));
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(30));
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.maskView);
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(self.maskView.mas_bottom);
    }];
    
    NSString *text = @"需支付定金:￥";
    NSString *amountText = [NSString stringWithFormat:@"%@%@",text,self.amountText];

    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:amountText];
    /// 前面文字颜色
    [mutableAttr addAttribute:NSForegroundColorAttributeName
                        value:kTextColor51
                        range:NSMakeRange(0, amountText.length-text.length)];
    self.subtitleLabel.attributedText = mutableAttr;
}

- (void)addAnimate{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.frame = CGRectMake(0, self.height - self.defaultHeight, self.width, self.defaultHeight);
    }];
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view{
    if (!view) {
        return;
    }
    [view addSubview:self];
    [self addAnimate];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.frame = CGRectMake(0, self.height, self.width, self.defaultHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


/// 去掉弹窗保留蒙版的手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass(touch.view.classForCoder) isEqualToString: @"UITableViewCellContentView"] || touch.view == self.maskView ) {
        return NO;
    }
    return YES;
}


#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXGeneralModel *model = self.dataArray[indexPath.row];
    TXChoosePayTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierChoosePay forIndexPath:indexPath];
    tools.titleLabel.text = model.title;
    tools.imagesView.image = kGetImage(model.imageText);
    tools.linerView.hidden = YES;
    return tools;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectBlock(indexPath.row);
    [self disMissView];
    TTLog(@"indexPath === %ld",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,IPHONE6_W(15),0,0)];
        [_tableView registerClass:[TXChoosePayTableViewCell class] forCellReuseIdentifier:reuseIdentifierChoosePay];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kWhiteColor;
        [Utils lz_setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@"支付宝",@"微信支付"];
        NSArray* classArr = @[@"c31_btn_zfb",@"c31_btn_wxzf"];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:j];
            generalModel.imageText = [classArr lz_safeObjectAtIndex:j];
            [_dataArray addObject:generalModel];
        }
    }
    return _dataArray;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"选择支付方式" color:kTextColor51 font:kFontSizeMedium15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"需支付定金:￥0" color:HexString(@"#FC9B33") font:kFontSizeMedium15];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subtitleLabel;
}

@end
