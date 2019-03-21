//
//  TXTopupViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTopupViewController.h"

@interface TXTopupViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *saveButton;
/// 标签数组(按钮文字)
@property (nonatomic, strong) NSArray *markArray;
/// 按钮数组
@property (nonatomic, strong) NSMutableArray *btnArray;
/// 选中按钮
@property (nonatomic, strong) UIButton *selectedBtn;

/// 标题文字
@property (strong, nonatomic) UILabel *titlelabel;
/// 输入框
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *btnsBgView;
@end

@implementation TXTopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.view.backgroundColor = kWhiteColor;
    [self addGesture];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self addGesture];
}

#pragma mark 给当前view添加识别手势
#pragma mark -- 当前tableView中带有输入框点击背景关闭键盘
-(void)addGesture {
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self.scrollView addGestureRecognizer:tapGesture];
    tapGesture.cancelsTouchesInView = NO;
}

-(void)tapGesture {
    [kKeyWindow endEditing:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (range.location + string.length > 16) {
//        return NO;
//    }
    for (UIButton *btn in self.btnsBgView.subviews) {
        btn.selected = NO;
        btn.backgroundColor = kClearColor;
    }
    return YES;
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    
}

- (void) initView{
    [self.view addSubview:self.scrollView];
    // 按钮背景
    UIView *btnsBgView = [UIView lz_viewWithColor:kClearColor];
    btnsBgView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    [self.scrollView addSubview:btnsBgView];
    [self.scrollView addSubview:self.titlelabel];
    [self.scrollView addSubview:self.textField];

    UIView *linerView = [UIView lz_viewWithColor:kTextColor238];
    [btnsBgView addSubview:linerView];
    linerView.frame = CGRectMake(15, CGRectGetMaxY(btnsBgView.frame), (kScreenWidth-15*2), 0.7);
    
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnsBgView);
        make.left.equalTo(linerView);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.bottom.equalTo(btnsBgView);
        make.left.equalTo(self.view).offset(IPHONE6_W(100));
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    [self setupRadioBtnView:CGRectGetMaxY(btnsBgView.frame)+15];
}


- (void)chooseMark:(UIButton *)sender{
    TTLog(@"选中的充值金额:%@",sender.titleLabel.text);
    self.textField.text = self.markArray[sender.tag];
    self.selectedBtn = sender;
    sender.selected = !sender.selected;
    for (NSInteger j = 0; j < [self.btnArray count]; j++) {
        UIButton *btn = self.btnArray[j] ;
        if (sender.tag == j) {
            btn.backgroundColor = HexString(@"#8ED9FC");
            btn.selected = YES;
        } else {
            btn.selected = NO;
            btn.backgroundColor = kClearColor;
        }
    }
}

- (void)setupRadioBtnView:(CGFloat) viewY {
    CGFloat marginX = 15;
    CGFloat marginY = 10;
    CGFloat btnH = 50;
    CGFloat width = (kScreenWidth - marginX * 4) / 3;
    /// 进位法，得到有多少列
    CGFloat idx = self.markArray.count/3.0;
    NSInteger idxs = (int)ceilf(idx);
    
    // 按钮背景
    self.btnsBgView.frame = CGRectMake(0, viewY, kScreenWidth, marginY + idxs*(btnH + marginY));
    [self.scrollView addSubview:self.btnsBgView];
    
    // 循环创建按钮
    NSInteger maxCol = 3;
    for (NSInteger i = 0; i < self.markArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = kClearColor;
        [btn setBorderColor:HexString(@"#8ED9FC")];
        [btn setBorderWidth:1.0];
        [btn lz_setCornerRadius:5.0];
        btn.clipsToBounds = YES;
        btn.titleLabel.font = kFontSizeMedium15;
        [btn setTitleColor:HexString(@"#30322F") forState:UIControlStateNormal];
        [btn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(chooseMark:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger col = i % maxCol; //列
        btn.x = marginX + col * (width + marginX);
        NSInteger row = i / maxCol; //行
        btn.y = marginY + row * (btnH + marginY);
        btn.width = width;
        btn.height = btnH;
        [btn setTitle:[NSString stringWithFormat:@"%@元",self.markArray[i]] forState:UIControlStateNormal];
        [self.btnsBgView addSubview:btn];
        btn.tag = i;
        [self.btnArray addObject:btn];
    }
    
    [self.scrollView addSubview:self.saveButton];
    CGFloat btnsBgViewY = CGRectGetMaxY(self.btnsBgView.frame)+30;
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(btnsBgViewY));
        make.left.equalTo(@(15));
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(45));
    }];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = kWhiteColor;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+1);
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [UITextField lz_textFieldWithPlaceHolder:@"请输入充值金额"];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.delegate = self;
        _textField.font = kFontSizeMedium15;
    }
    return _textField;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51  font:kFontSizeMedium15];
        _titlelabel.text = @"充值金额";
    }
    return _titlelabel;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kFontSizeMedium15;
        [_saveButton setTitle:@"充值" forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:kGetImage(@"c31_denglu") forState:UIControlStateNormal];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf saveBtnClick:self.saveButton];
        }];
    }
    return _saveButton;
}

- (UIView *)btnsBgView{
    if (!_btnsBgView) {
        _btnsBgView = [UIView lz_viewWithColor:kClearColor];
    }
    return _btnsBgView;
}

#pragma mark - 懒加载
- (NSArray *)markArray {
    if (!_markArray) {
        NSArray *array = [NSArray array];
        array = @[@"300", @"500", @"5000", @"10000", @"20000",@"100000",@"200000",@"300000"];
        _markArray = array;
    }
    return _markArray;
}

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

@end
