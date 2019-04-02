//
//  UITextField+Extension.m
//  LZExtension
//
//  Created by 寕小陌 on 2016/12/12.
//  Copyright © 2016年 寕小陌. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)
- (NSRange)tt_selectedRange {
    // 文首的位置
    UITextPosition *beginning = self.beginningOfDocument;
    
    // 内容为[start,end)，无论是否有选取区域，start都描述了光标的位置
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    // 获取以from为基准的to的偏移
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}


// 备注：UITextField必须为第一响应者才有效
- (void)tt_setSelectedRange:(NSRange)range{
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    
    // 创建一个UITextRange
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}


+ (instancetype)lz_textFieldWithPlaceHolder:(NSString *)placeHolder {
    
    UITextField *textField = [[self alloc] init];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = placeHolder;
    
    return textField;
}

/**
 *  设置UITextField左边距
 *
 *  @param leftWidth 边距
 */
- (void)lz_setTextFieldLeftPadding:(CGFloat)leftWidth
{
    CGRect frame = self.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftview;
    
}

/**
 设置UITextField 右侧清除按钮图片
 
 @param normalButtonName      常规图片名
 @param highlightedButtonName 高亮图片名
 */
- (void)lz_setTextFieldClearButtonNormal:(NSString *)normalButtonName Highlighted:(NSString *)highlightedButtonName
{
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:normalButtonName] forState:UIControlStateNormal];
    [clearButton setImage:[UIImage imageNamed:highlightedButtonName] forState:UIControlStateHighlighted];
    self.clearButtonMode = UITextFieldViewModeAlways;
    
}

/**
 *  设置UITextField Placeholder颜色
 *
 *  @param color 颜色值
 */
- (void)lz_setTextFieldPlaceholderColor:(UIColor *)color
{
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    
}

/**
 *  设置全局共用UITextField对象的指定格式
 */
+ (void)lz_setTextFieldSpecifiedformat
{
    //设置全局共用UITextField对象的指定格式（在实际开发中自定义）
    [[self alloc] lz_setTextFieldLeftPadding:10];
    
    // TODO:需要设置具体的图片
    [[self alloc] lz_setTextFieldClearButtonNormal:@"" Highlighted:@""];
    
    [[self alloc] lz_setTextFieldPlaceholderColor:[UIColor grayColor]];
    
}

@end
