//
//  TXCourseReservationView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCourseReservationView.h"

@interface TXCourseReservationView()<UIScrollViewDelegate,UITextFieldDelegate,TTTagViewDelegate>
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) UIView *contentView;
@end

@implementation TXCourseReservationView

- (id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        [self initContent];
        _viewHeight = kScreenHeight - kScreenHeight/3;  // 弹出View的高度
        _viewY = kScreenHeight - _viewHeight;
        
        [self addGesture];
    }
    
    return self;
}

- (void)initContent{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, _viewY, kScreenWidth, _viewHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        // 获取打赏礼物列表数据
//        [YYMonitorKeyboard YYAddMonitorWithShowBack:^(NSInteger height) {
//            _contentView.frame = CGRectMake(0, KScreenHeight- _viewHeight -height,kScreenWidth,_viewHeight);
//            TTLog(@"键盘出现了 == %ld",(long)height);
//        } andDismissBlock:^(NSInteger height) {
//            _contentView.frame = CGRectMake(0, KScreenHeight-_viewHeight,KScreenWidth,_viewHeight);
//            TTLog(@"键盘消失了 == %ld",(long)height);
//        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self initView];
    
}

- (void) initView{
    UILabel *titlelabel = [UILabel lz_labelWithTitle:@"赠送礼物" color:kTextColor51 font:kFontSizeScBold17];
    [_contentView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@(44));
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"c31_btn_close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
    [_contentView insertSubview:cancelBtn atIndex:10];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.height.width.equalTo(@(44));
    }];
    
    [self.contentView addSubview:self.usernameTextField];
    
    // 赠送按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(kScreenWidth-100-10, 6, 100, 44);
    [saveButton setBackgroundImage:imageColor(kColorWithRGB(36, 134, 210)) forState:UIControlStateNormal];
    [saveButton setTitle:@"赠送" forState:UIControlStateNormal];
    [saveButton lz_setCornerRadius:22.0];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:saveButton];
    
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@(44));
        make.bottom.equalTo(@(-40-kSafeAreaBottomHeight));
    }];

    
    self.tagView1.dataArray = @[@"锤子",@"见过",@"膜拜单车",@"见过",@"膜拜单车",@"见过",@"膜拜单车"];
    self.tagView1.dataArray = @[@"打的费",@"回填土",@"玩儿翁热",@"打断点"];
    [self.contentView addSubview:self.boxView1];
    [self.contentView addSubview:self.boxView2];
    [self.boxView1 addSubview:self.tagView1];
    [self.boxView2 addSubview:self.tagView2];
    
    self.boxView1.backgroundColor = kRandomColor;
    self.boxView2.backgroundColor = kRandomColor;
    
    [self.boxView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(@(50));
        make.height.equalTo(@(CGRectGetMaxY(self.tagView1.frame)));
    }];
    [self.boxView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(@(50));
        make.height.equalTo(@(CGRectGetMaxY(self.tagView2.frame)));
    }];
    [self.tagView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(100));
        make.bottom.top.right.equalTo(self.boxView1);
    }];
    TTLog(@"----- %f",CGRectGetHeight(self.tagView1.frame));

}


/// 点击标签的事件
- (void)handleSelectTag:(NSString *)keyWord{
    TTLog(@"keyWord ---- %@",keyWord);
}

- (void) stopAnimating{
    self.activityIndicator.hidden = YES;
    UIView *view = (UIView *)[_contentView viewWithTag:103];
    [view removeFromSuperview];
}

- (void) saveButtonClick:(UIButton *) sender{
//    if(self.delegate && [self.delegate respondsToSelector:@selector(DidGivingButtonClick:)]){
//        [self.delegate DidGivingButtonClick:self];
//    }
}


