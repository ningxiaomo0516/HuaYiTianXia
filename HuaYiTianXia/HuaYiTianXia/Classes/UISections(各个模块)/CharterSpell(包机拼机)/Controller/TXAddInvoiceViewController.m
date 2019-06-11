//
//  TXAddInvoiceViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/9.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXAddInvoiceViewController.h"
#import "TXGeneralModel.h"
#import "TXBaseFooterButtonView.h"

@interface TXAddInvoiceViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *textField1;
@property (strong, nonatomic) UITextField *textField2;
@property (strong, nonatomic) UIView *cellView1;
@property (strong, nonatomic) UIView *cellView2;

@property (strong, nonatomic) UILabel *titlelabel1;
@property (strong, nonatomic) UILabel *titlelabel2;

@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) InvoiceModel *invoiceModel;

@end

@implementation TXAddInvoiceViewController
- (instancetype)initInvoiceModel:(InvoiceModel *)invoiceModel{
    if ( self = [super init] ){
        self.invoiceModel = invoiceModel;
        self.textField1.text = invoiceModel.invoiceTaxNumber;
        self.textField2.text = invoiceModel.invoiceRise;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorWithRGB(234, 235, 236);
    
    [self addGesture];
    [self initView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self addGesture];
}

/** 保存 */
- (void) saveBtnClick:(UIButton *)sender{
    
    NSString *nickname = self.textField1.text;
    if (nickname.length == 0) {
        Toast(@"发票抬头不能为空");
        return;
    }
    if (self.textField2.text == 0) {
        Toast(@"发票税号不能为空");
        return;
    }
    [self updateUserInfoDataRequest];
}

- (void) updateUserInfoDataRequest{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.textField1.text forKey:@"invoiceTaxNumber"];
    [parameter setObject:self.textField2.text forKey:@"invoiceRise"];
    kShowMBProgressHUD(self.view);
    NSString *textURL = @"";
    NSString *tipsText = @"";
    if ([self.title isEqualToString:@"修改发票"]) {
        [parameter setObject:self.invoiceModel.kid forKey:@"id"];
        textURL = @"invoice/updateInvoice";
        tipsText = @"修改发票成功";
    }else{
        textURL = @"invoice/addInvoice";
        tipsText = @"添加发票成功";
    }
    [SCHttpTools postWithURLString:kHttpURL(textURL) parameter:parameter success:^(id responseObject) {
        NSDictionary *result  = responseObject;
        TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
        if (model.errorcode==20000) {
            TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
            Toast(tipsText);
            if (self.invoiceBlock) {
                self.invoiceBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            Toast(model.message);
        }
        kHideMBProgressHUD(self.view);;
    } failure:^(NSError *error) {
        kHideMBProgressHUD(self.view);;
    }];
}

- (void) initView{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.cellView1];
    [self.cellView1 addSubview:self.textField1];
    [self.cellView1 addSubview:self.titlelabel1];
    
    [self.scrollView addSubview:self.cellView2];
    [self.cellView2 addSubview:self.textField2];
    [self.cellView2 addSubview:self.titlelabel2];
    
    [self.scrollView addSubview:self.saveButton];
    [self.cellView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(IPHONE6_W(15));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(IPHONE6_W(50));
    }];
    [self.titlelabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(IPHONE6_W(13));
        make.centerY.equalTo(self.cellView1);
    }];
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(IPHONE6_W(90));
        make.right.mas_equalTo(self.cellView1.mas_right).mas_offset(IPHONE6_W(-13));
        make.height.centerY.mas_equalTo(self.cellView1);
    }];
    
    [self.cellView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cellView1.mas_bottom).offset(0.7);
        make.height.left.right.mas_equalTo(self.cellView1);
    }];
    [self.titlelabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titlelabel1);
        make.centerY.equalTo(self.cellView2);
    }];
    
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(IPHONE6_W(90));
        make.right.mas_equalTo(self.cellView2.mas_right).mas_offset(IPHONE6_W(-13));
        make.height.centerY.mas_equalTo(self.cellView2);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellView2.mas_bottom).offset(30);
        make.left.equalTo(@(IPHONE6_W(15)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-15));
        make.height.equalTo(@(45));
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

- (UIView *)cellView1{
    if (!_cellView1) {
        _cellView1 = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _cellView1;
}

- (UIView *)cellView2{
    if (!_cellView2) {
        _cellView2 = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _cellView2;
}

- (UITextField *)textField1{
    if (!_textField1) {
        _textField1 = [UITextField lz_textFieldWithPlaceHolder:@"请输入个人姓名或公司名称"];
        _textField1.returnKeyType = UIReturnKeyDone;
        _textField1.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField1.borderStyle = UITextBorderStyleNone;
        _textField1.delegate = self;
        _textField1.font = kFontSizeMedium13;
    }
    return _textField1;
}

- (UITextField *)textField2{
    if (!_textField2) {
        _textField2 = [UITextField lz_textFieldWithPlaceHolder:@"请输入发票税号"];
        _textField2.returnKeyType = UIReturnKeyDone;
        _textField2.keyboardType = UIKeyboardTypeNumberPad;
        _textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField2.borderStyle = UITextBorderStyleNone;
        _textField2.delegate = self;
        _textField2.font = kFontSizeMedium13;
    }
    return _textField2;
}

- (UILabel *)titlelabel1{
    if (!_titlelabel1) {
        _titlelabel1 = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        _titlelabel1.text = @"发票抬头";
    }
    return _titlelabel1;
}

- (UILabel *)titlelabel2{
    if (!_titlelabel2) {
        _titlelabel2 = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        _titlelabel2.text = @"发票税号";
    }
    return _titlelabel2;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kFontSizeMedium15;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_saveButton isRadius:YES];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf saveBtnClick:self.saveButton];
        }];
    }
    return _saveButton;
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
