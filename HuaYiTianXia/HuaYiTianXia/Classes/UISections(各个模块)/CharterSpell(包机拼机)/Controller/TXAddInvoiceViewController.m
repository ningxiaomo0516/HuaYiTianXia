//
//  TXAddInvoiceViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/9.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXAddInvoiceViewController.h"
#import "TXGeneralModel.h"

@interface TXAddInvoiceViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *textField1;
@property (strong, nonatomic) UITextField *textField2;
@property (strong, nonatomic) UIView *cellView1;
@property (strong, nonatomic) UIView *cellView2;
@property (strong, nonatomic) UILabel *titlelabel;
@property (strong, nonatomic) UILabel *titlelabel1;
@property (strong, nonatomic) UILabel *titlelabel2;

@end

@implementation TXAddInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorWithRGB(234, 235, 236);
    
    [self addGesture];
    [self initView];
    self.textField1.text = kUserInfo.username;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self addGesture];
}

/** 保存 */
- (void) saveBtnClick{
    
    NSString *nickname = self.textField1.text;
    if (nickname.length == 0) {
        Toast(@"昵称为空");
        return;
    }
    
    NSInteger length = [SCSmallTools convertToInt:nickname];
    if (length < 2) {
        Toast(@"昵称长度不够哦");
        return;
    }
    if (length > 20) {
        Toast(@"昵称长度超过20个字符了");
        return;
    }
//    if (self.block) {
//        self.block(self.textField.text);
//    }
    [self updateUserInfoDataRequest];
}

- (void) updateUserInfoDataRequest{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.textField1.text forKey:@"nickName"];
    [parameter setObject:kUserInfo.avatar forKey:@"headImg"];
    //    [MBProgressHUD showMessage:@"" toView:self.view];
    kShowMBProgressHUD(self.view);
    [SCHttpTools postWithURLString:kHttpURL(@"customer/UpdateUserData") parameter:parameter success:^(id responseObject) {
        NSDictionary *result  = responseObject;
        //        [MBProgressHUD hideHUDForView:self.view];
        if (result){
            TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
            if (model.errorcode==20000) {
                TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
                Toast(@"信息修改成功");
//                if (self.block) {
//                    self.block(self.textField.text);
//                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                Toast(model.message);
            }
        }
        kHideMBProgressHUD(self.view);;
    } failure:^(NSError *error) {
        //        [MBProgressHUD hideHUDForView:self.view];
        TTLog(@"修改信息 -- %@", error);
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
    [self.scrollView addSubview:self.titlelabel];
    
    
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
        make.left.mas_equalTo(self.titlelabel1.mas_right).offset(5);
        make.right.mas_equalTo(self.cellView1.mas_right).mas_offset(IPHONE6_W(-13));
        make.height.centerY.centerX.mas_equalTo(self.cellView1);
    }];
    
    [self.cellView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cellView1.mas_bottom).offset(0.7);
        make.left.right.mas_equalTo(self.cellView1);
    }];
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.textField1);
        make.height.centerY.centerX.mas_equalTo(self.cellView2);
    }];
    [self.titlelabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titlelabel1);
        make.centerY.equalTo(self.cellView2);
    }];
    
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField1);
        make.top.equalTo(self.cellView2.mas_bottom).offset(IPHONE6_W(10));
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
        _textField2.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField2.borderStyle = UITextBorderStyleNone;
        _textField2.delegate = self;
        _textField2.font = kFontSizeMedium13;
    }
    return _textField2;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor128 font:kFontSizeMedium13];
        _titlelabel.text = @"昵称规则4-20个字符，可由中文、数字、组成";
    }
    return _titlelabel;
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
