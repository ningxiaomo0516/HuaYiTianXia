//
//  TXModifyUserInfoViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXModifyUserInfoViewController.h"
#import "TXGeneralModel.h"

@interface TXModifyUserInfoViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *cellView;
@property (strong, nonatomic) UILabel *titlelabel;

@end

@implementation TXModifyUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorWithRGB(234, 235, 236);
    
    [self addGesture];
    [self initView];
    self.textField.text = kUserInfo.username;
    
    // 添加右边保存按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    
    // 添加左边保存按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    
}

/** 取消(关闭界面) */
- (void) cancelBtnClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self addGesture];
}

/** 保存 */
- (void) saveBtnClick{
    
    NSString *nickname = self.textField.text;
    
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
    if (self.block) {
        self.block(self.textField.text);
    }
    [self updateUserInfoDataRequest];
}

- (void) updateUserInfoDataRequest{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.textField.text forKey:@"nickName"];
    [parameter setObject:kUserInfo.avatar forKey:@"headImg"];
//    [MBProgressHUD showMessage:@"" toView:self.view];
    kShowMBProgressHUD(self.view);
    [SCHttpTools postWithURLString:kHttpURL(@"customer/UpdateUserData") parameter:parameter success:^(id responseObject) {
        NSDictionary *result  = responseObject;
//        [MBProgressHUD hideHUDForView:self.view];
        TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
        if (result){
            TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
            if (model.errorcode==20000) {
                Toast(@"信息修改成功");
                if (self.block) {
                    self.block(self.textField.text);
                }
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
    [self.scrollView addSubview:self.cellView];
    [self.cellView addSubview:self.textField];
    [self.scrollView addSubview:self.titlelabel];
    
    
    [self.cellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(IPHONE6_W(15));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(IPHONE6_W(50));
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(IPHONE6_W(13));
        make.right.mas_equalTo(self.cellView.mas_right).mas_offset(IPHONE6_W(-13));
        make.height.centerY.centerX.mas_equalTo(self.cellView);
    }];
    
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField);
        make.top.equalTo(self.cellView.mas_bottom).offset(IPHONE6_W(10));
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

- (UITextField *)textField{
    if (!_textField) {
        _textField = [UITextField lz_textFieldWithPlaceHolder:@"请输入昵称"];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.delegate = self;
        _textField.text = self.nickname;
        _textField.font = kFontSizeMedium13;
    }
    return _textField;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor128 font:kFontSizeMedium13];
        _titlelabel.text = @"昵称规则4-20个字符，可由中文、数字、组成";
    }
    return _titlelabel;
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