#pragma mark keyboard notification
- (void)keyboardWillShow:(NSNotification *)notif {
    
    NSDictionary *userInfo = [notif userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat y = keyboardRect.size.height;
    
    CGFloat x = keyboardRect.size.width;
    TTLog(@"键盘高度是  %d",(int)y);
    TTLog(@"键盘宽度是  %d",(int)x);
    
    //    _difference = 0.0;
    //    if ([_textField isFirstResponder] == true && (self.height - (_textField.frame.origin.y + 37 + 10) < y)) {
    //        self.difference = y - (self.height - (_textField.frame.origin.y + 37 + 5));
    //        [UIView animateWithDuration:0.25f animations:^{
    //            _contentView.frame = CGRectMake(0, _textField.frame.origin.y - self.difference, _width - 100,37);
    //        }];
    //    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    //    if (self.difference > 0) {
    //        [UIView animateWithDuration:0.25f animations:^{
    //            _contentView.frame = CGRectMake(10,_height - 100,_width - 100,37);
    //        }];
    //        self.difference = 0;
    //    }
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    [view addSubview:self];
    [view addSubview:_contentView];
    [_contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, _viewHeight)];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        [self.contentView setFrame:CGRectMake(0, self.viewY, kScreenWidth, self.viewHeight)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    [_contentView setFrame:CGRectMake(0, _viewY, kScreenWidth, _viewHeight)];
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.0;
        [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, self.viewHeight)];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [self.contentView removeFromSuperview];
    }];
}


//调用：
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.usernameTextField) {
//        return NO;
    }
    return YES;
}

#pragma mark 给当前view添加识别手势
#pragma mark -- 当前tableView中带有输入框点击背景关闭键盘
- (void)addGesture {
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    [self.contentView addGestureRecognizer:tapGesture];
}

- (void)tapGesture {
    [self.contentView endEditing:YES];
}

#pragma setter/getter
- (UIView *)boxView1{
    if (!_boxView1) {
        _boxView1 = [UIView lz_viewWithColor:kWhiteColor];
        UILabel *titlelabel = [UILabel lz_labelWithTitle:@"课程选择" color:kTextColor51 font:kFontSizeScBold17];
        [_boxView1 addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@(15));
        }];
    }
    return _boxView1;
}

- (UIView *)boxView2{
    if (!_boxView2) {
        _boxView2 = [UIView lz_viewWithColor:kWhiteColor];
        UILabel *titlelabel = [UILabel lz_labelWithTitle:@"机型选择" color:kTextColor51 font:kFontSizeScBold17];
        [_boxView2 addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@(15));
        }];
    }
    return _boxView2;
}

- (UILabel *)usernameLabel{
    if (!_usernameLabel) {
        _usernameLabel = [UILabel lz_labelWithTitle:@"姓名" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _usernameLabel;
}

- (UILabel *)telphoneLabel{
    if (!_telphoneLabel) {
        _telphoneLabel = [UILabel lz_labelWithTitle:@"联系电话" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _telphoneLabel;
}

- (UITextField *)usernameTextField{
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc] init];
        _usernameTextField.frame = CGRectMake(0, 200, self.width, 44);
        _usernameTextField.backgroundColor = kColorWithRGB(235, 235, 235);
        _usernameTextField.layer.masksToBounds = YES;
        _usernameTextField.layer.cornerRadius = 22.0;
        _usernameTextField.delegate = self;
        _usernameTextField.placeholder = @"请输姓名";
    }
    return _usernameTextField;
}

- (TTTagView *)tagView1{
    if (!_tagView1) {
        _tagView1 = [[TTTagView alloc] initWithFrame:CGRectMake(115, 0, 260, 0)];
        _tagView1.backgroundColor = kWhiteColor;
        _tagView1.isShowMore = YES;
        _tagView1.isOnClick = YES;
        _tagView1.delegate = self;
    }
    return _tagView1;
}
- (TTTagView *)tagView2{
    if (!_tagView2) {
        _tagView2 = [[TTTagView alloc] initWithFrame:CGRectMake(115, 0, 260, 0)];
        _tagView2.backgroundColor = kWhiteColor;
        _tagView2.isShowMore = YES;
        _tagView2.isOnClick = YES;
        _tagView2.delegate = self;
    }
    return _tagView1;
}
@end
