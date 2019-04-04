;//
//  TTPasswordView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/4.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTPasswordView.h"
#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
@interface TTPasswordView ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点

@end

@implementation TTPasswordView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self initPwdTextField];
        [self beginEdit];
    }
    return self;
}

- (void)initPwdTextField {
    //每个密码输入框的宽度
    CGFloat width = self.width / kDotCount;
    
    //生成分割线
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, 0, 0.5, self.height)];
        lineView.backgroundColor = kTextColor221;
        [self addSubview:lineView];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (self.height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = kTextColor51;
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    TTLog(@"变化%@", string);
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    } else if(textField.text.length >= kDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        TTLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

-(void)beginEdit{
    [self.textField becomeFirstResponder];
}

-(void)endEdit{
    [self.textField resignFirstResponder];
}

/**
 *  清除密码
 */
- (void)clearUpPassword{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField{
    TTLog(@"%@", textField.text);
    if (self.passwordBlock) {
        //将textView的值传出去
        self.passwordBlock(textField.text);
    }
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == kDotCount) {
        TTLog(@"输入完毕");
    }
}

#pragma mark - init

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _textField.backgroundColor = kWhiteColor;
        //输入的文字颜色为白色
        _textField.textColor = kWhiteColor;
        //输入框光标的颜色为白色
        _textField.tintColor = kWhiteColor;
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.layer.borderColor = [kTextColor221 CGColor];
        _textField.layer.borderWidth = 0.5;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
    }
    return _textField;
}

@end
