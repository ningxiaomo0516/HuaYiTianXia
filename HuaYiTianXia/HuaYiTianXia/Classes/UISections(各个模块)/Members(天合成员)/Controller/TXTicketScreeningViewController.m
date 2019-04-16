//
//  TXTicketScreeningViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTicketScreeningViewController.h"
#import "LZDatePickerView.h"
#import "TXTicketListViewController.h"

@interface TXTicketScreeningViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
/// 出发地
@property (strong, nonatomic) UITextField *CFTextField;
/// 目的地
@property (strong, nonatomic) UITextField *MDTextField;
@property (strong, nonatomic) UIView *cellView;
@property (strong, nonatomic) UIView *cellViews;
@property (strong, nonatomic) UILabel *datelabel;
@property (nonatomic, strong) UIButton *saveButton;
//// 转换按钮
@property (nonatomic, strong) UIButton *conversionBtn;
@property (nonatomic, strong) UIImageView *imagesArrow;

@end

@implementation TXTicketScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"机票查询";
    self.view.backgroundColor = kViewColorNormal;
    [self addGesture];
    [self initView];
    self.datelabel.text = [Utils lz_getCurrentDate];
}

/** 保存 */
- (void) saveBtnClick{
    
    NSString *startPlace= self.CFTextField.text;
    NSString *endPlace = self.MDTextField.text;
    
    if (startPlace.length == 0) {
        Toast(@"请输入出发地");
        return;
    }
    if (endPlace.length == 0) {
        Toast(@"请输入目的地");
        return;
    }
    NSString *URLString = @"https://api.shenjian.io/?appid=7c0ec630c4f4bd5179c8978365d999da";
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.CFTextField.text forKey:@"fromCity"];
    [parameter setObject:self.MDTextField.text forKey:@"toCity"];
    [parameter setObject:self.datelabel.text forKey:@"date"];
    /// 机票查询接口
    TXTicketListViewController *vc = [[TXTicketListViewController alloc] initTicketListWithURLString:URLString parameter:parameter];
    TTPushVC(vc);
}

/// 选择机票查询日期
- (void) showDataPicker{
    
    NSString *minDateStr = [Utils lz_getCurrentTime];
    NSString *maxDateStr = @"";
    NSString *defaultSelValue = self.datelabel.text;
    MV(weakSelf)
    /**
     *  显示时间选择器
     *
     *  @param title            标题
     *  @param type             类型（时间、日期、日期和时间、倒计时）
     *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
     *  @param minDateStr       最小时间（如：2015-08-28 00:00:00），可为空
     *  @param maxDateStr       最大时间（如：2018-05-05 00:00:00），可为空
     *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
     *  @param resultBlock      选择结果的回调
     *
     */
    [LZDatePickerView showDatePickerWithTitle:@"" dateType:UIDatePickerModeDate defaultSelValue:defaultSelValue minDateStr:minDateStr maxDateStr:maxDateStr isAutoSelect:NO resultBlock:^(NSString *selectValue) {
            weakSelf.datelabel.text = selectValue;
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self addGesture];
}

//// init View
- (void) initView{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.cellView];
    [self.scrollView addSubview:self.cellViews];
    [self.cellView addSubview:self.CFTextField];
    [self.cellView addSubview:self.MDTextField];
    [self.scrollView addSubview:self.conversionBtn];
    
    [self.cellViews addSubview:self.datelabel];
    [self.cellViews addSubview:self.imagesArrow];
    
    [self.scrollView addSubview:self.saveButton];
    
    [self.cellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(IPHONE6_W(20));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(IPHONE6_W(50));
    }];
    [self.CFTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(IPHONE6_W(13));
        make.height.centerY.mas_equalTo(self.cellView);
        make.width.equalTo(self.MDTextField.mas_width);
    }];
    
    [self.conversionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.cellView);
    }];
    
    [self.MDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.CFTextField.mas_right).offset(IPHONE6_W(60));
        make.right.mas_equalTo(self.cellView.mas_right).mas_offset(IPHONE6_W(-20));
        make.height.centerY.mas_equalTo(self.cellView);
        make.width.equalTo(self.CFTextField.mas_width);
    }];
    [self.cellViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cellView.mas_bottom).offset(0.5);
        make.height.left.right.mas_equalTo(self.cellView);
    }];
    [self.datelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cellViews);
        make.left.equalTo(self.CFTextField);
    }];
    
    [self.imagesArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cellViews);
        make.right.mas_equalTo(self.cellViews.mas_right).mas_offset(IPHONE6_W(-20));
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(IPHONE6_W(45)));
        make.left.equalTo(@(50));
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.top.equalTo(self.cellViews.mas_bottom).offset(100);
    }];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = kTextColor244;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+1);
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

- (UIView *)cellView{
    if (!_cellView) {
        _cellView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _cellView;
}

- (UIView *)cellViews{
    if (!_cellViews) {
        _cellViews = [UIView lz_viewWithColor:kWhiteColor];
        _cellViews.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDataPicker)];
        [_cellViews addGestureRecognizer:tapGesture];
    }
    return _cellViews;
}

- (UITextField *)CFTextField{
    if (!_CFTextField) {
        _CFTextField = [UITextField lz_textFieldWithPlaceHolder:@"出发地"];
        _CFTextField.returnKeyType = UIReturnKeyDone;
        _CFTextField.borderStyle = UITextBorderStyleNone;
        _CFTextField.textColor = kTextColor51;
        _CFTextField.delegate = self;
        _CFTextField.font = kFontSizeMedium15;
    }
    return _CFTextField;
}

- (UITextField *)MDTextField{
    if (!_MDTextField) {
        _MDTextField = [UITextField lz_textFieldWithPlaceHolder:@"目的地"];
        _MDTextField.returnKeyType = UIReturnKeyDone;
        _MDTextField.borderStyle = UITextBorderStyleNone;
        _MDTextField.textColor = kTextColor51;
        _MDTextField.textAlignment = NSTextAlignmentRight;
        _MDTextField.delegate = self;
        _MDTextField.font = kFontSizeMedium15;
    }
    return _MDTextField;
}

- (UILabel *)datelabel{
    if (!_datelabel) {
        _datelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _datelabel;
}

- (UIButton *)conversionBtn{
    if (!_conversionBtn) {
        _conversionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_conversionBtn setImage:kGetImage(@"往返") forState:UIControlStateNormal];
    }
    return _conversionBtn;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kFontSizeMedium15;
        _saveButton.tag = 2;
        [_saveButton setTitle:@"开始搜索" forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:kGetImage(@"c31_denglu") forState:UIControlStateNormal];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf saveBtnClick];
        }];
    }
    return _saveButton;
}

- (UIImageView *)imagesArrow{
    if (!_imagesArrow) {
        _imagesArrow = [[UIImageView alloc] init];
        _imagesArrow.image = kGetImage(@"mine_btn_enter");
    }
    return _imagesArrow;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
